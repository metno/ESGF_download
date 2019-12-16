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

Model='GISS-modelE.A2.CTRL'
Model=`pwd | rev | cut -d/ -f2 | rev`
Start='aerocom3'

set -x
varinfos=( \
'od550aer=od550aer=Column' \
'od550lt1aer=od550lt1aer=Column' \
'od440aer=od440aer=Column' \
'od870aer=od870aer=Column' \
'mmrpm10=mmrpm10=ModelLevel' \
'mmrso4=mmrso4=ModelLevel' \
'ta=ta=ModelLevel' \
'ps=ps=Surface' \
'tas=tas=Surface' \
)


month_abbrevation='AERmon'
day_abbrevation='AERday'
hourly_abbrevation='AERhr'

time_codes_to_run=( \
"AERmon=monthly=12" \
"AERday=daily=365" \
"AERhr=hourly=8760" \
)

time_codes_to_run=( \
"${month_abbrevation}=monthly=12" \
)

monthflag=1
dayflag=0
basedir='../download/'


set -x

for time_string in ${time_codes_to_run[*]}
	do echo $time_name

	#treat monthly data
	TSSize=`echo $time_string | cut -d= -f3`
	time_name=`echo $time_string | cut -d= -f2`
	time_code_abbrev=`echo $time_string | cut -d= -f1`
	for varinfo in ${varinfos[*]}
		do echo ${varinfo}
		data_kind=`echo ${varinfo} | cut -d= -f3`
		aerocom_var_name=`echo ${varinfo} | cut -d= -f1`
		cmip_var_name=`echo ${varinfo} | cut -d= -f2`
		#so far $aerocom_var_name and $cmip_var_name are the same
		for arg in `find ../download/ -name "${cmip_var_name}_${time_code_abbrev}*.nc" | sort`

			do file=`basename ${arg}`
			#rest="${year}.nc"
			model_time_steps=`ncks -m --trd -v time ${arg} | grep "time dimension 0" | cut '-d,' -f2 | cut -d= -f2 | cut '-d ' -f2`
			model_year_no=$(( ${model_time_steps} / ${TSSize} ))
			#exception for NorESM
			if [[ "$file" =~ .*NorESM2.* ]] 
				then
				echo "NORESM naming"
				model=`echo $file | cut -d_ -f4`
				experiment_id=`echo $file | cut -d_ -f3`
				realisation=`echo $file | cut -d_ -f5`
			else
				model=`echo $file | cut -d_ -f3`
				experiment_id=`echo $file | cut -d_ -f4`
				realisation=`echo $file | cut -d_ -f5`
			fi
			#model="${model}_${experiment_id}_${realisation}"
			model="${model}_${experiment_id}"
			#modeldir="${basedir}/${model}/renamed/"
			modeldir="./"
			#mkdir -p ${modeldir}
			start_year=`ncdump -v time -t ${arg} | grep "time =" | tail -n1 | cut -d= -f2 | cut '-d"' -f2 | cut -d- -f1`

			(( year = ${start_year} )) 
			(( StartTimeStep=1 ))
			(( EndTimeStep=${StartTimeStep}+${TSSize}-1 ))
			#aerocom3_CAM5-ATRAS_AP3-CTRL_od550aer_Column_2010_monthly.nc

			for ((i=0; i <= ${model_year_no}-1; i += 1))
				do
				outfile="${Start}_${model}_${aerocom_var_name}_${data_kind}_${year}_${time_name}.nc"
				outfile="${modeldir}/${outfile}"
				StartTimeStep=$(( ${i}*${TSSize} ))
				EndTimeStep=$(( ${StartTimeStep}+${TSSize} -1 ))
				echo "ncks -O -h -d time,${StartTimeStep},${EndTimeStep} ${arg} ${outfile}"
				ncks -4 -L 5 -O -d time,${StartTimeStep},${EndTimeStep} ${arg} ${outfile}
				(( year=${year}+1 ))
			done
		done
	done
done





	#echo "cp ${arg} ${newfile}"
	#cp ${arg} ${newfile}
	#mv ${arg} ${newfile}
