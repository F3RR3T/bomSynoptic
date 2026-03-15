#!/bin/bash
set -euo pipefail

# SJP 28 Nov 2021 — extended for deployment
# Download BOM synoptic chart (IDY00030) and publish as PNG.
# BOM permits anonymous FTP for personal use.
# Charts are valid at 00, 06, 12, 18 UTC; files appear ~2h later.
# Deployed to /opt/synoptic/synopticChart.sh on pestrel.com.

ARCHIVE_DIR=/var/lib/synoptic/archive
RAW_DIR=/var/lib/synoptic/archive/raw
LATEST=/srv/www/synopticLatest.png

# Return the datetime string for the most recently published chart slot.
# BOM chart slots: 0000, 0600, 1200, 1800 UTC.
DeriveTime() {
    local nowDate nowTime fileTime
    nowDate=$(date -u +%Y%m%d)
    nowTime=$(date -u +%H%M)

    if   [ "$nowTime" -ge 1800 ]; then fileTime=1800
    elif [ "$nowTime" -ge 1200 ]; then fileTime=1200
    elif [ "$nowTime" -ge 0600 ]; then fileTime=0600
    else                               fileTime=0000
    fi

    echo "${nowDate}${fileTime}"
}

dateTime=$(DeriveTime)
latestChart="IDY00030.${dateTime}.pdf"

# -q no config file lookup  -f fail on error  -s silent
curlExit=0
curl -q -fs -o "${latestChart}" "ftp://ftp.bom.gov.au/anon/gen/fwo/${latestChart}" \
    || curlExit=$?

if [ "$curlExit" -gt 0 ]; then
    if [ "$curlExit" -eq 78 ]; then
        echo "No file at remote site: ${latestChart} (curl exit ${curlExit})" >&2
    fi
    exit "$curlExit"
fi

magick -density 300 "${latestChart}" -resize 1920x1080 "${dateTime}.png"

mv "${latestChart}" "${RAW_DIR}/"
cp "${dateTime}.png" "${ARCHIVE_DIR}/"
mv "${dateTime}.png" "${LATEST}"
chmod 644 "${LATEST}"
