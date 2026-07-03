# Backup And Restore Runbook

Backups are not complete until a restore has been tested.

## Scope

This runbook covers Docker Compose-managed volumes. It does not automatically back up bind mounts, cloud object storage, external managed databases, or secret managers.

## Before Backup

Identify the Compose project name:

```bash
docker compose ls
```

List volumes:

```bash
docker volume ls --filter "label=com.docker.compose.project=PROJECT_NAME"
```

Check whether the app writes constantly. For databases, prefer app-specific dump tools or stop writes before volume backup.

## Create Backup

```bash
./scripts/backup-compose-volumes.sh PROJECT_NAME
```

Verify checksum:

```bash
cd backups/PROJECT_NAME-TIMESTAMP
sha256sum -c SHA256SUMS
```

## Restore Test

Restore into a disposable volume:

```bash
RESTORE_CONFIRM=YES ./scripts/restore-volume-backup.sh backups/PROJECT_NAME-TIMESTAMP/VOLUME.tar.gz PROJECT_NAME_restore_test
```

Inspect the restored volume:

```bash
docker run --rm -v PROJECT_NAME_restore_test:/target alpine:3.20 sh -c "find /target -maxdepth 2 | head -50"
```

## Schedule Example

Use cron only after manual backup and restore are proven:

```cron
15 2 * * * cd /opt/cloudops-rescue-kit && ./scripts/backup-compose-volumes.sh myproject >> /var/log/cloudops-backup.log 2>&1
```

## Storage Rule

Keep at least one copy away from the VPS:

- encrypted cloud storage,
- another server,
- local offline copy,
- provider snapshot.

## Handover

Document:

- backup location,
- schedule,
- restore command,
- last restore test date,
- checksum verification,
- what is not covered.
