#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT="${1:-}"
BACKUP_ROOT="${2:-backups}"

usage() {
  cat <<'USAGE'
Usage: backup-compose-volumes.sh COMPOSE_PROJECT_NAME [backup_root]

Backs up Docker volumes labeled with com.docker.compose.project=COMPOSE_PROJECT_NAME.
This does not back up bind mounts. Stop write-heavy services first when consistency matters.
USAGE
}

if [ -z "$PROJECT" ]; then
  usage
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required" >&2
  exit 1
fi

timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
backup_dir="${BACKUP_ROOT}/${PROJECT}-${timestamp}"
mkdir -p "$backup_dir"

mapfile -t volumes < <(docker volume ls -q --filter "label=com.docker.compose.project=${PROJECT}" 2>/dev/null || true)

if [ "${#volumes[@]}" -eq 0 ]; then
  echo "No Docker Compose volumes found for project: ${PROJECT}" >&2
  echo "Check project names with: docker compose ls" >&2
  exit 2
fi

for volume in "${volumes[@]}"; do
  safe_volume="$(printf '%s' "$volume" | tr -c 'A-Za-z0-9_.-' '_')"
  archive="${safe_volume}.tar.gz"
  echo "Backing up volume ${volume} -> ${backup_dir}/${archive}"
  docker run --rm \
    -v "${volume}:/source:ro" \
    -v "$(pwd)/${backup_dir}:/backup" \
    alpine:3.20 \
    sh -c "cd /source && tar -czf /backup/${archive} ."
done

(
  cd "$backup_dir"
  sha256sum *.tar.gz > SHA256SUMS
)

cat >"${backup_dir}/README.md" <<SUMMARY
# Backup Summary

Project: ${PROJECT}
Created: ${timestamp}

## Verify Checksums

\`\`\`bash
cd ${backup_dir}
sha256sum -c SHA256SUMS
\`\`\`

## Restore Test

Restore into a disposable volume before touching production:

\`\`\`bash
RESTORE_CONFIRM=YES ./scripts/restore-volume-backup.sh ${backup_dir}/ARCHIVE_NAME.tar.gz ${PROJECT}_restore_test
\`\`\`
SUMMARY

echo "Backup complete: ${backup_dir}"
