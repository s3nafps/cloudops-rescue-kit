# Sample Handover Note: Monitoring And First Response

## System Summary

- App: `orders-api`
- Hosting: single Linux VPS
- Runtime: Docker Compose
- Reverse proxy: Caddy
- Public checks: main API URL, `/health`, admin login page

## What Was Delivered

- diagnostics review for host and containers
- public endpoint checks
- proxy routing fix
- monitoring baseline for three URLs
- first-response notes for the next operator

## Current Known-Good State

- public API endpoint returns `200`
- application container is running and healthy
- reverse proxy container is running and healthy
- disk usage is within safe range
- memory pressure was not observed during the final verification

## What To Check First If The App Fails Again

1. Confirm the public endpoint fails:

```bash
curl -I https://api.example-client.com
```

2. Check container state:

```bash
docker ps -a
```

3. Review proxy and app logs:

```bash
docker compose logs --tail=100 proxy
docker compose logs --tail=100 orders-api
```

4. Verify disk and memory:

```bash
df -h
free -m
```

5. Re-run endpoint checks:

```bash
./scripts/health-check.sh monitoring/endpoints.example.txt
```

## Monitoring Scope

- `https://api.example-client.com/health`
- `https://api.example-client.com/login`
- `https://api.example-client.com/docs`

Alert expectation:

- if 2 consecutive checks fail, investigate the proxy first, then the app container

## Backups

- backup workflow not yet implemented in this engagement
- next scoped service should be Backup And Restore Safety Net

## Known Risks

- no tested restore proof yet
- deploy notes are still lightweight
- one VPS means infrastructure redundancy is limited

## Recommended Next Actions

1. Add backup and restore proof for the main data volume
2. Store the current proxy configuration in version control
3. Add a short release checklist for internal port changes
4. Review alert routing so the owner sees downtime immediately

## Operator Notes

- Do not paste passwords, private keys, API tokens, or `.env` contents into chat or tickets
- If external help is needed, use temporary access and rotate credentials after the work
