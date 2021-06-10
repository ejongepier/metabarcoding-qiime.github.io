#!/usr/bin/env bash

reponame="metabarcoding-qiime.github.io"

## copy source dir and Makefile and make.bad here
## create docs dir
mkdir docs

################
## BUILD DOCS ##
################

# Python Sphinx, configured with source/conf.py
# See https://www.sphinx-doc.org/
make clean
make github ## custom make rule see Makefile


######################
## Setup other docs ##
######################

# create new repo on github and  make it public

# Add README
cat > README.md <<EOF
# README for the GitHub Pages Branch
This branch is simply a cache for the website served from https://ejongepier.github.io/metabarcoding-qiime.github.io,
and is  not intended to be viewed on github.com.
For more information on how this site is built using Sphinx, Read the Docs, and GitHub Actions/Pages, see:
 * https://www.docslikecode.com/articles/github-pages-python-sphinx/
 * https://tech.michaelaltfield.net/2020/07/18/sphinx-rtd-github-pages-1
EOF

# Adds .nojekyll file to the root to signal to GitHub that
# directories that start with an underscore (_) can remain
touch docs/.nojekyll
touch .nojekyll

# add .gitignore
cat > .gitignore <<EOF
*
!README.md
!buildsite.sh
!.nojekyll
!/docs/
!/docs/**
!/source/
!/source/**
EOF

###############
## Setup git ##
###############

git init
git add .
git commit -m "Initialize"
git branch -M main
git remote add origin https://github.com/ejongepier/metabarcoding-qiime.github.io.git
git push -u origin main

# go to github repo settings and select under Github Pages source: main /docs

