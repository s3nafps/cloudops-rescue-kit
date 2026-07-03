# Market Validation Snapshot

Snapshot date: 2026-07-03

Goal: validate fixed-scope VPS/Docker support services against real customer problems before building anything larger.

Current decision: sell narrow services first. Do not build a SaaS until repeated demand is proven.

## Evidence Sources Checked

Public pages and marketplace searches checked on 2026-07-03:

- Upwork Docker jobs: https://www.upwork.com/freelance-jobs/docker/
- Upwork DevOps jobs: https://www.upwork.com/freelance-jobs/devops/
- Upwork VPS specialists: https://www.upwork.com/hire/virtual-private-server-freelancers/
- Freelancer Docker jobs: https://www.freelancer.com/job-search/docker/
- Example Freelancer Docker/VPS deployment listing: https://www.freelancer.com/projects/docker/docker-app-vps-deployment
- PeoplePerHour Docker jobs: https://www.peopleperhour.com/freelance-docker-jobs
- PeoplePerHour Linux jobs: https://www.peopleperhour.com/freelance-linux-jobs
- PeoplePerHour server monitoring jobs: https://www.peopleperhour.com/freelance-server-monitoring-jobs
- Fiverr Docker/Linux VPS deployment gig example: https://fiverr.com/procommit/deploy-your-docker-application-on-a-linux-vps
- Fiverr Linux VPS management gig example: https://www.fiverr.com/zohaib_devops8/setup-secure-and-manage-your-linux-vps-or-dedicated-server
- Fiverr Docker/VPS troubleshooting gig example: https://www.fiverr.com/devops_elite/dockerize-your-app-fix-docker-issues-migrate-containers-and-deploy-on-vps

Search observations:

- Upwork showed hundreds of open Docker and DevOps jobs.
- Fiverr has existing packaged services for Docker app deployment on Linux VPS, VPS setup/hardening/management, and Docker troubleshooting/deployment.
- PeoplePerHour has live Docker, Linux, and server-monitoring job categories.
- Freelancer has Docker job categories and examples of Docker app VPS deployment tasks.
- Some live listings mention setup plus ongoing monthly maintenance, which supports starting with fixed-scope setup and offering recurring checks only after trust is built.

## Problem Validation Matrix

| Offer | Real problem found | Evidence type | Build now? |
|---|---|---|---|
| VPS Docker Rescue Audit | Docker/VPS apps fail to deploy, restart, or route correctly. | Marketplace jobs and gigs around Docker app deployment, VPS setup, troubleshooting, and DevOps support. | Yes |
| Backup And Restore Safety Net | Small owners do not know if they can recover after VPS failure or data loss. | VPS management gigs include backup/management language; support jobs often ask for deployment scripts and rollback plans. | Yes |
| Monitoring And Handover Setup | Owners discover downtime late and lack first-response steps. | Server monitoring categories and VPS management services include monitoring as a buyer need. | Yes |
| Monthly maintenance | Buyers may want ongoing checks after setup. | Some listings mention ongoing monthly maintenance after initial setup. | Later |
| SaaS dashboard | Could centralize diagnostics/backup/monitoring. | No repeated direct buyer proof yet. | No |

## Validation Thresholds

Keep building scripts/docs only when they improve one of the fixed services.

Do not build a SaaS until all are true:

- 10 or more prospects describe the same repeated workflow,
- 3 or more prospects say they would pay monthly,
- at least 1 person pays for a manual version,
- the manual version has a stable checklist,
- the recurring work can be delivered in under 2 hours per client per month.

Consider a light monthly maintenance offer only when:

- 2 or more fixed-scope clients ask for it,
- the scope is limited to uptime check, backup verification, and a short report,
- there is a hard monthly time limit,
- emergency work is billed separately.

## Lead Qualification Questions

Use these before accepting any client work:

1. What app is running on the VPS?
2. Is it Docker Compose, plain Docker, or something else?
3. What exactly is broken or risky right now?
4. What result do you need within 48 hours?
5. Is there a recent backup?
6. What must not be touched?
7. Are production users affected?
8. Can access be provided through a secure, limited method?
9. Do you need diagnosis only, a scoped fix, monitoring, or backup proof?
10. What evidence should be delivered at the end?

## Red Flags

Decline or narrow the job when:

- the client wants password/private-key sharing in chat,
- there is no backup and they want risky production changes,
- the task is actually application development but priced as DevOps support,
- they expect 24/7 support from a fixed one-time fee,
- they want illegal access, bypassing, or evasion work.

## Next Validation Actions

1. Capture 10 real leads in a tracker.
2. Send 5 targeted proposals for VPS Docker Rescue Audit.
3. Record the buyer wording that appears repeatedly.
4. Update `docs/10-service-packages.md` only from repeated evidence.
5. Keep issue #3 open until at least 5 real lead records and 5 outreach attempts exist.

Outreach templates:

```text
docs/12-outreach-templates.md
```

Tracker template:

```text
trackers/lead-validation-tracker.csv
```
