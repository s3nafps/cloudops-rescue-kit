# CloudOps Rescue Kit

[![Shell syntax](https://github.com/s3nafps/cloudops-rescue-kit/actions/workflows/shell-syntax.yml/badge.svg)](https://github.com/s3nafps/cloudops-rescue-kit/actions/workflows/shell-syntax.yml)
[![Demo lab evidence](https://github.com/s3nafps/cloudops-rescue-kit/actions/workflows/demo-lab.yml/badge.svg)](https://github.com/s3nafps/cloudops-rescue-kit/actions/workflows/demo-lab.yml)

CloudOps Rescue Kit is a practical portfolio project for Cloud/DevOps Support work. It helps diagnose small VPS/Docker deployments, add lightweight monitoring, create backups, test restores, and document the result in a way a client or hiring manager can inspect.

This is not a SaaS. It is a low-cost support toolkit built around real operational problems:

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
- `examples/` - incident report and client intake examples.

## Who This Helps

- solo founders running a VPS,
- small agencies supporting client apps,
- developers with one Docker Compose server,
- students or junior engineers building operational evidence,
- support teams that need a simple handover process.

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

## First Demo Lab

Use the demo lab to create real screenshots and a first case study without touching a client system:

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

- Do not paste private keys, passwords, API tokens, or production `.env` files into issues, reports, screenshots, or chat.
- The diagnostics script does not collect environment variables or full Docker inspect output by default.
- Container logs can contain secrets. Use `--include-logs` only when you have permission and have reviewed the risk.
- Test restore into a disposable volume first.
- Stop write-heavy services before taking backups when consistency matters.

## Suggested Portfolio Evidence

Publish these screenshots in a case study:

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

Use `docs/00-case-study-template.md` and `docs/01-screenshots-checklist.md`.

## Example Service Mapping

This repo supports three fixed-price services:

- VPS Docker Rescue Audit
- Backup And Restore Safety Net
- Monitoring And Handover Setup

Each service should produce evidence: screenshots, commands, report, and next steps.

## Repo Status

This project is intentionally small. Improvements should come from real support cases, job interviews, or repeated client questions.
