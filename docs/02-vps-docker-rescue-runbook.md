# VPS Docker Rescue Runbook

Use this when a small VPS-hosted Docker app is down, unstable, or unclear.

## Safety First

Before changing anything:

- Confirm what should not be touched.
- Check whether a recent backup exists.
- Avoid destructive commands.
- Do not expose secrets in chat or screenshots.
- Record before/after evidence.

## 1. Capture Initial State

```bash
./scripts/collect-diagnostics.sh
docker ps -a
docker compose ls
df -h
free -m
ss -tulpn
```

Look for:

- exited containers,
- restart loops,
- full disk,
- memory pressure,
- expected port not listening,
- conflicting ports,
- failed host services.

## 2. Check The App Stack

Find the project directory:

```bash
pwd
ls -la
find .. -maxdepth 3 -name "docker-compose*.yml" -o -name "compose.yml"
```

Validate Compose config:

```bash
./scripts/docker-compose-preflight.sh docker-compose.yml
docker compose config
```

## 3. Read Logs Carefully

Use short log windows first:

```bash
docker compose logs --tail=100
docker logs --tail=100 CONTAINER_NAME
```

Check for:

- missing environment variable,
- database connection error,
- permission error,
- port already in use,
- failed migration,
- missing dependency,
- wrong start command,
- SSL/proxy mismatch.

## 4. Verify Network Path

```bash
curl -I http://localhost:PORT
curl -I https://DOMAIN
dig DOMAIN
```

If public route fails but local works:

- check reverse proxy,
- check DNS,
- check Cloudflare proxy state,
- check SSL/TLS mode,
- check firewall,
- check exposed ports.

## 5. Fix Only The Scoped Issue

Examples of safe scoped fixes:

- restart one failed service,
- correct an obvious Compose start command,
- add missing dependency and rebuild,
- free disk space from old logs/images after review,
- correct reverse proxy label/config typo,
- update health check endpoint.

Avoid:

- deleting volumes without backup,
- changing database schema blindly,
- rotating secrets without plan,
- opening broad firewall access,
- rewriting application code under a rescue scope.

## 6. Verify

```bash
docker ps -a
./scripts/health-check.sh monitoring/endpoints.example.txt
curl -I https://DOMAIN
```

Record:

- what was broken,
- what changed,
- how it was verified,
- what risk remains.

## 7. Handover

Use:

- `examples/incident-report.md` for the template
- `examples/sample-incident-report.md` for a public filled example
- `examples/sample-handover-note.md` for a public client handoff example

Minimum handover:

- root cause,
- fix applied,
- commands checked,
- screenshots,
- remaining risks,
- recommended backup/monitoring next step.
