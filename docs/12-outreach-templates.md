# Outreach Templates

Use these for fixed-scope validation. Keep messages short, specific, and tied to a visible problem.

Do not ask anyone to paste passwords, private keys, API tokens, or `.env` files in chat.

## Upwork: VPS Docker Rescue Audit

Hi [Name],

I can help with this Docker/VPS issue. I usually start by checking container state, Compose config, logs, disk/memory, ports, and endpoint response so we identify the exact failure point before changing anything.

For this job I would deliver:

- root-cause notes,
- one safe scoped fix if the issue is clear,
- before/after evidence,
- a short handover report with next steps.

I do not need passwords or private keys pasted into chat. Access should be handled through a secure, limited method.

Thanks,  
Mohamed

## Upwork: Backup And Restore Safety Net

Hi [Name],

I can set up a simple backup and restore proof for your Docker/VPS app. The important part is not only creating a backup file, but verifying the checksum and testing restore into a safe target.

Deliverables:

- identify Docker volumes or data paths,
- create backup command/script,
- verify checksum,
- restore into a disposable test volume when possible,
- document the restore runbook.

This is a good fit for one VPS and one main app. If the system is larger, I would first scope it clearly.

Thanks,  
Mohamed

## Upwork: Monitoring And Handover Setup

Hi [Name],

I can add lightweight uptime monitoring and a first-response checklist for your VPS/Docker app.

Deliverables:

- monitor up to 5 URLs,
- basic Docker status checks,
- alert test evidence,
- first-response runbook,
- handover note.

The goal is to know when the app is down and what to check first, without adding a heavy observability stack.

Thanks,  
Mohamed

## Direct Message To Founder Or Agency

Hi [Name], I help small teams with practical VPS/Docker operations: deployment rescue, backup/restore proof, lightweight monitoring, and handover notes.

If you have a client app running on a VPS, I can do a fixed-scope audit in 24-48 hours and deliver a short report with commands checked, risks found, and next actions.

Would a VPS/Docker rescue audit be useful for any current project?

## Follow-Up 1

Hi [Name], quick follow-up. The strongest fit is when a VPS/Docker app is working but fragile: no tested backup, no monitoring, unclear deployment notes, or recurring startup/routing issues.

I can start with a small fixed-scope audit, not an open-ended contract.

## Follow-Up 2

Hi [Name], closing the loop. If VPS/Docker reliability becomes a priority later, I can help with a short audit, backup/restore check, or monitoring setup.

Thanks,  
Mohamed

## Message Tracking Rule

Every message sent should be recorded in:

```text
trackers/lead-validation-tracker.csv
```

Record:

- lead URL,
- exact problem wording,
- service fit,
- whether a message was sent,
- whether a reply came back,
- next action.
