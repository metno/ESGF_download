#!/bin/bash
 # common settings...

monthflag=1
dayflag=0
#$bindir has to be defined by the calling script

varfile="${bin_dir}/vars.txt"
varfile_all="${bin_dir}/vars_all.txt"
readarray vars < ${varfile}
readarray vars_all < ${varfile_all}
#echo ${vars[*]}

experimentfile="${bin_dir}/experiments.txt"
experimentfile_all="${bin_dir}/experiments_all.txt"
readarray experiments < ${experimentfile}
readarray experiments_all < ${experimentfile_all}
#echo ${experiments[*]}

VARIANT_LABEL='r1i1p1f1'
VARIANT_LABEL='r1i1p1f1,r1i1p1f2,r1i1p2f1,r1i2p1f1,r1i1p1f3,r1i1p3f1'
REALM='aerosol,atmos,atmosChem,ocean,seaIce'
FREQUENCY='mon,fx'
SlotsToUse=8
logdate=`date +%Y%m%d%H%M%S`
UUID=`uuidgen`
logdir="${HOME}/logs"

exec_script="${HOME}/ESGF_download/bin/exec_dl_script.sh" 
dl_dir='/nird/projects/NS9252K/CMIP6/'
