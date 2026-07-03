# Sample Incident Report: Docker App Not Reachable Behind Reverse Proxy

## Client / App

- Client: Redacted demo client
- App: `orders-api`
- Date: 2026-07-03
- Engineer: Mohamed Senator

## Summary

The client's Docker-hosted API was running but unreachable from the public domain after a deployment change. Diagnostics showed the application container was healthy, but the reverse proxy target pointed to the old internal port. I corrected the proxy upstream, reloaded the proxy container, and verified recovery with endpoint checks and container status review.

## Impact

- User impact: public API requests failed with `502 Bad Gateway`
- Duration: approximately 47 minutes before scoped recovery
- Services affected: public API endpoint and admin login path

## Symptoms

- Domain returned `502 Bad Gateway`
- `orders-api` container was running, but the proxy logs showed upstream connection failures
- Internal curl to the app container succeeded while public curl failed

## Checks Performed

```bash
docker ps -a
docker compose logs --tail=100 proxy
docker compose logs --tail=100 orders-api
df -h
free -m
ss -tulpn
curl -I https://api.example-client.com
docker exec reverse-proxy curl -sS http://orders-api:8080/health
```

## Root Cause

The reverse proxy configuration still routed traffic to the application's previous internal port. The app had been updated to listen on `8080`, but the proxy upstream target remained `8000`. Proxy logs showed repeated upstream connection failures, while direct container health checks to `8080` succeeded.

## Fix Applied

- Updated the reverse proxy upstream target from `orders-api:8000` to `orders-api:8080`
- Reloaded the proxy container after configuration validation
- Re-ran endpoint checks from the host and through the public domain

## Verification

- Endpoint: `curl -I https://api.example-client.com` returned `HTTP/2 200`
- Container status: `docker ps -a` showed both `proxy` and `orders-api` as healthy/running
- Logs: proxy error log stopped showing upstream connection failures after reload
- Monitoring: endpoint check returned `OK` from `health-check.sh`

## Remaining Risks

- No tested backup workflow for the application data volume
- No monitoring alerting yet for public endpoint failure
- Deployment notes did not record the internal port change

## Recommended Next Steps

- Add a lightweight monitoring check for `/health`
- Add a tested backup and restore workflow for the app data volume
- Write a short deploy checklist that includes verifying the proxy upstream target
- Review whether staging and production use the same internal port convention

## Attachments

- Screenshot: `03-container-before.png`, `06-healthcheck-passed.png`
- Report folder: `reports/20260703T161000Z`
- Backup checksum: not part of this scoped rescue audit
