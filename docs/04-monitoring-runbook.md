# Monitoring Runbook

Start with lightweight monitoring before adding heavy observability.

## Minimum Monitoring For A Small VPS App

- public homepage endpoint,
- API health endpoint if available,
- admin/login page if safe to check,
- disk usage check,
- Docker container status check,
- backup success evidence.

## Uptime Kuma Setup

Start Uptime Kuma:

```bash
docker compose -f monitoring/docker-compose.uptime-kuma.yml up -d
```

Open:

```text
http://SERVER_IP:3001
```

Recommended monitor settings:

- type: HTTP(s)
- interval: 60-300 seconds
- retries: 2-3
- timeout: 10 seconds
- expected status: 200

## CLI Endpoint Checks

Use:

```bash
./scripts/health-check.sh monitoring/endpoints.example.txt
```

For cron:

```cron
*/5 * * * * cd /opt/cloudops-rescue-kit && ./scripts/health-check.sh /opt/cloudops-rescue-kit/monitoring/endpoints.txt >> /var/log/cloudops-health.log 2>&1
```

## First Response Checklist

When an alert fires:

1. Confirm the alert from another network.
2. Check `docker ps -a`.
3. Check recent logs.
4. Check disk and memory.
5. Check reverse proxy/DNS if local works but public fails.
6. Record what changed recently.
7. Apply only the smallest safe fix.
8. Verify endpoint recovery.
9. Write an incident note.

## Alert Quality

Bad alerts:

- too frequent,
- no owner,
- no action,
- noisy false positives.

Good alerts:

- point to a real user impact,
- include URL/service name,
- have a first-response runbook,
- produce a short incident note after recovery.
