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
