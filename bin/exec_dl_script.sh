#!/bin/bash

# small script to execute a download script downloaded from ESGF
# since that script is download the files into the cwd, 
# we have to chdir to the desired directory and call then the 
# download script

if [[ $# -lt 2 ]] 
	then echo "usage: ${0} <dl_script> <directory>"
	exit
fi

script_name=`realpath ${1}`

cd ${2}
/bin/bash ${script_name}





