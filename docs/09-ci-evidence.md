# CI Evidence

CloudOps Rescue Kit has two GitHub Actions workflows:

- Shell syntax: checks every Bash script with `bash -n`.
- Demo lab evidence: runs the Docker demo app on a clean Ubuntu runner and proves the core support workflow.

## Demo Lab Workflow

The demo workflow runs:

```bash
./scripts/run-demo-lab.sh
```

It verifies:

- Docker Compose preflight,
- demo app startup,
- healthy endpoint check,
- simulated outage,
- recovery check,
- Docker volume backup,
- checksum verification,
- restore into a disposable volume,
- restored file verification.

## Artifacts

Every workflow run uploads a `demo-lab-evidence` artifact containing:

- diagnostics output,
- compose preflight logs,
- passing/failing/recovered health checks,
- backup logs,
- checksum verification,
- restore logs,
- restore verification,
- summary.

This is public operational evidence that the toolkit works on a clean Linux runner. It does not replace manual screenshots for the portfolio case study, but it makes the repo more credible while screenshots are being prepared.
