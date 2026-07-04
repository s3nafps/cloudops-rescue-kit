# CloudOps Rescue Kit

[![Shell syntax](https://github.com/s3nafps/cloudops-rescue-kit/actions/workflows/shell-syntax.yml/badge.svg)](https://github.com/s3nafps/cloudops-rescue-kit/actions/workflows/shell-syntax.yml)
[![Demo lab evidence](https://github.com/s3nafps/cloudops-rescue-kit/actions/workflows/demo-lab.yml/badge.svg)](https://github.com/s3nafps/cloudops-rescue-kit/actions/workflows/demo-lab.yml)

CloudOps Rescue Kit is a practical portfolio project for Cloud/DevOps Support work. It helps diagnose small VPS/Docker deployments, add lightweight monitoring, create backups, test restores, and document the result in a way a client or hiring manager can inspect.

The toolkit is structured around common operational failure points:

- "My Docker app is down."
- "I do not know what is running on this VPS."
- "We have no tested backup."
- "We only discover downtime from users."
- "The previous developer left no handover notes."

## What Is Included

- `scripts/collect-diagnostics.sh` - generates a VPS/Docker diagnostics report.
- `scripts/health-check.sh` - checks endpoint status from a simple text file.
- `scripts/backup-compose-volumes.sh` - backs up Docker Compose-managed volumes.
- `scripts/restore-volume-backup.sh` - restores a backup archive into a Docker volume after explicit confirmation.
- `scripts/docker-compose-preflight.sh` - validates a Compose file and records preflight output.
- `scripts/run-demo-lab.sh` - runs the full Docker demo evidence workflow.
- `monitoring/docker-compose.uptime-kuma.yml` - lightweight uptime monitoring stack.
- `docs/` - runbooks, screenshot checklist, case-study template, and safety notes.
- `examples/` - client-ready sample deliverables and reusable templates.

## Intended Use

- Linux VPS or Docker Compose environments
- small support-oriented infrastructure reviews
- reproducible portfolio evidence for Cloud/DevOps Support work
- handover documentation and restore-proof workflows

## Requirements

- Linux VPS, local Linux VM, or WSL Ubuntu
- Bash
- Docker and Docker Compose plugin
- curl
- Optional: Uptime Kuma for monitoring dashboard screenshots

## Quick Start

Clone the repo:

```bash
git clone https://github.com/s3nafps/cloudops-rescue-kit.git
cd cloudops-rescue-kit
chmod +x scripts/*.sh
```

Generate a diagnostics report:

```bash
./scripts/collect-diagnostics.sh
```

Check endpoints:

```bash
./scripts/health-check.sh monitoring/endpoints.example.txt
```

Validate a Compose file:

```bash
./scripts/docker-compose-preflight.sh monitoring/docker-compose.uptime-kuma.yml
```

## Demo Lab

The demo lab creates publishable evidence without touching a live client system:

```bash
docker compose -p cloudops-demo -f demo/docker-compose.demo.yml up -d
./scripts/collect-diagnostics.sh
./scripts/health-check.sh monitoring/endpoints.demo.txt
./scripts/backup-compose-volumes.sh cloudops-demo
```

Full walkthrough: `docs/08-demo-lab.md`

GitHub Actions also runs the demo automatically and uploads evidence artifacts:

```text
docs/09-ci-evidence.md
```

Published case study:

```text
docs/case-studies/ci-demo-lab.md
```

Sample deliverables case study:

```text
docs/case-studies/sample-client-deliverables.md
```

Start Uptime Kuma:

```bash
docker compose -f monitoring/docker-compose.uptime-kuma.yml up -d
```

Back up Docker Compose volumes for a project:

```bash
./scripts/backup-compose-volumes.sh myproject
```

Restore into a test volume:

```bash
RESTORE_CONFIRM=YES ./scripts/restore-volume-backup.sh backups/myproject-20260703T120000Z/myproject_db-data.tar.gz myproject_restore_test
```

## Safety Notes

- Private keys, passwords, API tokens, and production `.env` files should never appear in issues, reports, screenshots, or chat.
- The diagnostics script does not collect environment variables or full Docker inspect output by default.
- Container logs can contain secrets; `--include-logs` is intended only for approved use after risk review.
- Restore validation is designed for a disposable test volume.
- Backups are safest when write-heavy services are stopped first.

## Suggested Evidence

Typical case-study evidence includes:

1. Generated diagnostics report folder.
2. Docker containers before fix.
3. Error log excerpt with secrets hidden.
4. Health check failing.
5. Fix applied.
6. Health check passing.
7. Backup archive and checksum.
8. Restore test into a disposable volume.
9. Uptime Kuma dashboard.
10. Final incident report.

Reference material is available in `docs/00-case-study-template.md` and `docs/01-screenshots-checklist.md`.

## Sample Deliverables

Public examples of handoff material:

- `examples/sample-incident-report.md`
- `examples/sample-handover-note.md`
- `examples/incident-report.md` (template)
- `examples/client-intake-form.md` (template)
- `screenshots/public/README.md` (public screenshot manifest)
- `screenshots/public/captions.md` (case-study captions)

## Repo Status

This project is intentionally small and focused. Future improvements should reflect real support cases, interview questions, or repeated operational gaps.
