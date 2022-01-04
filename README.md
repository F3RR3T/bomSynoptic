# bomSynoptic
Automated download and display of synoptic weather charts from the Australian Bureau of Meteorology

## Background
(explain motivation and desired results)

## Current state
Script can download most recent pdf and convert it to a scaled png file

## todo
   
   * write a timer service 
   * 'xdg-open' the png file in its own workspace (in i3 window manager)


Files:

File | Description | Location
-----|-------------|---------
synopticChart.sh | Top level script |
func/deriveTimeString.sh | Return 'date + time' portion of latest chart for download
func/
