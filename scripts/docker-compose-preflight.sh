#!/usr/bin/env bash
set -Eeuo pipefail

COMPOSE_FILE="${1:-docker-compose.yml}"
OUT_DIR="${OUT_DIR:-reports}"

usage() {
  cat <<'USAGE'
Usage: docker-compose-preflight.sh [compose-file]

Validates Docker Compose config and records basic preflight output.
USAGE
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ ! -f "$COMPOSE_FILE" ]; then
  echo "Compose file not found: ${COMPOSE_FILE}" >&2
  exit 1
fi

timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
report_dir="${OUT_DIR}/compose-preflight-${timestamp}"
mkdir -p "$report_dir"

{
  echo "$ docker compose -f ${COMPOSE_FILE} config"
  echo
  docker compose -f "$COMPOSE_FILE" config
} >"${report_dir}/compose-config.txt" 2>&1

{
  echo "$ docker compose -f ${COMPOSE_FILE} config --services"
  echo
  docker compose -f "$COMPOSE_FILE" config --services
} >"${report_dir}/services.txt" 2>&1 || true

{
  echo "$ docker compose -f ${COMPOSE_FILE} config --volumes"
  echo
  docker compose -f "$COMPOSE_FILE" config --volumes
} >"${report_dir}/volumes.txt" 2>&1 || true

cat >"${report_dir}/SUMMARY.md" <<SUMMARY
# Compose Preflight

Compose file: ${COMPOSE_FILE}
Generated: ${timestamp}

## Checks

- Compose config rendered successfully.
- Review services in \`services.txt\`.
- Review volumes in \`volumes.txt\`.
- Before production changes, confirm backups and rollback plan.
SUMMARY

echo "Preflight report created: ${report_dir}"
