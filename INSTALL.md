# Installation
(TODO: write a boostrap script)

1. clone repository
1. edit `bin/script_include.sh` to your needs  
  in particular `logdir` and `dl_dir`
1. create `logdir`
1. create an ESGF openID
1. download the first download script using the API by hand (downloading the certificate)
1. fill `bin/vars_all.txt` and `bin/experiments_all.txt` with your variables and experiments
1. start get_dl_scripts_v2.sh -a
1. start the resulting download scripts
