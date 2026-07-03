# Troubleshooting Decision Tree

## App Is Down

Start:

```bash
./scripts/collect-diagnostics.sh
docker ps -a
```

### Container Is Exited

Check:

```bash
docker logs --tail=100 CONTAINER
```

Likely causes:

- missing environment variable,
- bad start command,
- dependency install failure,
- database unavailable,
- permission issue.

Next:

- fix the smallest known issue,
- restart,
- verify logs and endpoint.

### Container Is Restarting

Check:

```bash
docker inspect --format='{{.State.ExitCode}} {{.State.Error}}' CONTAINER
docker logs --tail=100 CONTAINER
```

Next:

- confirm config,
- check memory pressure,
- check database availability,
- check app crash trace.

### Container Is Running But Endpoint Fails

Check:

```bash
docker ps --format 'table {{.Names}}\t{{.Ports}}\t{{.Status}}'
curl -I http://localhost:PORT
ss -tulpn
```

If localhost works:

- check reverse proxy,
- check DNS,
- check firewall,
- check SSL/TLS mode.

If localhost fails:

- check app binding host,
- check internal app port,
- check health route,
- check logs.

### Disk Is Full

Check:

```bash
df -h
docker system df
```

Safe actions after review:

- rotate or compress logs,
- remove unused images,
- remove unused build cache,
- expand disk,
- move backups off-server.

Avoid deleting volumes unless backup and owner approval are confirmed.

### Backup Is Missing

Next:

- identify data locations,
- run a manual backup,
- verify checksum,
- perform restore test,
- schedule backups only after manual proof.
