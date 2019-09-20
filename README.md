# ESGF_download
shell scripts for downloading CMIP6 climate model data from [ESGF](https://esgf-data.dkrz.de/search/cmip6-dkrz/) used at the Norwegian Meteorological Institute in conjunction with the 
KeyClim project.

## Description
These tools query the [ESGF API](https://www.earthsystemcog.org/projects/cog/esgf_search_restful_api) for bash scripts to download 
CMIP6 climate model data. This script generation is a function of the ESGF API called wget script. This query is done 
specific enough (one script for each
experiment, variable combination) so that these scripts can be run in parallel to achieve a decent over all download speed. On 
an Norwegian infrastructure we get ~20Mb/sec per file, that does not go down on the file level if the scripts are run in parallel.

The output of the main script is a text file with commands to run that can be used to run e.g. on a cluster or using parallel on a 
normal multiprocessor machine. These commands 
include logging the output of the download scripts into a text file (one per download script; only stdout at this point)

At this time the scripts are rather simple, are not very user friendly and need you to think before you type. They are also rather 
specific to be used for the KeyClim project at the Norwegian national infrastructure called NIRD. Nevertheless the scripts should 
be simple enough for an experienced shell user to useful somewhere else as well.

Note that these scripts will download several TB of data per day.

## Prerquests
- Linux box
- bash
- wget
- enough space to store your data
