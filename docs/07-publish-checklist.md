# Publish Checklist

Use this before making the repo public.

## Repo

- [ ] Confirm all scripts are executable after clone:

```bash
chmod +x scripts/*.sh
```

- [ ] Run Bash syntax check:

```bash
for file in scripts/*.sh; do bash -n "$file"; done
```

- [ ] Confirm GitHub Actions are green:
  - Shell syntax
  - Demo lab evidence
- [ ] Run diagnostics on a safe test machine.
- [ ] Run health check against example or test endpoint.
- [ ] Run the demo lab in `docs/08-demo-lab.md`.
- [ ] Run backup/restore against disposable test volume.
- [ ] Add public screenshots under `screenshots/public/`.
- [ ] Keep private/raw screenshots out of Git.

## Case Study

- [ ] Copy `docs/00-case-study-template.md`.
- [ ] Fill in problem, checks, root cause, fix, and verification.
- [ ] Add before/after screenshots.
- [ ] Redact secrets, private IPs, customer names, and tokens.
- [ ] Link the case study from README or portfolio.

## LinkedIn

- [ ] Add GitHub repo to Featured.
- [ ] Add case study to Featured.
- [ ] Publish the short project post from `career-assets/linkedin-profile.md`.

## Freelance Validation

- [ ] Screenshot 10 relevant job/gig examples.
- [ ] Record buyer wording in `trackers/freelance-lead-validation-tracker.csv`.
- [ ] Send 5 highly specific proposals.
- [ ] Do not build a larger tool until repeated demand appears.
