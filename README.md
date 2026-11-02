# SCA duplicate uploads

Tested in Datadog staging on November 2, 2026 with `datadog-ci` v5.13.1.

Uploaded the same SBOM on the same branch, waiting for each accepted scan's summary before continuing. B changes only the commit SHA.

| Upload | Result |
| --- | --- |
| A (`75633ab`) | Accepted |
| A again | Duplicate rejected |
| B (`47409f3`) | Accepted |
| A after B | Duplicate rejected |

A's summary timestamp and counts stayed unchanged. The CLI prints **“Duplicate upload detected”** but exits with code **0**.

Run `./upload.sh` with Datadog credentials configured. To retry an older commit, check it out and set `DD_GIT_BRANCH=main`.

Concurrent uploads and refresh timers were not tested.

Results https://dd.datad0g.com/security/code-security/repositories/github.com%2Frjcoulter22%2Fsca-duplicate-upload-repro/main/47409f373b29c97eecfc269aefa77763e5647878/library-list?query=%40git.repository.id%3Agithub.com%2Frjcoulter22%2Fsca-duplicate-upload-repro%20%40git.branch%3Amain%20%40git.commit.sha%3A47409f373b29c97eecfc269aefa77763e5647878%20%40dependency.ui_score%3A%2A%20%40sent_by_vr%3Atrue&fromUser=false&index=cideps&start=1793562738007&end=1793649308469&paused=false
