#!/bin/bash

# small script to push the $HOME/.esg folder to nird
# necessary because nird does not have java 1.9+ reguired
# by the ESGF doenload script to update the certificate 
# needed for authentication @ the ESGF server

rsync -av ~/.esg login.nird.sigma2.no:
