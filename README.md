# CS189_project

Comparitive genomics project

# Background

The goal of this experiment was originally to compare genomes of 5 different yeast strains. However, we found that the similarity of genome can be affected by contiguity depending on the types of program used.

# Satsuma pipeline
'''
#!/bin/bash
#$ -N satsuma_yeast_script
#$ -t 1-4        ## task ids
#$ -q pub8i      ## queue to send task to
\## -ckpt restart ## include to make sure tasks are suspended & restart. Only for use in suspendable queues.
\### -m beas
\### -M craut@uci.edu
\### -o
\### -e
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
'''
