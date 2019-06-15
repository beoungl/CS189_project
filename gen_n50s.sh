source ~/.minicondatest3rc
conda activate project1
cd /pub/beoungl/CS189_project
mkdir assembly_stats
assembly-stats data/SK1_reference.fasta > assembly_stats/SK1_reference.stats
assembly-stats data/S288C_reference.fasta > assembly_stats/S288C_reference.stats
assembly-stats data/suvarum_cbs7001.fasta > assembly_stats/suvarum_cbs7001.stats
assembly-stats data/g833-1B_reference.fasta > assembly_stats/g833-1B_reference.stats
assembly-stats data/W303_reference.fasta > assembly_stats/W303_reference.stats
conda deactivate
