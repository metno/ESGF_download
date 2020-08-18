#!/bin/bash

# small script to execute a download script downloaded from ESGF
# since that script is download the files into the cwd, 
# we have to chdir to the desired directory and call then the 
# download script

if [[ $# -lt 2 ]] 
	then echo "usage: ${0} <dl_script> <directory>"
	exit
fi

echo "debug: ${0} ${1} ${2}"


script_name=`realpath ${1}`
file_size=`stat --printf="%s" ${script_name}`
if [ ${file_size} -lt 100 ]
	then echo "script file size lower than 100 bytes! exiting..."
	exit
fi

cd ${2}
#/bin/bash ${script_name} -U < ~/.OpenID
/bin/bash ${script_name} -H -i -U < ~/.OpenID

hostname=`hostname`
target_group="ns9252k"
if [[ "$hostname" =~ .*nird.* ]]
	then #change owner to KeyClim project
	for arg in `find ${2} -group ${USER} | grep -v '.status'`
		do #echo ${arg}
		chown :${target_group} ${arg}
	done
fi



