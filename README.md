# CS189_project

Comparitive genomics project

# Background

The goal of this experiment was originally to compare genomes of 5 different yeast strains. However, we found that the similarity of genome can be affected by contiguity depending on the types of program used.

# Pipeline

The pipeline for this project is available on this github.


# Pipeline steps

## 1) Setting Up Anaconda Environment
All of the scripts are ran in HPC server using Anaconda environment. For installation of Anaconda environment, please follow [this instruction to set up Anaconda environment](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html). Then import [beoungl.yml](https://github.com/beoungl/CS189_project/blob/master/beoungl.yml) following [this instruction](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html). 
*Make sure the Python version is in 2.7.

## 2) Pre-processing
This process was required to filter out any data less than 1kb, and shorten contig name so it is easier to visualize in graph.

##### 2.1) Data download
Data for this project can be found in yeastgenome.org. [S288C](https://www.yeastgenome.org/strain/S000203483), [SK1](https://www.yeastgenome.org/strain/S000204513), W303(https://www.yeastgenome.org/strain/S000203491), [g833-1B](https://www.yeastgenome.org/strain/S000203504) and [Saccharomyces uvarum](https://sgd-prod-upload.s3.amazonaws.com/S000209332/CBS7001_UColDMed_2011_SRX055453.fsa.gz).
However, to reproduce exactly same data, you could also use this [genomes](https://github.com/beoungl/CS189_project/tree/master/data/originals) that we used for experiment, in case genome has been updated.

##### 2.2) Filter conting less than 1kb
The data was processed using [python script](https://github.com/cvraut/CS189_project/blob/master/scripts/ren_condensed.py). 

##### 2.3) Contig name change
The conting name was changed to smaller, more presentable name using [python script](https://github.com/cvraut/CS189_project/blob/master/scripts/ren_contigs.py).

## 3) Phylogenetic tree
In this step, phylogenetic tree was created using BLAST to find common gene amongst the yeast strains, ClustalW to obtain branch length between yeasts and Etetoolkit treeview to create phylogenetic tree.

##### 3.1) BLAST
Common gene was found using BLAST. Following links have been used to find common gene in [W303](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&PROG_DEF=blastn&BLAST_SPEC=Assembly&ASSEMBLY_NAME=GCA_000766265.2), [SK1](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&PROG_DEF=blastn&BLAST_SPEC=Assembly&ASSEMBLY_NAME=GCA_002250225.1), and [g833-1B](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&PROG_DEF=blastn&BLAST_SPEC=Assembly&ASSEMBLY_NAME=GCA_000766265.2) using [yll065w](https://www.yeastgenome.org/locus/S000003988) yeastgenome.org. For Saccharomyces uvarum, we went into [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) and entered Saccharomyces uvarum under organism name and excluded Saccharomyces ceresiviae. After finding alignment through BLAST, copy and paste the gene onto one file, and if there are gaps between sequences, manually enter N's in between. 

If you have trouble doing this step, download this [multiple fasta sequence file](https://github.com/cvraut/CS189_project/blob/master/yll065w.fasta).

##### 3.2) ClustalW

For this step, enter the command :

```
clustalw
```
, then the interactive mode for ClustalW will appear. Enter 4 for phylogenetic tree, then enter 1 to input alignment. Type the name of your sequence file, then enter 4 to draw tree. 

##### 3.3) Etetoolkit treeviewer

Follow this [link](http://etetoolkit.org/treeview/). Clear both newick format and fasta file, then paste your result under newick format. Click view tree, and phylogenetic tree should be generated.

![Alt text](https://github.com/beoungl/CS189_project/blob/master/Phylo_tree.PNG)

## 4) Sastusma2

##### 4.1) Satsuma



##### 4.2) BlockDisplaySatusma



## 5) MUMMER

This process requires [nucmer.ls](), which contains names of fasta files that are used for comparison. Follow [qsub_nucmer.sh](https://github.com/cvraut/CS189_project/blob/master/qsub_nucmer.sh).

##### 5.1) NUCMER

This part of script takes each fasta file, and align each fasta file into reference genome S288C. REF represents refernce genome and SEED represents query sequence.
```
nucmer --maxmatch -c 100 -p ${SEED} ${REF} ${SEED}
```
##### 5.2) Mummerplot

This part of script takes output delta file and graph it using Mummerplot with png format.
```
mummerplot --png --fat --layout --filter ${SEED}.delta -R ${REF} -Q ${SEED} --prefix=${SEED}
```
## 6) Assemblystats

N50 score was analyzed using Assemblystats.

# Conclusion
Refer to the [final paper](https://docs.google.com/document/d/1KNQ6TGLGn5cANC1CSuzZIuPjTDEG9VN8L9dKRxzwwns/edit) for conclusion and analysis.

# Directory tree

