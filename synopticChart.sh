#!/bin/bash
# SJP 28 Nov 2021
# Get synoptic weather charts from BOM and make them into a movie
# See notes about BOM. they don't like scrapers but permit anon FTP
# for *personal use*
#  This script will be called froma timer, once every 6 hours, which is 
# how often new charts are published.
#
# The timer will take care of scheduing the call to the script
# todo: check what happens with daylight saving...

source func/deriveTimeString.sh

dateTime=$(DeriveTime)

latestChart=IDY00030.${dateTime}.pdf


curl -o ${latestChart} ftp://ftp.bom.gov.au/anon/gen/fwo/${latestChart}
convert -density 300 ${latestChart} ${dateTime}.png

