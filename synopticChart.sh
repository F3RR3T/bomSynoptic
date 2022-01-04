#!/bin/bash
# SJP 28 Nov 2021
# Get synoptic weather charts from BOM and make them into a movie
# See notes about BOM. they don't like scrapers but permit anon FTP
# for *personal use*
#  This script will be called froma timer, once every 6 hours, which is 
# how oftern new charts are published.
#
# The timer will take care of scheduing the call to the script
# todo: check what happens with daylight saving...

# Construct current date and time
# -u for UTC, just get the date portion. 
datePart=$(date -u +%Y%m%d)

# Now construct the 'time' pertion of the filename.
# It is always 0000, 0600, 1200, or 1800

timePart=0000
currentchart=${datePart}-${timePart}
latestChart=IDY00030.${datePart}${timePart}.pdf


curl -o ${latestChart} ftp://ftp.bom.gov.au/anon/gen/fwo/${latestChart}
convert -density 300 ${latestChart} ${currentchart}.png

