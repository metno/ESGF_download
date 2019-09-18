#!/bin/bash

month_abbrevation='AERmon'
day_abbrevation='AERday'

monthflag=1
dayflag=0
basedir='../download/'
scriptdir='../dl_scripts/'
CMIP6dir='/nird/projects/NS9252K/CMIP6/histSST-piNTCF/'
CMIP6dir='/nird/projects/NS9252K/CMIP6/histSST-piAer/'
varfile='./vars.txt'

for file in `find ${CMIP6dir} -name '*.nc'`
	do echo ${file}
	filename=`basename ${file}`
	filevar=`echo ${filename} | cut -d_ -f1`
	var_in_file=`cat ${varfile} | grep ${filevar} | wc -l`
	if [ ${var_in_file} -eq 0 ]
		then echo "deleting file ${file}"
		rm ${file}
	fi
done



