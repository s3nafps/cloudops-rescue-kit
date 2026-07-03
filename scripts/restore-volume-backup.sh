#!/usr/bin/env bash
set -Eeuo pipefail

ARCHIVE="${1:-}"
TARGET_VOLUME="${2:-}"

usage() {
  cat <<'USAGE'
Usage:
RESTORE_CONFIRM=YES restore-volume-backup.sh backup.tar.gz target_volume

Restores a tar.gz archive into a Docker volume.
Use a disposable test volume first. This command overlays files and can damage data if pointed at production.
USAGE
}

if [ -z "$ARCHIVE" ] || [ -z "$TARGET_VOLUME" ]; then
  usage
  exit 1
fi

if [ "${RESTORE_CONFIRM:-}" != "YES" ]; then
  echo "Refusing to restore without RESTORE_CONFIRM=YES" >&2
  usage
  exit 2
fi

if [ ! -f "$ARCHIVE" ]; then
  echo "Archive not found: $ARCHIVE" >&2
  exit 1
fi

archive_dir="$(cd "$(dirname "$ARCHIVE")" && pwd)"
archive_file="$(basename "$ARCHIVE")"

if ! docker volume inspect "$TARGET_VOLUME" >/dev/null 2>&1; then
  echo "Creating target volume: ${TARGET_VOLUME}"
  docker volume create "$TARGET_VOLUME" >/dev/null
fi

echo "Restoring ${ARCHIVE} into Docker volume ${TARGET_VOLUME}"
docker run --rm \
  -v "${TARGET_VOLUME}:/target" \
  -v "${archive_dir}:/backup:ro" \
  alpine:3.20 \
  sh -c "cd /target && tar -xzf /backup/${archive_file}"

echo "Restore completed. Verify before using this volume in production."
