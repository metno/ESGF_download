#!/bin/bash

# script to download data from ESGF based on either a synda search
# or a text file with redirected synda search output
# only monthly data is downloaded
# This script differs from synda in the sense that it starts a synda install
# command for every dataset in retries up to 5 times the synda install
# in case that fails

if [[ $# -lt 2 ]] 
	then echo "usage: ${0} <synda search tokens>"
	echo "or ${0} -f <filename with synda search output>"
	exit
fi
echo ${1}

if [[ "${1}" == "-f" ]]
	then tmp_file="${2}"
else
	tmp_file="tmp.txt"
	esgf_search=$@
	echo "starting synda search..."
	synda search ${esgf_search[@]}  | grep 'mon\.\|fx\.' > ${tmp_file}
	echo "synda search done..."
fi

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for line in `cat ${tmp_file}`
do echo ${line}
	dataset=`echo ${line} | rev | cut '-d ' -f 1 | rev`
	completeness=`echo ${line} | cut '-d ' -f 1`
	# check if the dataset might have been installed since the last synda search run
	# in case we get the dataset names from a file
	if [[ ${1} == "-f" ]]
		then completeness=`synda search ${dataset} | cut '-d ' -f1`
	fi
	if [[ "${completeness}" == 'complete' ]]
		then echo "dataset ${dataset} already installed"
		continue
	else
		echo "installing dataset ${dataset}"
		(( max_tries=5 ))
		synda install -y ${dataset}
		if [[ $? -ne 0 ]]
			then echo "dataset ${dataset} failed! retrying..."	
			#set -x
			while [[ ${max_tries} -ne 0 ]]
				do (( try_no=5-max_tries+1 ))
				echo "retry # ${try_no} dataset ${dataset}"
				synda install -y ${dataset}
				if [[ $? -eq 0 ]]
					then break
				else
					(( max_tries -= 1 ))
					if [[ ${max_tries} -lt 0 ]]
						then echo "5 retries failed: giving up dataset ${dataset}"
						echo "you might want to try to run "
						echo "synda install -y ${dataset}" 
						echo "several times by hand!"
					fi
				fi
			done
			#set +x
		fi
	fi
done
IFS=$SAVEIFS
