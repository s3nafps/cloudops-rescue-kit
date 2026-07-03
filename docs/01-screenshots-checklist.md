# Screenshots Checklist

Screenshots are evidence. They should show operational outcomes without exposing secrets.

## Required For First Portfolio Case Study

- [ ] GitHub repo homepage.
- [ ] Diagnostics command run.
- [ ] Generated report folder.
- [ ] `docker ps -a` before state.
- [ ] Failing health check or simulated failure.
- [ ] Fix command or config change summary.
- [ ] Passing health check.
- [ ] Backup archive created.
- [ ] `SHA256SUMS` verification.
- [ ] Restore test into disposable volume.
- [ ] Uptime Kuma dashboard with at least one monitor.
- [ ] Final incident report or handover note.

## Redaction Checklist

- [ ] No passwords.
- [ ] No private keys.
- [ ] No API tokens.
- [ ] No full `.env` output.
- [ ] No private customer data.
- [ ] No database dumps.
- [ ] IP/domain hidden if needed.
- [ ] Logs reviewed before publishing.

## Suggested File Names

Use predictable names:

- `01-diagnostics-run.png`
- `02-report-folder.png`
- `03-container-before.png`
- `04-healthcheck-failed.png`
- `05-fix-applied.png`
- `06-healthcheck-passed.png`
- `07-backup-created.png`
- `08-checksum-verified.png`
- `09-restore-test.png`
- `10-monitoring-dashboard.png`
- `11-incident-report.png`

## Good Screenshot Rules

- Show the command and the result when possible.
- Crop unnecessary desktop clutter.
- Use terminal zoom large enough to read.
- Add short captions in the case study, not on top of the image.
- Keep one private folder for raw screenshots and one public folder for redacted screenshots.
