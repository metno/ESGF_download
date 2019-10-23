#!/usr/bin/env python3

if __name__ == '__main__':
    import logging

    import argparse
    import uuid
    import socket
    from datetime import datetime
    import urllib.request
    from pathlib import Path
    import os
    import sys

    options = {}
    uuid = uuid.uuid4()
    hostname = socket.gethostname()
    now = datetime.now()
    datestring = now.strftime("%Y%m%d%H%M%S")
    default_run_file = 'runfile_{}_{}_{}.run'.format(datestring,uuid,hostname)
    default_var_file = './vars.txt'
    default_experiment_file = './experiments.txt'
    all_var_file = './vars_all.txt'
    all_experiment_file = './experiments_all.txt'

    variant_label = 'r1i1p1f1'
    variant_label = 'r1i1p1f1,r1i1p1f2,r1i1p2f1,r1i2p1f1,r1i1p1f3,r1i1p3f1'
    realm = 'aerosol,atmos,atmosChem,ocean,seaIce'
    frequency = 'mon,fx'
    SlotsToUse=8
    homedir = str(Path.home())
    logdir = os.path.join(homedir, 'logs')
    logbasefile=os.path.basename(__file__).split('.')[:-1]
    running_script_dir = os.path.dirname(__file__)
    logbasefile='{}_{}.log'.format(logbasefile[0], datestring)
    logfile = os.path.join(logdir, logbasefile)

    exec_script = os.path.abspath(os.path.join(running_script_dir, "exec_dl_script.sh"))

    dl_dir='/nird/projects/NS9252K/CMIP6/'
    dl_script_dir = '../dl_scripts/'

    parser = argparse.ArgumentParser(
        description='command line interface to get_dl_scripts.py\n\n\n')
    parser.add_argument("--all",
                        help="read variables and experiments from files containing all experiments and variables",
                        action='store_true')
    parser.add_argument("--allvariants", help="query all realisations, not just r1*",action='store_true')
    parser.add_argument("--downloaddir", help="download directory of the to be downloaded files; defaults to "+dl_dir,
                        default=dl_dir)
    parser.add_argument("--experimentfile", help="read experiments from file", default=default_experiment_file)
    parser.add_argument("--experiments",
                        help="experiments to query",nargs="+")
    parser.add_argument("-o", "--outfile", help="name of the runfile", default=default_run_file)
    parser.add_argument("--scriptdir",
                        help="output directory for the downloaded download scripts; defaults to {}".format(dl_script_dir),
                        default=dl_script_dir)
    parser.add_argument("--logdir", help="output directory for log files; defaults to "+logdir, default=logdir)
    parser.add_argument("--logfile", help="logfile; defaults to "+logfile, default=logfile)
    parser.add_argument("--runfile", help="runfile; defaults to "+default_run_file, default=default_run_file)
    parser.add_argument("-s","--silence", help="silence warning message if called without parameter",action='store_true')
    parser.add_argument("-v", "--verbose", help="switch on verbosity",
                        action='store_true')
    parser.add_argument("--varfile", help="read variables from file", default=default_var_file)
    parser.add_argument("--variables", help="variables to query", nargs="+")
    parser.add_argument("--models", help="models to query", nargs="+")
    parser.add_argument("--variants", help="variant labels to query; defaults to {}".format(variant_label)
                        , default=variant_label)

    args = parser.parse_args()

    if args.silence:
        options['silence'] = True
    else:
        options['silence'] = False

    if args.runfile:
        options['runfile'] = args.runfile

    if args.variants:
        options['variant_label'] = args.variants

    if args.verbose:
        options['verbose'] = True
    else:
        options['verbose'] = False

    if args.scriptdir:
        options['scriptdir'] = os.path.abspath(args.scriptdir)

    if args.downloaddir:
        options['downloaddir'] = os.path.abspath(args.downloaddir)

    if args.logdir:
        options['logdir'] = os.path.abspath(args.logdir)

    if args.logfile:
        options['logfile'] = args.logfile
        logger = logging.getLogger(__name__)
        # logging.basicConfig(filename=options['logfile'], level=logging.INFO)
        try:
            logging.basicConfig(filename=options['logfile'])
            default_formatter = logging.Formatter("%(asctime)s:%(levelname)s:%(message)s")
            console_handler = logging.StreamHandler()
            console_handler.setFormatter(default_formatter)
            logger.addHandler(console_handler)
            logger.setLevel(logging.INFO)
            # logger.debug('init')
        except FileNotFoundError:
            sys.stderr.write('Error creating log file. Does the path exist?\n')
            sys.stderr.write('stopping here...\n')
            sys.exit(2)

    if args.varfile:
        options['varfile'] = args.varfile
        options['variables'] = []
        with open(options['varfile']) as varfile:
            for line in varfile:
                options['variables'].append(line.rstrip())

    if args.experimentfile:
        options['experimentfile'] = args.experimentfile
        options['experiments'] = []
        with open(options['experimentfile']) as expfile:
            for line in expfile:
                options['experiments'].append(line.rstrip())

    if args.allvariants:
        options['allvariants'] = True
    else:
        options['allvariants'] = False

    if args.all:
        options['all'] = True
        options['varfile'] = all_var_file
        options['experimentfile'] = all_experiment_file
        options['variables'] = []
        with open(options['varfile']) as varfile:
            for line in varfile:
                options['variables'].append(line.rstrip())
        options['experiments'] = []
        with open(options['experimentfile']) as expfile:
            for line in expfile:
                options['experiments'].append(line.rstrip())

    else:
        options['all'] = False

    if args.variables:
        options['variables'] = args.variables

    if args.models:
        # options['models'] = args.models
        options['models']= ','.join(args.models)

    if args.experiments:
        options['experiments'] = args.experiments

    if len(sys.argv) == 1:
        pass
        # print a varning with the defaults
        sys.stderr.write('WARNING: you have chosen to run {} without any command line option.\n'.format(__file__))
        sys.stderr.write('this will run with this script with the following defaults:\n')
        sys.stderr.write('- variables are taken from file {}\n'.format(options['varfile']))
        sys.stderr.write('- experiments are taken from file {}\n'.format(options['experimentfile']))
        sys.stderr.write('- directory for ESGF download scripts: {}\n'.format(options['scriptdir']))
        sys.stderr.write('- directory for data to download: {}\n'.format(options['downloaddir']))
        sys.stderr.write('Silence this message using the -s switch.\n')
        sys.stderr.write('This script will now sleep for 10 seconds.\n')
        import time
        time.sleep(10)


    runfilehandle = open(options['runfile'], 'w')
    logger.info('creating runfile {}'.format(options['runfile']))
    runfilehandle.close()

    variant_label = options['variant_label']
    for experiment in options['experiments']:
        for var in options['variables']:
            runfilehandle = open(options['runfile'], 'a')
            if options['allvariants']:
                script_url = ("https://esgf-data.dkrz.de/esg-search/wget?mip_era=CMIP6"
                              "&variable={0}"
                              "&experiment_id={1}"
                              "&realm={3}"
                              "&frequency={4}"
                              "&limit=9999"
                              "&download_structure=experiment_id,source_id,variant_label").format(
                    var,experiment,variant_label,realm,frequency)

                script_file = "{}_{}_allvariants.sh".format(var, experiment)
                script_log_file = "{}_{}_allvariants_{}.log".format(var, experiment, datestring)

            elif 'models' in options:
                script_url = ("https://esgf-data.dkrz.de/esg-search/wget?mip_era=CMIP6"
                              "&variable={0}"
                              "&experiment_id={1}"
                              "&variant_label={2}"
                              "&realm={3}"
                              "&frequency={4}"
                              "&source_id={5}"
                              "&limit=9999"
                              "&download_structure=experiment_id,source_id,variant_label").format(
                    var,experiment,variant_label,realm,frequency, options['models'])
                script_file="{}_{}_{}_{}.sh".format(options['models'], var, experiment, variant_label, )
                script_log_file = "{}_{}_{}_{}_{}.log".format(options['models'], var, experiment, variant_label, datestring)

            else:
                script_url = ("https://esgf-data.dkrz.de/esg-search/wget?mip_era=CMIP6"
                              "&variable={0}"
                              "&experiment_id={1}"
                              "&variant_label={2}"
                              "&realm={3}"
                              "&frequency={4}"
                              "&limit=9999"
                              "&download_structure=experiment_id,source_id,variant_label").format(
                    var,experiment,variant_label,realm,frequency)
                script_file="{}_{}_{}.sh".format(var, experiment, variant_label)
                script_log_file = "{}_{}_{}_{}.log".format( var, experiment, variant_label, datestring)

            script_file = os.path.join(options['scriptdir'], script_file)
            script_log_file = os.path.join(options['logdir'], script_log_file)
            # /nird/home/jang/ESGF_download/bin/exec_dl_script.sh \
            # /nird/home/u1/jang/ESGF_download/dl_scripts/rsdt_1pctCO2_r1i1p1f1,r1i1p1f2,r1i1p2f1,r1i2p1f1,r1i1p1f3,r1i1p3f1.sh \
            # /nird/projects/NS9252K/CMIP6/ >> \
            # /nird/home/jang/logs/rsdt_1pctCO2_r1i1p1f1,r1i1p1f2,r1i1p2f1,r1i2p1f1,r1i1p1f3,r1i1p3f1_20190923132701.log
            runline = '{0} {1} {2} >> {3}'.format(exec_script, script_file, options['downloaddir'], script_log_file)

            print(script_url)
            with urllib.request.urlopen(script_url) as web:
                script = web.read()
            logger.info('writing file {}'.format(script_file))
            write_handle = open(script_file, 'w')
            write_handle.write(script.decode('utf-8'))
            write_handle.close()
            # write script call to runfile
            runfilehandle.write(runline+'\n')

    runfilehandle.close()
    logger.info('To run the just created scripts, you might want to run one of the following commands:')
    logger.info('/usr/bin/parallel -v -j 8 -a {}'.format(options['runfile']))
    logger.info('screen -S CMIP8.dl /usr/bin/parallel -v -j 8 -a {}'.format(options['runfile']))


