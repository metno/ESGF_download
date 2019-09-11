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
Start='aerocom3'
var='od550aer'
month_abbrevation='AERmon'
day_abbrevation='AERday'

monthflag=1
dayflag=0
basedir='../download/'

set -x

if [[ ${monthflag} -gt 0 ]]
	then

	#treat monthly data
	TSSize=12
	time_name='monthly'
	data_kind='Column'
	for arg in `find ../download/ -name "${var}_${month_abbrevation}*.nc" | sort`

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
		modeldir="${basedir}/${model}/renamed/"
		mkdir -p ${modeldir}
		start_year=`ncdump -v time -t ${arg} | grep "time =" | tail -n1 | cut -d= -f2 | cut '-d"' -f2 | cut -d- -f1`

		(( year = ${start_year} )) 
		(( StartTimeStep=1 ))
		(( EndTimeStep=${StartTimeStep}+${TSSize}-1 ))
		#aerocom3_CAM5-ATRAS_AP3-CTRL_od550aer_Column_2010_monthly.nc

		for ((i=0; i <= ${model_year_no}-1; i += 1))
			do
			outfile="${Start}_${model}_${var}_${data_kind}_${year}_${time_name}.nc"
			outfile="${modeldir}/${outfile}"
			StartTimeStep=$(( ${i}*${TSSize} ))
			EndTimeStep=$(( ${StartTimeStep}+${TSSize} -1 ))
			echo "ncks -O -h -d time,${StartTimeStep},${EndTimeStep} ${arg} ${outfile}"
			ncks -4 -L 5 -O -d time,${StartTimeStep},${EndTimeStep} ${arg} ${outfile}
			(( year=${year}+1 ))
		done

	done
fi





	#echo "cp ${arg} ${newfile}"
	#cp ${arg} ${newfile}
	#mv ${arg} ${newfile}
