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
month_abbrevation='AERmon'
day_abbrevation='AERday'

monthflag=1
dayflag=0
#$bindir has to be defined by the calling script

varfile="${bin_dir}/vars.txt"
readarray vars < ${varfile}
#echo ${vars[*]}

experimentfile="${bin_dir}/experiments.txt"
readarray experiments < ${experimentfile}
#echo ${experiments[*]}

VARIANT_LABEL='r1i1p1f1'
VARIANT_LABEL='r1i1p1f1,r1i1p1f2,r1i1p2f1,r1i2p1f1,r1i1p1f3,r1i1p3f1'
REALM='aerosol,atmos,atmosChem,ocean,seaIce'
FREQUENCY='mon'
SlotsToUse=8
logdate=`date +%Y%m%d%H%M%S`
UUID=`uuidgen`
logdir="${HOME}/logs"

exec_script="${HOME}/ESGF_download/bin/exec_dl_script.sh" 
dl_dir='/nird/projects/NS9252K/CMIP6/'
