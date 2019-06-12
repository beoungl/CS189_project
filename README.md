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
This process was required to filter out any data less than 1kb, and shorten contig name so it is easier to visualize in graph.s

###### 2.1) Filter conting less than 1kb
The data was processed using [python script](https://github.com/cvraut/CS189_project/blob/master/scripts/ren_condensed.py). 

###### 2.2) Contig name change

## 3) Phylogenetic tree

###### 3.1) BLAST

###### 3.2) ClustalW

###### 3.3) Etetoolkit treeviewer

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
