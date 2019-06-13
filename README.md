# CS189_project

Comparitive genomics project

# Background

The goal of this experiment was originally to compare genomes of 5 different yeast strains. However, we found that the similarity of genome can be affected by contiguity depending on the types of program used.

# Pipeline

# Pipeline steps

## 1) Setting Up Anaconda Environment
All of the scripts are ran in HPC server using Anaconda environment. For installation of Anaconda environment, please follow [this instruction to set up Anaconda environment](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html). Then import [beoungl.yml](https://github.com/cvraut/CS189_project/blob/master/beoungl.yml) following [this instruction](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html). 
*Make sure the Python version is in 2.7.

## 2) Pre-processing
This process was required to filter out any data less than 1kb, and shorten contig name so it is easier to visualize in graph.

##### 2.1) Data download
Download data using follow [script].

##### 2.2) Filter conting less than 1kb
The data was processed using [python script](https://github.com/cvraut/CS189_project/blob/master/scripts/ren_condensed.py). 

##### 2.3) Contig name change
The conting name was changed to smaller, more presentable name using [python script](https://github.com/cvraut/CS189_project/blob/master/scripts/ren_contigs.py).

## 3) Phylogenetic tree
In this step, phylogenetic tree was created using BLAST to find common gene amongst the yeast strains, ClustalW to obtain branch length between yeasts and Etetoolkit treeview to create phylogenetic tree.

##### 3.1) BLAST(optional)
Common gene was found using BLAST. Following links have been used to find common gene in [W303](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&PROG_DEF=blastn&BLAST_SPEC=Assembly&ASSEMBLY_NAME=GCA_000766265.2), [SK1](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&PROG_DEF=blastn&BLAST_SPEC=Assembly&ASSEMBLY_NAME=GCA_002250225.1), and [g833-1B](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&PROG_DEF=blastn&BLAST_SPEC=Assembly&ASSEMBLY_NAME=GCA_000766265.2) using [yll065w](https://www.yeastgenome.org/locus/S000003988) yeastgenome.org. For Saccharomyces uvarum, we went into [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) and entered Saccharomyces uvarum under organism name and excluded Saccharomyces ceresiviae. After finding alignment through BLAST, copy and paste the gene onto one file, and if there are gaps between sequences, manually enter N's in between. 

If you have trouble doing this step, download this [multiple fasta sequence file](https://github.com/cvraut/CS189_project/blob/master/yll065w.fasta).

##### 3.2) ClustalW

For this step, enter the command :

```
ClustalW
```
, then the interactive mode for ClustalW will appear. 

##### 3.3) Etetoolkit treeviewer

Follow this [link](http://etetoolkit.org/treeview/). Clear both newick format and fasta file, then paste your result under newick format. Click view tree, and phylogenetic tree should be generated.

## 4) Sastusma2

## 5) MUMMER

###### 5.1) NUCMER

###### 5.2) Mummerplot

## 6) Conclusion
Refer to the [final paper](https://docs.google.com/document/d/1KNQ6TGLGn5cANC1CSuzZIuPjTDEG9VN8L9dKRxzwwns/edit) for conclusion and analysis.

# Directory tree

```
#!/bin/bash
#$ -N satsuma_yeast_script
#$ -t 1-4        ## task ids
#$ -q pub8i      ## queue to send task to
## -ckpt restart ## include to make sure tasks are suspended & restart. Only for use in suspendable queues.
### -m beas
### -M craut@uci.edu
### -o
### -e
#$ -pe openmp 2  ## for multithreaded applications. pe openmp INT, integer is # of cores

source ~/.miniconda3rc
cd /pub/${USER}/CS189_project
conda --version
conda activate cg_yeast
cd outputs
rm -rf *.*
cd ..
echo "Running Satsuma"
export SATSUMA2_PATH=~/bin/miniconda3/envs/cg_yeast/bin


cd data
REF=$(cat dat.ls | head -n 1)
SEED=$(cat dat.ls | head -n $((${SGE_TASK_ID}+1)) | tail -n 1)
cd ..
SEED=${SEED%%.*}
rm -rf ./outputs/${SEED}
mkdir -p ./outputs/${SEED}

echo "$((${SGE_TASK_ID}+1))"
echo "${REF}"
echo "${SEED}"

SatsumaSynteny2 -t data/${REF} -q data/${SEED}.fasta -o outputs/${SEED}

conda deactivate
```
