# Fixed-Scope CloudOps Service Packages

These packages are designed for small teams, founders, agencies, and developers running one or a few apps on a VPS or simple cloud VM.

They are intentionally narrow. The goal is to solve a visible operational problem, produce evidence, and avoid open-ended work.

## Package 1: VPS Docker Rescue Audit

Starter price: USD 79

Delivery target: 24-48 hours

Best fit:

- one Linux VPS,
- one Docker or Docker Compose app,
- one clear outage, startup, routing, or deployment problem.

Customer problem:

> "My Docker app is down or unreliable, and I need someone to identify the issue, fix the obvious scoped problem, and explain what happened."

Included:

- check containers, logs, ports, disk, memory, Compose config, and endpoint response,
- identify likely root cause,
- fix one safe, clearly scoped issue when possible,
- deliver short incident report,
- provide before/after evidence.

Not included:

- rewriting the application,
- database recovery after corruption,
- Kubernetes,
- 24/7 support,
- broad infrastructure redesign.

Deliverables:

- incident report,
- command summary,
- before/after screenshots or terminal output,
- recommended next actions.

## Package 2: Backup And Restore Safety Net

Starter price: USD 149

Delivery target: 2-3 days

Best fit:

- working Docker Compose app,
- owner has no tested backup,
- one main app and one main data volume/database scope.

Customer problem:

> "If this server dies, I do not know whether I can recover."

Included:

- identify Docker volumes or data paths,
- create a backup command/script,
- generate checksum,
- restore into a disposable test volume or documented safe target,
- write backup/restore runbook.

Not included:

- storage fees,
- compliance guarantees,
- unlimited databases,
- production restore without explicit approval and backup.

Deliverables:

- backup archive or configured command,
- checksum verification,
- restore-test proof,
- runbook,
- screenshots or terminal evidence.

## Package 3: Monitoring And Handover Setup

Starter price: USD 199

Delivery target: 2-4 days

Best fit:

- small VPS-hosted app,
- owner only discovers downtime from users,
- no first-response notes exist.

Customer problem:

> "I need to know when the app is down and what to check first."

Included:

- Uptime Kuma or lightweight endpoint checks for up to 5 URLs,
- basic Docker status checks,
- disk/memory check commands,
- alert test evidence,
- first-response runbook,
- handover note.

Not included:

- 24/7 on-call,
- complex observability platform,
- Prometheus/Grafana architecture,
- application code changes.

Deliverables:

- monitoring screenshot,
- endpoint list,
- first-response runbook,
- alert test proof,
- handover document.

## Pricing Rules

- Quote in USD/EUR for international clients where possible.
- Keep the first few jobs simple to earn proof, testimonials, and repeatable evidence.
- Raise prices only after successful deliveries or repeated demand.
- Do not offer monthly maintenance until at least one fixed-price job succeeds.

## Scope Safety

Before any production change:

- confirm what must not be touched,
- check whether a recent backup exists,
- avoid destructive commands,
- document before/after state,
- never ask the client to paste passwords, private keys, API tokens, or `.env` files in chat.

## Outreach Positioning

Short version:

> I help small teams with VPS/Docker rescue, backup/restore proof, and lightweight monitoring. I deliver a scoped fix or report with screenshots, commands checked, and a handover note.

## Why These Services Match This Repo

CloudOps Rescue Kit already provides the core evidence:

- diagnostics script,
- health-check script,
- backup/restore scripts,
- monitoring compose file,
- incident report template,
- case-study template,
- CI-backed demo case study.

The repo should improve only when real jobs, interviews, or repeated client questions expose a gap.
