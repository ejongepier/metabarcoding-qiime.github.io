.. qiime2-workshop documentation master file, created by
   sphinx-quickstart on Tue Nov  3 13:39:59 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to the QIIME2 workshop!
===========================================

General Introduction
------------------------------------------

This workshop will introduce you to analysis of DNA metabarcoding sequencing data using the command line tool QIIME2
(`Bolyen et al. 2019 <https://pubmed.ncbi.nlm.nih.gov/31341288/>`_). 
QIIME 2™ is a next-generation microbiome bioinformatics platform that is extensible, free, open source, and community developed.  
The goal of this workshop is to produce an abundance table and a 
`taxonomic classification <https://view.qiime2.org/visualization/?type=html&src=https%3A%2F%2Fdocs.qiime2.org%2F2020.6%2Fdata%2Ftutorials%2Fmoving-pictures%2Ftaxa-bar-plots.qzv>`_ 
from raw amplicon sequences.
These can be used for downstream analyses like community profiling or diversity analyses, although this is not part of the workshop.

The emphasis lies on getting hands-on experience with data analyses.
No prior experience in bioinformatics is needed, but some basic knowledge of the UNIX operating system will come in handy. 
Check out `these tutorials <http://www.ee.surrey.ac.uk/Teaching/Unix/>`_ in preparation for the workshop, in particular Tutorial 
`One <http://www.ee.surrey.ac.uk/Teaching/Unix/unix1.html>`_, 
`Two <http://www.ee.surrey.ac.uk/Teaching/Unix/unix2.html>`_ and 
`Three <http://www.ee.surrey.ac.uk/Teaching/Unix/unix3.html>`_.


Time and place
------------------------------------------

The workshop will be held through Zoom/discourse.

.. list-table:: Schedule QIIME2 workshop June 2021
   :widths: 25 25 50
   :header-rows: 1

   * - Day
     - Time
     - Topic
   * - Mon June 28th
     - 9:00 - 12:00
     - Quality control and ASV table construction.
   * - 
     - 13:30 - 17:00
     - Optional: Work on your own data.
   * -
     -
     - Optional: Running analyses on crunchomics. 
   * - Tue June 29th
     - 9:00 - 12:00
     - Taxonomic classification using the SILVA 16S database.
     - 13:30 - 17:00
     - Optional: Work on your own data.
   * -
     -
     - Optional: Running analyses on crunchomics.



Data package
---------------------------------------------

You can download the data package used in this workshop from Zenodo.
This data package contains the following:

* Demultiplexed fastq.gz files for each of your samples with amplicon sequences and quality scores
* The SILVA 16S taxonomic database version 138
* The taxonomic classifier, specifically pre-trained to use on this data set
* The bash scripts used to run the entire workflow
* The WALKTHROUGH with instuctions on how to run thse analyses on the crunchomics cluster
* All intermediate results, such that you can choose to skip very time consuming steps.

.. tip::

   When you follow the steps in this tutorial, you will overwrite the pre-computed intermediate files present in your data package.
   Make sure to keep a copy of the original data package, such that you can always restore these pre-computed files when needed.


Prerequisites
---------------------------------------------

The only thing you need to do yourself is install QIIME2 version 2021.2 on your computer.
For installation instructions see https://docs.qiime2.org/2021.2/install/native/.
If you need help with the installation, please let me know in time and we can look at it together.

It is not necessary for this workshop to have a very powerful computer.
You can run most of the analyses on a laptop, and if that does not work,
you can skip that step and continue with the intermediate files in your data package.


Crunchomics
---------------------------------------------

Crunchomics is the HPC cluster of SILS/IBED (`documentation <https://crunchomics-documentation.readthedocs.io/en/latest/>`_).
It is only accessible for participants with an UvA netID that have preregistered for an account. 
To get an account, pls send an email including your UvA netID to the crunchomics system administrator, Wim de Leeuw (w.c.deleeuw@uva.nl).

Once you have your crunchomics account you can login to crunchomics and install miniconda, following `these instructions <https://crunchomics-documentation.readthedocs.io/en/latest/miniconda.html`>_.

During the optional crunchomics module of the workshop you make use of pre-installed programs and databases available only to amplicomics group members.
To become a member of the amplicomics group, send an email including your UvA netID to e.jongepier@uva.nl. 


.. warning::

   Membership of the amplicomics group goes through the faculty ICTS department so may take several days to arrange.
   Pls contact e.jongepier@uva.nl well in advance if you like to participate in the optional crunchomics module of the workshop.


.. toctree::
   :maxdepth: 3
   :caption: Contents:

   denoise
   taxonomy
