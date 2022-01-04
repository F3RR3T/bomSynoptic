
# BOM releases four synoptic charts per day.
# They are named according to the UTC dat/time for which they are valid.
#
# Filenames follow this template: IDY00030.YYYYMMDDHHMM.[png|pdf]
#
# IDY00030 = the asset name (i.e. the Mean Sea Level Pressure synoptic chart)
# .
# <datetime string>
# .
# <extension>  (I want pdf because it contains a Scalable Vectort Graphic (SVG) image)


# This function returns the filename for the most recent chart.

DeriveTime() {
    nowDate=$(\date -u +%y%m%d)   # backslash req. to unalias date to raw format
    nowTime=$(\date -u +%H%M)     # (I have date aliased to date -R)
    echo $nowDate$nowTime

    if [ $nowTime -gt 1800 ] ; then
        fileTime=1800
    elif [ $nowTime -gt 1200 ] ; then
        fileTime=1200
    elif [ $nowTime -gt 0600 ] ; then
        fileTime=0600
    else
        fileTime=0000
    fi

    echo $nowDate$fileTime
}

