#!/bin/bash

if [[ $# -lt 1 ]] 
	then echo "usage: ${0} <dl directory> [<experiment> [<experiment2>]]"
	echo example: ${0} ../dl_scripts/ piControl
	echo if experiment is not given, the ones from the file experiments.txt is used
	exit
fi




bin_dir=`realpath ${0}`
scriptdir=`realpath ${1}`
shift
bin_dir=`dirname ${bin_dir}`

. ./script_include.sh

if [ $# -ge 1 ]
	then experiments=($@)
fi

runfile="./runfile_${logdate}_${UUID}_${HOSTNAME}.run"
rm -f "${runfile}"
DryRunFlag=0

# http://esgf-data.dkrz.de/esg-search/search/?offset=0&limit=10&type=Dataset&replica=false&latest=true&variable_id=abs550aer&realm=aerosol&activity_id%21=input4MIPs&variant_label=r1i1p1f1&frequency=mon&mip_era=CMIP6&facets=mip_era%2Cactivity_id%2Cmodel_cohort%2Cproduct%2Csource_id%2Cinstitution_id%2Csource_type%2Cnominal_resolution%2Cexperiment_id%2Csub_experiment_id%2Cvariant_label%2Cgrid_label%2Ctable_id%2Cfrequency%2Crealm%2Cvariable_id%2Ccf_standard_name%2Cdata_node&format=application%2Fsolr%2Bjson

#download_structure=project,product,institute,model,experiment,time_frequency,realm,cmor_table,ensemble,variable
#download_structure=,experiment,model,variant_label
for VAR in ${vars[*]}
	do echo ${VAR}
	for EXPERIMENT in ${experiments[*]}
		do echo ${EXPERIMENT}
			script_url="https://esgf-data.dkrz.de/esg-search/wget?mip_era=CMIP6&variable=${VAR}&experiment_id=${EXPERIMENT}&variant_label=${VARIANT_LABEL}&realm=${REALM}&frequency=${FREQUENCY}&limit=9999&download_structure=experiment_id,source_id,variant_label"
			script_file="${scriptdir}/${VAR}_${EXPERIMENT}_${VARIANT_LABEL}.sh"
			wget -O ${script_file} ${script_url}
			chmod u+x,g+x ${script_file}
			logfile="${logdir}/${VAR}_${EXPERIMENT}_${VARIANT_LABEL}_${logdate}.log"
			#echo "${exec_script} ${script_file} ${dl_dir} >> ${logfile} 2>&1" >> "${runfile}"
			echo "${exec_script} ${script_file} ${dl_dir} >> ${logfile}" >> "${runfile}"
	done
done

echo /usr/bin/parallel -v -j ${SlotsToUse} -a "${runfile}"
exit

if [ ${DryRunFlag} -eq 0 ]
   then
   echo Starting parallel for to download...
   set -x
   /usr/bin/parallel -v -j ${SlotsToUse} -a "${runfile}"
   set +x
else
   #dry run: list commands in to be executed order
   echo "DRY-RUN!"
   /usr/bin/parallel --dry-run -v -j ${SlotsToUse} -a "${runfile}"
fi
