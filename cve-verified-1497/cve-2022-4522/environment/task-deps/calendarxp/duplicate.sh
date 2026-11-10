#! /bin/bash

set -e

for t in Pop Flat ; do
    for s in "${t}CalXP"/{demos,themes}/*/{i,n}"${t,,}eng.htm" ; do
        if [[ ! "${s}" =~ \* ]] ; then
            cp -av "${s%%/*}/engines/${s##*/}" "${s}"
        fi
    done
done

