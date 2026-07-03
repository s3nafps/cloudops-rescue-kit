# Demo Lab: Create First Portfolio Evidence

Use this lab to create a real case study without touching a client system.

## Requirements

- Linux VPS, WSL Ubuntu with Docker, or local Linux VM.
- Docker and Docker Compose plugin.
- Bash and curl.

## 1. Clone And Prepare

```bash
git clone https://github.com/s3nafps/cloudops-rescue-kit.git
cd cloudops-rescue-kit
chmod +x scripts/*.sh
```

Screenshot:

- terminal showing the cloned repo and executable scripts.

## 2. Start Demo App

```bash
docker compose -p cloudops-demo -f demo/docker-compose.demo.yml up -d
docker compose -p cloudops-demo -f demo/docker-compose.demo.yml ps
curl -I http://localhost:8088
```

Screenshot:

- containers running,
- `curl` returning `200 OK`,
- browser showing `http://SERVER_IP:8088` if running on a VPS and firewall allows it.

## 3. Run Diagnostics

```bash
./scripts/collect-diagnostics.sh
ls -la reports/
```

Screenshot:

- diagnostics command,
- generated report folder.

## 4. Run Health Check

```bash
./scripts/health-check.sh monitoring/endpoints.demo.txt
```

Screenshot:

- health check passing.

## 5. Simulate Outage

```bash
docker compose -p cloudops-demo -f demo/docker-compose.demo.yml stop web
./scripts/health-check.sh monitoring/endpoints.demo.txt || true
```

Screenshot:

- health check failing.

Restore service:

```bash
docker compose -p cloudops-demo -f demo/docker-compose.demo.yml start web
./scripts/health-check.sh monitoring/endpoints.demo.txt
```

Screenshot:

- health check passing again.

## 6. Backup Demo Volume

```bash
./scripts/backup-compose-volumes.sh cloudops-demo
find backups -maxdepth 2 -type f
cd "$(find backups -maxdepth 1 -type d -name 'cloudops-demo-*' | sort | tail -1)"
sha256sum -c SHA256SUMS
cd ../..
```

Screenshot:

- backup archive,
- checksum verification.

## 7. Restore Test

Replace `ARCHIVE_PATH` with the `.tar.gz` file created in the latest backup folder:

```bash
ARCHIVE_PATH="$(find backups -type f -name '*.tar.gz' | sort | tail -1)"
RESTORE_CONFIRM=YES ./scripts/restore-volume-backup.sh "$ARCHIVE_PATH" cloudops-demo_restore_test
docker run --rm -v cloudops-demo_restore_test:/target alpine:3.20 sh -c "find /target -maxdepth 2 -type f -print -exec head -5 {} \\;"
```

Screenshot:

- restore command completed,
- restored `index.html` visible from the test volume.

## 8. Optional Monitoring Screenshot

```bash
docker compose -f monitoring/docker-compose.uptime-kuma.yml up -d
```

Open:

```text
http://SERVER_IP:3001
```

Add monitor:

- type: HTTP(s)
- URL: `http://SERVER_IP:8088`
- expected status: 200

Screenshot:

- Uptime Kuma dashboard with demo monitor up.

## 9. Write Case Study

Copy:

```bash
cp examples/demo-case-study.md docs/my-first-demo-case-study.md
```

Fill in actual screenshots and command outputs.

## 10. Clean Up

```bash
docker compose -p cloudops-demo -f demo/docker-compose.demo.yml down
docker compose -f monitoring/docker-compose.uptime-kuma.yml down
docker volume rm cloudops-demo_restore_test || true
```

Keep backup archives only if you want evidence. Do not commit private report folders or raw logs.
