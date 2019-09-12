#!/bin/bash

# small script to execute wget scripts downloaded from ESGF
# following a wild card search

if [[ $# -lt 3 ]] 
	then echo "usage: ${0} <scriptdir> <dl directory> <variable>"
	echo variable can be a wildcard supported by the find command
	echo example: ./exec_dl_script_per_variable.sh ../dl_scripts/ /nird/projects/NS9252K/CMIP6/ 'rlut*'
	exit
fi

set -x
hostname=`hostname`
script_dir=`realpath ${1}`
dl_dir=`realpath ${2}`
var=${3}

# there's more intelligent ways of doing this
# but we are in a hurry at this point
script_base_path="/home/jang/data/ESGF_download/bin/"
if [[ "$hostname" =~ .*nird.* ]]
	then script_base_path="/nird/home/jang/ESGF_download/bin/"
fi

cd ${dl_dir}
for script in `find ${script_dir} -name "${var}".sh | sort`
	do echo ${arg}
	${script_base_path}/exec_dl_script.sh ${script} "${dl_dir}"
done


