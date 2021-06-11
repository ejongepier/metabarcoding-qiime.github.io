#!/usr/bin/env bash

reponame="metabarcoding-qiime.github.io"

################
## REBUILD DOCS ##
################

make clean
make github


###############
## Update git ##
###############

git add .
git commit -m "Updated index"
git push -u origin main

