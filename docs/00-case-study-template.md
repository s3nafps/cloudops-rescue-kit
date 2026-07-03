# Case Study: [Client/App/System Name]

## Short Summary

One or two sentences:

- What was broken or risky?
- What did you fix or prove?
- What evidence shows the result?

## Context

- App type:
- Hosting:
- Stack:
- Users affected:
- Business risk:
- Access method:
- Constraints:

## Problem

Describe the issue in plain language.

Examples:

- Docker app was restarting.
- HTTPS endpoint returned 502.
- No one knew whether backups worked.
- There was no monitoring.
- Previous deployment notes were missing.

## Initial Symptoms

| Symptom | Evidence |
|---|---|
| Example: container restarting | screenshot or command output |
| Example: health check failed | screenshot or curl output |

## Diagnostic Steps

List the exact checks performed:

```bash
./scripts/collect-diagnostics.sh
docker ps -a
docker compose logs --tail=100
df -h
ss -tulpn
```

## Root Cause

What caused the problem?

Be specific and avoid guessing. If uncertain, say what evidence points to the likely cause.

## Fix Or Improvement

What changed?

- config:
- command:
- service:
- DNS/SSL:
- monitoring:
- backup:
- documentation:

## Verification

| Check | Before | After |
|---|---|---|
| Endpoint status | failed | 200 OK |
| Container status | restarting | running |
| Backup checksum | none | verified |
| Restore test | none | completed |

## Screenshots

Add links:

- before:
- after:
- monitoring:
- backup:
- restore:
- report:

## Handover

What did the client or future maintainer receive?

- incident report,
- commands checked,
- backup schedule,
- monitoring URL,
- next actions,
- known risks.

## Lessons Learned

- What repeated problem did this reveal?
- What would you automate next?
- What would you avoid doing in production without backup?

## Portfolio Version

Remove or redact:

- IP addresses if sensitive,
- domains if client requests privacy,
- usernames,
- paths that reveal secrets,
- tokens,
- `.env` contents,
- private logs.
