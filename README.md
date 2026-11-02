# SCA duplicate-upload test

This small repository tests whether Datadog accepts an SCA upload for a commit that has already been scanned.

**Result: repeated uploads were rejected, including A → B → A.** A new commit was accepted.

## What we tested

Run on November 2, 2026 against **datad0g staging, org 2**, using `datadog-ci` and its SBOM plugin v5.13.1.

The fixture is a CycloneDX SBOM containing one library, `lodash@4.17.20`. No dependency installation or execution is needed. Every upload used branch `main`, service `sca-duplicate-upload-repro`, and environment `ci`.

- **Commit A:** `75633abea70e7e9976a98eba7cd40b4130120d35`
- **Commit B:** `47409f373b29c97eecfc269aefa77763e5647878`

B is an empty commit: the SBOM is identical, only the commit SHA changes.

## Method and results

We waited for each accepted upload to appear in the summary API before continuing.

| Step | Upload | Result |
| --- | --- | --- |
| 1 | A for the first time | Accepted; summary created |
| 2 | A again | Rejected as a duplicate; summary unchanged |
| 3 | B for the first time | Accepted; separate summary created |
| 4 | A again after B | Rejected as a duplicate; A's summary unchanged |

Both summaries reported one library and one library vulnerability. Their oldest/newest summary timestamps were:

- A: `2026-11-02T19:51:09.738306Z`, unchanged after both retries.
- B: `2026-11-02T19:52:17.959131Z`.

The CLI printed this for the rejected uploads:

```text
Duplicate upload detected
An SBOM has already been processed for branch:main and sha:75633abea70e7e9976a98eba7cd40b4130120d35
Push a new commit before uploading again
Exiting with code 0
```

**A zero CLI exit code does not mean the scan was accepted.** Read the duplicate-upload message. We did not capture the raw HTTP response in this run.

## How to repeat

Authenticate for the intended org, then upload a committed fixture:

```sh
dd-auth --domain dd.datad0g.com -- ./upload.sh
```

Check the summary for the exact repository, branch and commit through `GET /api/v2/static-analysis/repositories/summary`, using `filter[repository_id]`, `filter[branch]`, and `filter[sha]`. A successful upload alone does not mean its summary has been created yet.

To retry A after B without changing the remote branch history:

```sh
git switch --detach 75633abea70e7e9976a98eba7cd40b4130120d35
dd-auth --domain dd.datad0g.com -- env DD_GIT_BRANCH=main ./upload.sh
git switch main
```

We used `DD_GIT_BRANCH=main` to keep the original branch identity while checking out A locally. The CLI confirmed branch `main` and A's SHA in its output. No force-push was used.

A and B already have summaries in this staging org, so rerunning either should be rejected. Use a fresh commit to repeat the first-upload acceptance check.

## Scope

This verifies sequential customer uploads after the original summary exists. It does not test concurrent uploads before summary creation, automatic advisory refreshes, feature branches, or downstream finding contents. No production uploads were made.
