#!/bin/bash

function isyearleapyear {
year=$1
if [ `expr ${year} % 400` -eq  0 ]
	then echo '1'
elif [ `expr ${year} % 100` -eq 0 ]
	then echo '0'
elif [ `expr ${year} % 4` -eq 0 ]
	then echo '1'
else
	echo '0'
fi }

Start='aerocom3'
var='od550aer'
month_abbrevation='AERmon'
day_abbrevation='AERday'

monthflag=1
dayflag=0
basedir='../download/'

search_url='https://esgf-data.dkrz.de/esg-search/wget?mip_era=CMIP6&experiment_id=EXPERIMENT_ID&variable=VARIABLE&variant_label=LABEL'

set -x

vars=(\
'abs550aer' \
'airmass' \
'depdust' \
'dms' \
'drybc' \
'drydust' \
'dryoa' \
'dryso2' \
'dryso4' \
'dryss' \
'ec550aer' \
'emibc' \
'emidms' \
'emidust' \
'eminox' \
'emioa' \
'emiso2' \
'emiso4' \
'emiss' \
'emivoc' \
'loaddust' \
'loadso4' \
'loadss' \
'mmrbc' \
'mmrdust' \
'mmrnh4' \
'mmroa' \
'mmrso4' \
'mmrsoa' \
'mmrss' \
'od440aer' \
'od550aer' \
'od550bc' \
'od550dust' \
'od550lt1aer' \
'od550no3' \
'od550oa' \
'od550so4' \
'od550soa' \
'od550ss' \
'od870aer' \
'pr' \
'rlut' \
'rlutaf' \
'rlutcs' \
'rlutcsaf' \
'rsdt' \
'rsut' \
'rsutaf' \
'rsutcs' \
'rsutcsaf' \
'sconcdust' \
'sconcso4' \
'sconcss' \
'so2' \
'tas' \
'wetbc' \
'wetdust' \
'wetoa' \
'wetso2' \
'wetso4' \
'wetss' \
)

experiments=( \
'historical' \
'histSST' \
'histSST-piAer' \
'histSST-piNTCF' \
'piClim-2xDMS' \
'piClim-2xdust' \
'piClim-2xss' \
'piClim-BC' \
'piClim-NTCF' \
'piClim-OC' \
'piClim-SO2' \
'piClim-aer' \
'piClim-control' \
'piClim-histaer' \
'piClim-histall' \
'piControl' \
)

domains=( \
'aerosol' \
'atmos' \
'atmosChem' \
)

#http://esgf-data.dkrz.de/esg-search/search/?offset=0&limit=10&type=Dataset&replica=false&latest=true&variable_id=abs550aer&mip_era=CMIP6&activity_id%21=input4MIPs&facets=mip_era%2Cactivity_id%2Cmodel_cohort%2Cproduct%2Csource_id%2Cinstitution_id%2Csource_type%2Cnominal_resolution%2Cexperiment_id%2Csub_experiment_id%2Cvariant_label%2Cgrid_label%2Ctable_id%2Cfrequency%2Crealm%2Cvariable_id%2Ccf_standard_name%2Cdata_node&format=application%2Fsolr%2Bjson
DOMAIN="${domains[0]}"
#http://esgf-data.dkrz.de/esg-search/search/?offset=0&limit=10&type=Dataset&replica=false&latest=true&mip_era=CMIP6&variable_id=abs550aer&realm=aerosol&variant_label=r1i1p1f1&activity_id%21=input4MIPs&facets=mip_era%2Cactivity_id%2Cmodel_cohort%2Cproduct%2Csource_id%2Cinstitution_id%2Csource_type%2Cnominal_resolution%2Cexperiment_id%2Csub_experiment_id%2Cvariant_label%2Cgrid_label%2Ctable_id%2Cfrequency%2Crealm%2Cvariable_id%2Ccf_standard_name%2Cdata_node&format=application%2Fsolr%2Bjson
VARIANT_LABEL='r1i1p1f1'
REALM='aerosol,atmos,atmosChem'
for VAR in ${vars[*]}
	do echo ${VAR}
	for EXPERIMENT in ${experiments[*]}
		do echo ${EXPERIMENT}
			script_url="https://esgf-data.dkrz.de/esg-search/wget?mip_era=CMIP6&variable=${VAR}&experiment_id=${EXPERIMENT}&variant_label=${VARIANT_LABEL}&realm=${REALM}"
			script_file="${VAR}_${EXPERIMENT}_${DOMAIN}.sh"
			wget -O ${script_file} ${script_url}
		exit
	done
done

