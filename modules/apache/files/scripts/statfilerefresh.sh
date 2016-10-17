#!/bin/bash

cheatdir="/mnt/dispatcher/$1/cheats"
cheatday=$(date --date='TZ="America/New_York"' "+${cheatdir}/%Y/%m/%d")
statfile="${cheatday}/.stat"

if [ ! -d ${cheatday} ]; then /bin/mkdir -p ${cheatday}; fi
# if the statfile doesn't exist, then it was not yet re-activated, we simulate a reactivation by touching the file and rebuilding, which can be bad, but it's a compromise for now
if [ ! -f ${statfile} ]; then /usr/bin/touch ${statfile}; fi

/usr/bin/find -O2 ${cheatdir} -maxdepth 4 -type f -name '*.html' -not -newer $statfile | grep -Eo "${cheatdir}/[0-9]{4}/[0-9]{2}/[0-9]{2}/" | sort | uniq | xargs -I{} /usr/bin/touch {}.stat
/usr/bin/find -O2 ${cheatdir} -maxdepth 4 -type f -name '.stat' -exec /bin/chown www-data: {} +
