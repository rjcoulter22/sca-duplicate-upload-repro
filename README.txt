Purpose
Verify that an SCA upload for an already-recorded scan identity is rejected.
This repository contains an inert CycloneDX fixture; no dependencies need to be installed or executed.

Live procedure
1. Publish this repository to the agreed GitHub destination and configure credentials for the agreed Datadog site/org.
2. Upload the committed fixture with ./upload.sh. Record the commit SHA and upload result.
3. Wait for the summary API/UI to show the SCA summary for this exact repository, branch, SHA, env and service. A successful upload alone is not proof that the summary exists yet.
4. Record its timestamps and counts, then run the identical upload command again without changing the commit or identity.
5. Verify the second request returns HTTP 409 / duplicate-upload rejection. Capture API response or server logs if the CLI treats duplicates as success.
6. Confirm the summary remains unchanged. Verify rejection occurred before SBOM publication; later timer-generated findings are not evidence that the duplicate upload was accepted.
7. Positive control: make a new commit and upload again; confirm it is accepted and gets a separate summary.

Scope
This checks sequential uploads after summary creation, not concurrent uploads that race before it exists.
Repeat on a feature branch to test that path independently.
