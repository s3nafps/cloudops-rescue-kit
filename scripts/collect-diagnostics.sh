#!/usr/bin/env bash
set -Eeuo pipefail

INCLUDE_LOGS=0
LOG_TAIL="${LOG_TAIL:-200}"
OUT_DIR="${OUT_DIR:-reports}"

usage() {
  cat <<'USAGE'
Usage: collect-diagnostics.sh [--include-logs]

Creates a timestamped diagnostics report under reports/.

Default mode avoids environment variables, docker inspect, and container logs.
Use --include-logs only when you have permission and understand logs may contain secrets.
USAGE
}

while [ "${1:-}" != "" ]; do
  case "$1" in
    --include-logs)
      INCLUDE_LOGS=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
report_dir="${OUT_DIR}/diagnostics-${timestamp}"
mkdir -p "$report_dir"

run_shell() {
  local name="$1"
  local command="$2"
  local file="${report_dir}/${name}.txt"

  {
    echo "$ ${command}"
    echo
    bash -lc "$command"
  } >"$file" 2>&1 || true
}

run_shell "system" "hostnamectl 2>/dev/null || true; echo; uname -a; echo; uptime"
run_shell "os-release" "cat /etc/os-release 2>/dev/null || true"
run_shell "disk" "df -hT; echo; lsblk 2>/dev/null || true"
run_shell "memory" "free -m 2>/dev/null || true; echo; vmstat 1 3 2>/dev/null || true"
run_shell "top-processes" "ps aux --sort=-%mem | head -20"
run_shell "ports" "ss -tulpn 2>/dev/null || netstat -tulpn 2>/dev/null || true"
run_shell "firewall" "ufw status verbose 2>/dev/null || firewall-cmd --list-all 2>/dev/null || true"
run_shell "systemd-failed" "systemctl --failed --no-pager 2>/dev/null || true"
run_shell "docker-version" "docker version 2>/dev/null || true"
run_shell "docker-info-short" "docker info --format 'ServerVersion={{.ServerVersion}} Driver={{.Driver}} CgroupDriver={{.CgroupDriver}} OperatingSystem={{.OperatingSystem}}' 2>/dev/null || true"
run_shell "docker-containers" "docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' 2>/dev/null || true"
run_shell "docker-stats" "docker stats --no-stream --format 'table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}' 2>/dev/null || true"
run_shell "docker-volumes" "docker volume ls 2>/dev/null || true"
run_shell "docker-compose-projects" "docker compose ls 2>/dev/null || true"

if [ "$INCLUDE_LOGS" -eq 1 ] && command -v docker >/dev/null 2>&1; then
  mkdir -p "${report_dir}/logs"
  docker ps --format '{{.Names}}' 2>/dev/null | while IFS= read -r container; do
    [ -z "$container" ] && continue
    safe_name="$(printf '%s' "$container" | tr -c 'A-Za-z0-9_.-' '_')"
    docker logs --tail "$LOG_TAIL" "$container" >"${report_dir}/logs/${safe_name}.log" 2>&1 || true
  done
fi

cat >"${report_dir}/SUMMARY.md" <<SUMMARY
# Diagnostics Summary

Generated: ${timestamp}

## Review Order

1. Open \`system.txt\`, \`disk.txt\`, and \`memory.txt\`.
2. Check \`docker-containers.txt\` for exited, restarting, or unhealthy containers.
3. Check \`ports.txt\` for expected listening ports.
4. Check \`systemd-failed.txt\` for failed host services.
5. Check \`docker-stats.txt\` for obvious CPU or memory pressure.

## Secret Safety

This report intentionally avoids environment variables and full Docker inspect output.
If logs were included, review and redact secrets before sharing.

## Next Notes

- Root cause:
- Fix applied:
- Verification:
- Follow-up:
SUMMARY

echo "Diagnostics report created: ${report_dir}"
