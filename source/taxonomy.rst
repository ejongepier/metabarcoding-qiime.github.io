Taxonomic classification
####################################


In this second part of the workshop you will continue with the taxonomic classification of your representative sequences from the dada2-denoising performed yesterday.

QIIME 2 provides several methods to predict the most likely taxonomic affiliation of your features, including both alignment-based consensus methods and Naive Bayes (and other machine-learning) methods. 

Here, we will use a Naive Bayes classifier, which must be trained on taxonomically defined reference sequences covering the target region of interest.
This tutorial addresses the following questions: 

#. How to import the SILVA 16S rRNA taxonomic database as a reference in QIIME2?

#. How to extract the fragments from the SILVA reference sequences corresponding to the primers you used?

#. How to train a custom classifier on these particular fragments of the 16S rRNA gene?

#. How to use the trained classifier to get a taxonomic classification of your representative sequences?

#. How to vizualise your taxonomic classification as interactive barplots?
 

.. warning::
  
   Training a classifier takes up quite a bit of RAM and time.
   Therefore, I have pre-computed the classifier for you.
   I recommend you just you through the next steps in the analyses without actually running them. 

See the QIIME2 `Training feature classifiers with q2-feature-classifier <https://docs.qiime2.org/2020.8/tutorials/feature-classifier/>`_ tutorial further information. 

Importing the database
==========================

Two elements are required for training the classifier: the reference sequences and the corresponding taxonomic classifications.
In the db directory of your data package, you will find these two files for the 16S rRNA SILVA data base release version 132, at 99% sequence similarity cutoff.
You can import these files into QIIME2 as artifacts similar to how you imported your own data yesterday:

.. code-block:: bash

   qiime tools import \
     --type "FeatureData[Sequence]" \
     --input-path db/SILVA_132_99_16S_ref-seqs.fna \
     --output-path db/SILVA_132_99_16S_ref-seqs.qza
   
.. code-block:: bash

   qiime tools import \
     --type "FeatureData[Taxonomy]" \
     --input-format HeaderlessTSVTaxonomyFormat \
     --input-path db/SILVA_132_99_16S_ref-taxonomy.txt \
     --output-path db/SILVA_132_99_16S_ref-taxonomy.qza

Lets have a look at the first entry in db/SILVA_132_99_16S_ref-seqs.fna:

.. code-block:: bash

   >AB302407.1.2962
   TCCGGTTGATCCTGCCGGACCCGACCGCTATCGGGGTAGGGCTAAGCCATGCGAGTCGCGCGCCCGGGGGCGCCCGGGAGCGGCGCACGGCTCAGTAACACGTGCCCAACCTACCCTCGGGAGGGGGACACCCCCGGGAAACTGGGGCCAATCCCCCATAGGGGAAGGGCGCTGGAAGGCCCCTTCCCCAAAAGGGGTTGCGGCCGATCCGCCGCAGCCCGCCCGAGGATGGGGGCACGGCCCATCAGGTAGTTGGCGGGTTAAAGGCCCGCCAAGCCGAAGACGGGTAGGGGCGGTGAGAGCCGCGAGCCCCGAGATCGGCACTGAGACAAGGGCCGAGGCCCTACGGGGTGCAGCAGGCGCGAATACTCCGCAAATGGGGAGAGGCCGGCCCCTCAGTTTTCTCATGAAGGACGCCCATCGGTTTGATTTAAGCGAAGTGGTATATTCGAAATTTGACAAAAAGCGTGGTATACGGATTCCGGAGGAGCCCTCGGAGCTCCTAGCAGAGGAGACGGCGATTCATCTAGGAGATGGGTATCTATTCTACGACGAAAAAGATCGGAGCTACAGGTTCGGCATAGGCCTCAATCCGAAGACGGAAATGAGCTACGCATACGCGGTGGCGGAGCTCATAGGACAGCTCTACGGCTACATGCCGCCGGTGAGAGGAGCGCGTATTGAAATAATGTCGCTAGCCATAGGGACGTTCAAGCATAAAGTCCTCGCCTTACCTATTGGCACCAGAACCGGAGGCGAGGATCTTCCGAGGATCGAGTGGGTTTTAACAGATGAGAGGTTTATTACGGCGTTTGTACGCGGGCTTGTCGATACGGAGGGCTCAGTAAAAAAGATCTCAAGGACGATAGGTGTCGTCGTAAAACAGAGGAATAGGAAAATAATCGAGTTCTATGCCCAATGCCTCGCGGCCTTGGGATTCCGGTCAAGGATATATGTATGGAACGAGAGAAACAAACCCATATATGTCTCGGCGTTGTTGGGCAAAGAAGTCGTGGAACAATTCATACAACTTATCAAGCCGAGAAACCCCTCAAAATATCCTCCTTTTTAGCTCCCACCCCTCGCCGGCCCTCCCCAGCGGAATGCGGGCAACCGCGACGGGGCTACCCCGAGTGCCGGGCGAAGAGCCCGGCTTTTGCCCGGTCTAAAACGCCGGGCGAATAAGCGGGGGGCAAGTCTGGTGTCAGCCGCCGCGGTAATACCAGCCCCGCGAGTGGTCGGGGTGTTTACTGGGCTTAAAGCGCCCGTAGCCGGCCCGGCAAGTCGCTCCTGAAATCCCCGGGCCCAACCCGGGGGCGGGGGGCGATACTGCCGGGCTAGGGGGCGGGAGAGGCCGCCGGTACTCCGGGGGTAGGGGCGAAATCCGTTAATCCCCGGAGGACCACCAGTGGCGAAAGCGGGCGGCCAGAACGCGCCCGACGGTGAGGGGCGAAAGCCGGGGGAGCAAACCGGGCCAAGGCCGGCAAAAATTTAAAAAAGCCCCAAGGTCTCGATATGGGGTGCGATCGTTATGAGGTGCTAAGAGTTGTGCCTTTCGTTCTATCGGACGGGGGAGTATACAATAACAGGGAGATCTATTTCACATCAACAGACGCCGCCTTGGTTAGCCACTTCAGAACTGTTGCAACGGTTGCGTTTGGCTACGGAGGCTACGTTGTGAAGCGGAGCAACGGGGCATATGTGGTGAAGATAAAGGGCTATGACTACTTCAAATGTCTAGCCGAGGTTATGCCAGACATATTATATAAGAACGATAAAGGCCGCGCCATTAGGTTGCCGGACGAGCTATACAGCGACAAGGATCTAGCCAAGTGGTTCATAAAGGTATATGTCTCATGCGACGGCGGTGTATCGGTCATGTTGGGTAGAAGAGGCAATATCACGTTTTACGTCAGAAGAGTATCCATAACATCCAAAAACCCATATCTACGGCGCCAGATCGGGGATTTGCTCAAAGCCTTAAGCTTTGCGCCGCGAGATGATGGCGATAAACACATCTACCTATCACGAAGAGAGGACATAGTTAGATACGCAGAAGAGATAAGATTTCTAGAGCAGGTAAAGGTAACGAAAAATTCCAAAAGATTCCGCGGAATGGAGAAAAACCAGCTCCTAGATTTAGTCGTGCGATCCTACGGAAATCCCCACCTGTTAGACCCCTTTTTTCCACCATCATCTTTCTCCCACAACGCCGGCCTAGCCCGGGCTCAAAGGGGATTAGATACCCCTGTAGTCCCGGCCGTAAACGATGCGGGCTAGCTGTCGGTCGGGCTTAGGGCCCGGCCGGTGGCGAAGGGAAACCGTTAAGCCCGCCGCCTGGGGAGTACGGCCGCAAGGCTGAAACTTAAAGGAATTGGCGGGGGGGCACCACAAGGGGTGAAGCTTGCGGCTTAATTGGAGTCAACGCCGGAAACCTCACCCGGGGCGACAGCAGGATGAAGGCCAGGCTAACGACCTTGCCGGACGAGCTGAGAGGAGGTGCATGGCCGTCGTCAGCTCGTGCCGTGAGGTGTCCGGTTAAGTCCGGCAACGAGCGAGACCCCCGCCCCTAGTTGCTACCCCGTCCTACGGGACGGGGGGCACACTAGGGGGACTGCCGGCGTAAGCCGGAGGAAGGAGGGGGCCACGGCAGGTCAGTATGCCCCGAAACCCCGGGGCTGCACGCGAGCTGCAATGGCGGGGACAGCGGGAACCGACCCCGAAAGGGGGAGGCAATCCCGTAAACCCCGCCCCAGTAGGGATCGAGGGCTGCAACTCGCCCTCGTGAACGTGGAATCCCTAGTAACCGCGTGTCACCAACGCGCGGTGAATACGTCCCTGCCCCTTGCACACACCGCCCGTCGCACCACCCGAGGGAGCTCCCTGCGAGGCCCCTTGCCGAAAGGTGGGGGGACGAGCAGGGGGCTCCCAAGGGGGGTGAAGTCGTAACAAGGTAACCGT

and its 7-level taxonomic annotation (domain, phylum, class, order, family, genus, species) from db/SILVA_132_99_16S_ref-taxonomy.txt:

.. code-block:: bash

   AB302407.1.2962	D_0__Archaea;D_1__Crenarchaeota;D_2__Thermoprotei;D_3__Thermoproteales;D_4__Thermoproteaceae;D_5__Pyrobaculum;D_6__Pyrobaculum sp. M0H


.. admonition:: Question 11

   How long was the fragment again that you sequenced? How does that compare the the sequence length in the SILVA database?
   What are two major disadvantages of using full length 16S rRNA gene in your taxonomic classification?


Extract reference reads
===========================

The 16S rRNA gene is characterized by both hyper variable and very conserved regions.
Taxonomic classification accuracy of 16S rRNA gene sequences improves when a Naive Bayes classifier is trained 
on only the region of the target sequences that was sequenced 
(`Werner et al. 2012 <https://pubmed.ncbi.nlm.nih.gov/21716311/>`_). 

From the trimming step yesterday, you know which primer sequences apply to your data.
You can now use these same sequences to extract the corresponding region of the 16S rRNA sequences from the SILVA database, like so:

Note, this takes a while even using 16 cpus like I did.

.. code-block:: bash

   qiime feature-classifier extract-reads \
     --i-sequences db/SILVA_132_99_16S_ref-seqs.qza \
     --p-f-primer GTGYCAGCMGCCGCGGTAA \
     --p-r-primer CCGYCAATTYMTTTRAGTTT \
     --o-reads db/SILVA_132_99_16S_ref-frags.qza \
     --p-n-jobs 16

Lets have a look at the result:

.. code-block:: bash

   qiime feature-table tabulate-seqs \
     --i-data db/SILVA_132_99_16S_ref-frags.qza \
     --o-visualization db/SILVA_132_99_16S_ref-frags.qzv

   qiime tools view db/SILVA_132_99_16S_ref-frags.qzv

.. admonition:: Question 12

   How does the sequence length distribution of your reference fragments compare to that of your representative sequences?


Train the classifier
=====================

In this step you use the reference fragments you just created to train your classifier specifically on your region of interest.

.. warning::

   You should only run this step if you have >32GB of RAM available!

.. code-block:: bash

   qiime feature-classifier fit-classifier-naive-bayes \
     --i-reference-reads db/SILVA_132_99_16S_ref-frags.qza \
     --i-reference-taxonomy db/SILVA_132_99_16S_ref-taxonomy.qza \
     --o-classifier db/SILVA_132_99_16S_ref-classifier.qza


Please note that this classifier is not very specific with respect to which environment your samples come from,
because it assumes that all species in the reference database are equally likely to be observed in your sample 
(i.e., that sea-floor microbes are just as likely to be found in a stool sample as microbes usually associated with stool).

It is actually possible to incorporate environment-specific taxonomic abundance information to improve species inference. 
This bespoke method has been shown to improve classification accuracy when compared to traditional Naive Bayes classifiers 
(`Kaehler et al. 2019 <https://www.nature.com/articles/s41467-019-12669-6>`_).

To train a classifier using this bespoke method, you need to provide an additional file with taxonomic weigths
(see `--i-class-weight` in the `qiime feature-classifier fit-classifier-naive-bayes` help function)
Pre-assembled taxonomic weights can be found in the readytowear collection at https://github.com/BenKaehler/readytowear.
I cannot judge how well they fit your particular environment, so be very, very careful in using them unless you know what you are doing. 


Taxonomic classification
==========================

So now you have a trained classifier and a set of representative sequences from your dada2-denoise analyses.
Lets run it and find out which microbes were present in your samples.

.. warning::

   I ran this step on a computational cluster because it requires ~50 GB of RAM.
   Don't run this yourself unless you have lots of RAM on your system.

 
.. code-block:: bash

   mkdir -p taxonomy
   qiime feature-classifier classify-sklearn \
     --i-classifier db/SILVA_132_99_16S_ref-classifier.qza \
     --p-n-jobs 16 \
     --i-reads dada2/dada2-reprseqs.qza \
     --o-classification taxonomy/dada2-SILVA_132_99_16S-taxonomy.qza

You can view the taxonomic annotation of each of your representative sequences like so:

.. code-block:: bash

   qiime metadata tabulate \
    --m-input-file taxonomy/dada2-SILVA_132_99_16S-taxonomy.qza \
    --o-visualization taxonomy/dada2-SILVA_132_99_16S-taxonomy.qzv

   qiime2 tools view taxonomy/dada2-SILVA_132_99_16S-taxonomy.qzv


Note that this also reports a confidence score ranging between 0.7 and 1.
The lower limit of 0.7 is the default value (see also the `qiime feature-classifier classify-sklearn` help function).
You can opt for a lower value to increase the number of features with a classification, but beware that that will also increase the number of false positives!


Taxonomic barplot
=====================

In this final step you will create an interactive barplot, showing the relative abundances at different taxonomic levels for each of your samples.
Before running the command, you will need to prepair a metadata file.
This metadata file should contain information on your samples. For instance, at which depth was the sample taken, 
from which location does it come, was it subjected to drought treatment or to control etc. etc.
This information is of course very specific to your study design but at the very least it should look like this (see also data/META.tsv):

.. code-block:: bash

   #SampleID
   #q2:types
   FLD0001
   FLD0002
   ...

but you can add any variables, like so:

.. code-block:: bash

   #SampleID    BarcodeSequence Location        depth	location	treatment	grainsize       flowrate        age
   #q2:types    categorical     categorical     categorical	catechorical	categorical	numeric	numeric	numeric
   <your data>

See the `Metadata in QIIME 2 <https://docs.qiime2.org/2020.8/tutorials/metadata/>`_ tutorial for further information.

I created a minimal example for your data here data/META.tsv
Just complement it with the specific variables of your study or continue with this minimal example.
Then create and view the barplot vizualisation, like so:

.. code-block:: bash

   qiime taxa barplot \
     --i-table dada2/dada2-table.qza \
     --i-taxonomy taxonomy/dada2-SILVA_132_99_16S-taxonomy.qza \
     --m-metadata-file data/META.tsv \
     --o-visualization taxonomy/dada2-SILVA_132_99_16S-taxplot.qzv

   qiime tools view taxonomy/dada2-SILVA_132_99_16S-taxplot.qzv


.. admonition:: Question 13

   Which family is the most abundant in your samples, and which class?
   Can you see clear differences in relative abundances between your treatment/sample location/depth/...?
   ... <here is where you get to add your own questions>


Now that you have come to the end of this workshop, lets have a final look at the
metadata for your taxonomy analyses. Just go to https://view.qiime2.org/
and load your artifact taxonomy/dada2-SILVA_132_99_16S-taxonomy.qza.

  





