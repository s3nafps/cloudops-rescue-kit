# Security And Secrets Notes

Support work often fails when secrets are handled casually. Keep this project safe by default.

## Never Put These In Chat, Issues, Reports, Or Screenshots

- passwords,
- private SSH keys,
- API tokens,
- database URLs with credentials,
- `.env` files,
- cloud provider secret keys,
- session cookies,
- private customer data.

## Safer Access Patterns

Prefer:

- temporary limited user,
- platform-approved remote access,
- screen share where the client controls secrets,
- short-lived tokens,
- read-only access for diagnostics where possible.

## Redaction

Before publishing:

```bash
grep -R -n -i "password\|token\|secret\|apikey\|api_key\|private" reports/ || true
```

Manual review is still required. Grep does not catch every secret.

## Report Rule

A good support report explains:

- what was checked,
- what failed,
- what changed,
- how it was verified,
- what risk remains.

It should not reveal credentials.
