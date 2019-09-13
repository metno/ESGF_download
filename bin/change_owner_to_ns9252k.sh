#!/bin/bash

# small script to execute a download script downloaded from ESGF
# since that script is download the files into the cwd, 
# we have to chdir to the desired directory and call then the 
# download script

if [[ $# -lt 1 ]] 
	then echo "usage: ${0} <directory>"
	exit
fi

set -x


hostname=`hostname`
target_group="ns9252k"
if [[ "$hostname" =~ .*nird.* ]]
	then #change owner to KeyClim project
	for arg in `find ${1} -group ${USER} | grep -v '.status'`
		do echo ${arg}
		chown :${target_group} ${arg}
	done
fi



