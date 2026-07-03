#!/usr/bin/env bash
set -Eeuo pipefail

ENDPOINT_FILE="${1:-}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-10}"

usage() {
  cat <<'USAGE'
Usage: health-check.sh endpoints.txt

Endpoint file format:
name url expected_status

Example:
homepage https://example.com 200
api https://example.com/api/health 200

Optional:
ALERT_WEBHOOK=https://hooks.example ./scripts/health-check.sh endpoints.txt
USAGE
}

if [ -z "$ENDPOINT_FILE" ] || [ ! -f "$ENDPOINT_FILE" ]; then
  usage
  exit 1
fi

send_alert() {
  local message="$1"
  if [ -n "${ALERT_WEBHOOK:-}" ]; then
    curl -fsS -X POST \
      -H "Content-Type: application/json" \
      -d "{\"text\":\"${message//\"/\\\"}\"}" \
      "$ALERT_WEBHOOK" >/dev/null || true
  fi
}

failures=0
timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "Health check started: ${timestamp}"

while read -r name url expected; do
  [ -z "${name:-}" ] && continue
  case "$name" in
    \#*) continue ;;
  esac

  expected="${expected:-200}"
  result="$(curl -k -L -sS -o /dev/null -w '%{http_code} %{time_total}' --max-time "$TIMEOUT_SECONDS" "$url" 2>/dev/null || echo '000 0')"
  status="$(printf '%s' "$result" | awk '{print $1}')"
  seconds="$(printf '%s' "$result" | awk '{print $2}')"

  if [ "$status" = "$expected" ]; then
    printf 'OK   %-20s status=%s time=%ss url=%s\n' "$name" "$status" "$seconds" "$url"
  else
    printf 'FAIL %-20s expected=%s got=%s time=%ss url=%s\n' "$name" "$expected" "$status" "$seconds" "$url"
    failures=$((failures + 1))
    send_alert "Health check failed for ${name}: expected ${expected}, got ${status}, url=${url}"
  fi
done <"$ENDPOINT_FILE"

if [ "$failures" -gt 0 ]; then
  echo "Health check completed with ${failures} failure(s)."
  exit 2
fi

echo "Health check completed successfully."
