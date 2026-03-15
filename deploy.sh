#!/bin/bash
set -euo pipefail

REMOTE=st33v@pestrel.com
PORT=40022

echo "Deploying synopticChart.sh to ${REMOTE}..."
scp -P "$PORT" synopticChart.sh "${REMOTE}:/opt/synoptic/synopticChart.sh"

echo "Restarting synoptic.service..."
if ssh -p "$PORT" "$REMOTE" "sudo systemctl restart synoptic.service"; then
    echo "SUCCESS: synoptic.service ran cleanly."
else
    echo "FAILURE: synoptic.service exited non-zero." >&2
    exit 1
fi
