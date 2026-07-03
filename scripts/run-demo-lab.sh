#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT="${PROJECT:-cloudops-demo}"
COMPOSE_FILE="${COMPOSE_FILE:-demo/docker-compose.demo.yml}"
ENDPOINT_FILE="${ENDPOINT_FILE:-monitoring/endpoints.demo.txt}"
REPORT_ROOT="${REPORT_ROOT:-reports/demo-lab}"
RESTORE_VOLUME="${RESTORE_VOLUME:-${PROJECT}_restore_test}"

timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
run_dir="${REPORT_ROOT}/${timestamp}"
mkdir -p "$run_dir"

log() {
  printf '[demo-lab] %s\n' "$*"
}

cleanup() {
  log "Cleaning up demo containers and restore volume"
  docker compose -p "$PROJECT" -f "$COMPOSE_FILE" down -v --remove-orphans >/dev/null 2>&1 || true
  docker volume rm "$RESTORE_VOLUME" >/dev/null 2>&1 || true
}

trap cleanup EXIT

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Required command not found: $1" >&2
    exit 1
  fi
}

require_command docker
require_command curl

log "Writing evidence to ${run_dir}"
log "Resetting demo stack"
docker compose -p "$PROJECT" -f "$COMPOSE_FILE" down -v --remove-orphans >/dev/null 2>&1 || true

log "Running compose preflight"
OUT_DIR="$run_dir" ./scripts/docker-compose-preflight.sh "$COMPOSE_FILE" | tee "${run_dir}/compose-preflight.log"

log "Starting demo app"
docker compose -p "$PROJECT" -f "$COMPOSE_FILE" up -d | tee "${run_dir}/compose-up.log"
docker compose -p "$PROJECT" -f "$COMPOSE_FILE" ps >"${run_dir}/compose-ps-running.txt"

log "Waiting for demo endpoint"
for attempt in $(seq 1 20); do
  if curl -fsS -o /dev/null http://localhost:8088; then
    break
  fi

  if [ "$attempt" -eq 20 ]; then
    echo "Demo endpoint did not become healthy" >&2
    docker compose -p "$PROJECT" -f "$COMPOSE_FILE" logs --no-color >"${run_dir}/compose-logs-failed-start.txt" || true
    exit 1
  fi

  sleep 2
done

log "Collecting diagnostics"
OUT_DIR="$run_dir" ./scripts/collect-diagnostics.sh | tee "${run_dir}/diagnostics.log"

log "Checking healthy endpoint"
./scripts/health-check.sh "$ENDPOINT_FILE" | tee "${run_dir}/health-pass.txt"

log "Simulating outage"
docker compose -p "$PROJECT" -f "$COMPOSE_FILE" stop web | tee "${run_dir}/compose-stop-web.log"
set +e
./scripts/health-check.sh "$ENDPOINT_FILE" >"${run_dir}/health-fail.txt" 2>&1
health_fail_code=$?
set -e

if [ "$health_fail_code" -eq 0 ]; then
  echo "Expected health check to fail during simulated outage" >&2
  exit 1
fi

log "Recovering service"
docker compose -p "$PROJECT" -f "$COMPOSE_FILE" start web | tee "${run_dir}/compose-start-web.log"
sleep 3
./scripts/health-check.sh "$ENDPOINT_FILE" | tee "${run_dir}/health-recovered.txt"

log "Backing up compose volumes"
./scripts/backup-compose-volumes.sh "$PROJECT" "${run_dir}/backups" | tee "${run_dir}/backup.log"
backup_dir="$(find "${run_dir}/backups" -mindepth 1 -maxdepth 1 -type d | sort | tail -1)"
archive_path="$(find "$backup_dir" -type f -name '*.tar.gz' | sort | tail -1)"

if [ -z "$archive_path" ] || [ ! -f "$archive_path" ]; then
  echo "Backup archive was not created" >&2
  exit 1
fi

(
  cd "$backup_dir"
  sha256sum -c SHA256SUMS
) | tee "${run_dir}/checksum-verify.txt"

log "Restoring backup into disposable volume"
RESTORE_CONFIRM=YES ./scripts/restore-volume-backup.sh "$archive_path" "$RESTORE_VOLUME" | tee "${run_dir}/restore.log"
docker run --rm \
  -v "${RESTORE_VOLUME}:/target:ro" \
  alpine:3.20 \
  sh -c "test -f /target/index.html && grep -q 'CloudOps Demo App' /target/index.html && head -20 /target/index.html" \
  >"${run_dir}/restore-verify.txt"

cat >"${run_dir}/SUMMARY.md" <<SUMMARY
# Demo Lab Evidence

Generated: ${timestamp}

## Proven Checks

- Docker Compose preflight completed.
- Demo app started.
- Healthy endpoint returned expected status.
- Simulated outage produced a failing health check.
- Service recovery produced a passing health check.
- Docker Compose volume backup was created.
- Backup checksum verification passed.
- Restore into disposable volume succeeded.
- Restored \`index.html\` was verified.

## Evidence Files

- \`compose-preflight.log\`
- \`compose-ps-running.txt\`
- \`diagnostics.log\`
- \`health-pass.txt\`
- \`health-fail.txt\`
- \`health-recovered.txt\`
- \`backup.log\`
- \`checksum-verify.txt\`
- \`restore.log\`
- \`restore-verify.txt\`

This CI run is not a replacement for screenshots, but it proves the support workflow on a clean Linux runner.
SUMMARY

log "Demo lab completed successfully"
log "Summary: ${run_dir}/SUMMARY.md"
