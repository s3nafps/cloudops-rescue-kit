# Case Study: CloudOps Rescue Kit Demo Lab

## Short Summary

I used CloudOps Rescue Kit to diagnose, monitor, back up, restore, and document a small Docker Compose app. The demo proves the workflow without touching a real client system.

## Context

- App type: static Nginx demo app
- Hosting: [local VM / WSL Ubuntu / VPS]
- Stack: Docker Compose, Nginx, Bash
- Users affected: simulated
- Business risk: app downtime and missing restore proof
- Constraints: low-cost tools only

## Problem

Small VPS-hosted apps often run without diagnostics, monitoring, tested backups, or handover notes. This demo creates evidence for the support workflow before offering it to real clients.

## Initial Symptoms

| Symptom | Evidence |
|---|---|
| Demo app running | screenshot: containers running |
| Health check passing | screenshot: `health-check.sh` returns OK |
| Simulated outage | screenshot: health check fails after stopping web service |
| Recovery | screenshot: health check passes after restart |

## Diagnostic Steps

```bash
docker compose -p cloudops-demo -f demo/docker-compose.demo.yml ps
./scripts/collect-diagnostics.sh
./scripts/health-check.sh monitoring/endpoints.demo.txt
```

## Root Cause

For the simulated outage, the `web` container was intentionally stopped. In a real incident, this step would be replaced by log review, Docker status checks, disk/memory checks, port checks, and recent-change review.

## Fix Or Improvement

- Restored the stopped web service.
- Verified the endpoint recovered.
- Created a backup archive for the Docker Compose volume.
- Verified backup checksum.
- Restored the archive into a disposable test volume.
- Documented the incident workflow and handover steps.

## Verification

| Check | Before | After |
|---|---|---|
| Endpoint status | failed during simulated outage | 200 OK |
| Container status | web stopped | web running |
| Backup checksum | none | verified |
| Restore test | none | restored into `cloudops-demo_restore_test` |

## Screenshots

- diagnostics run:
- report folder:
- health check passed:
- health check failed:
- recovery:
- backup archive:
- checksum verification:
- restore test:
- monitoring dashboard:

## CI Evidence

If this case study is based on the automated demo lab, link the successful run:

- workflow run:
- uploaded artifact:
- artifact digest:

## Handover

Deliverables from this workflow:

- diagnostics report,
- endpoint check result,
- backup archive and checksum,
- restore-test proof,
- incident notes,
- next-step recommendations.

## Lessons Learned

- A support portfolio should show before/after evidence, not only tool names.
- Backups are stronger evidence when a restore test is shown.
- A small reproducible lab is enough to prove a workflow before selling it to clients.
