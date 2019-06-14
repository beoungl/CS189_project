
#!/bin/bash
#
#$ -N nucmer
#$ -t 1-4
#$ -q pub8i
## ckpt restart
### -m beas
### -M beoungl@uci.edu
### -o
### -e
#$ -pe openmp 8-32

source /data/users/beoungl/bin/.miniconda3testrc
cd /pub/${USER}/CS189_project/data
conda --version
conda activate project1

echo "Running nucmer"

REF=$(cat dat.ls | head -n 1)
SEED=$(cat dat.ls | head -n $((${SGE_TASK_ID}+1)) | tail -n 1)
##SEED=${SEED%%.*}


echo "$((${SGE_TASK+ID}+1))"
echo "$(REF)"
echo "${SEED}"

nucmer --maxmatch -c 100 -p ${SEED} ${REF} ${SEED}
mummerplot --png --fat --layout --filter ${SEED}.delta -R ${REF} -Q ${SEED} --prefix=${SEED}

conda deactivate


