# bomSynoptic
Automated download and display of synoptic weather charts from the Australian Bureau of Meteorology

## Background
(explain motivation and desired results)

## Current state
Script can download most recent pdf and convert it to a scaled png file

## todo
   
   * write a timer service 
   * 'xdg-open' the png file in its own workspace (in i3 window manager)

## Deployment

Current deployment target:

Item | Value
-----|------
VPS | `cremonde`
Site | `pestrel.com`
Nginx web root | `/srv/www/pestrel/`
Latest published image | `/srv/www/pestrel/synopticLatest.png`
App install dir | `/opt/synoptic`

Runtime dependencies on the VPS:

- `curl`
- `imagemagick`
- `ghostscript`
- `nginx`

Relevant scripts:

File | Purpose
-----|--------
`setup.sh` | Install systemd units, nginx config, and web content on `cremonde`
`deploy.sh` | Copy `synopticChart.sh` to `cremonde` and restart `synoptic.service`


Files:

File | Description | Location
-----|-------------|---------
synopticChart.sh | Top level script |
func/deriveTimeString.sh | Return 'date + time' portion of latest chart for download
func/
