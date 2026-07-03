# Case Study: CI-Backed Docker Rescue Workflow

## Summary

CloudOps Rescue Kit now proves its core VPS/Docker support workflow in GitHub Actions. A clean Ubuntu runner starts a demo Docker Compose app, checks health, simulates downtime, verifies recovery, creates a Docker volume backup, validates the checksum, restores into a disposable volume, and verifies restored content.

Evidence run: https://github.com/s3nafps/cloudops-rescue-kit/actions/runs/28667782206

## Context

- System: demo Nginx app in Docker Compose
- Environment: GitHub Actions `ubuntu-latest`
- Workflow: `Demo lab evidence`
- Commit: `21ed11d7b5379e97621e95f46eb020eb4cdf5b0c`
- Goal: prove the support workflow before applying it to a real VPS/client system
- Constraint: no secrets, production credentials, or private infrastructure required

## Customer Problem Simulated

Small teams often have a Docker app running on a VPS, but they lack:

- a repeatable diagnostic workflow,
- a simple health check,
- a tested backup,
- a restore proof,
- a handover report that another person can review.

The CI demo lab simulates that environment in a controlled way so the process is public and repeatable.

## Workflow Performed

The workflow runs:

```bash
./scripts/run-demo-lab.sh
```

That script performs these checks:

1. Validates the Docker Compose file with `scripts/docker-compose-preflight.sh`.
2. Starts the demo app with Docker Compose.
3. Waits for the app to become healthy.
4. Runs `scripts/collect-diagnostics.sh`.
5. Runs `scripts/health-check.sh` and verifies the endpoint passes.
6. Stops the web service to simulate an outage.
7. Confirms the health check fails during the outage.
8. Restarts the web service and confirms the health check recovers.
9. Runs `scripts/backup-compose-volumes.sh`.
10. Verifies the backup checksum.
11. Restores the backup into a disposable Docker volume.
12. Verifies the restored `index.html` contains the expected demo app content.

## Evidence

Latest successful run:

- Workflow run: https://github.com/s3nafps/cloudops-rescue-kit/actions/runs/28667782206
- Job: https://github.com/s3nafps/cloudops-rescue-kit/actions/runs/28667782206/job/85023633948
- Result: `success`
- Artifact: `demo-lab-evidence`
- Artifact digest from upload log: `d9dc3859388211bd76229034d1cfedc3d8228c68eeb9f1a3165d8920a76ac231`

The uploaded artifact contains:

- Compose preflight output
- Container status
- Diagnostics output
- Passing health check output
- Failing health check output from simulated outage
- Recovered health check output
- Backup log
- Checksum verification output
- Restore log
- Restored file verification output
- Summary file

## Result

| Check | Result |
|---|---|
| Docker Compose preflight | Passed |
| Demo app startup | Passed |
| Healthy endpoint check | Passed |
| Simulated outage detection | Passed |
| Recovery verification | Passed |
| Docker volume backup | Passed |
| Checksum verification | Passed |
| Restore into disposable volume | Passed |
| Restored content verification | Passed |

## What This Proves

This case study proves that CloudOps Rescue Kit can run a complete support workflow on a clean Linux environment using low-cost tools:

- Bash
- Docker
- Docker Compose
- curl
- GitHub Actions
- Markdown runbooks

It also proves that the repo is not only documentation. The scripts execute together and produce auditable evidence.

## What This Does Not Prove Yet

This CI case study is not a replacement for a real VPS/client case study.

Still needed:

- public screenshots from a VPS or Linux VM run,
- Uptime Kuma dashboard screenshot,
- a real or realistic incident report with before/after screenshots,
- side-income validation from actual marketplace/client leads.

## Next Step

Run `docs/08-demo-lab.md` on a Docker-capable VPS or Linux VM and add redacted screenshots under `screenshots/public/`.
