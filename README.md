# CS189_project

Comparitive genomics project

# Background

The goal of this experiment was originally to compare genomes of 5 different yeast strains. S288C was used as a refernce genome, as it is the yeast genome that has been stuided most, and was most contiguous. W303 was derived from the S288C. SK1 diverges more from S288C than W303, and g833-1B is haploid dervative of SK1. Saccharomyces uvarum is different species of yeast, as other 4 strains are Saccharomyces ceresiviae. In this experiment, we found that the similarity of genome can be affected by contiguity depending on the types of program used.

# Pipeline

The pipeline for this project is available on this github. The pipeline followed the process that looks like this chart below:

![Alt text](https://github.com/beoungl/CS189_project/blob/master/pipeline.png)

Phylogenetic tree processing requires NCBI BLAST, ClustalW, and Etetoolkit online tree viewer. Satsuma2 and Chromosomepaint requires two different script, while MUMMER is completed using one script. Assemblystats require only one script as well. Result can be seen in the [final paper](https://docs.google.com/document/d/1KNQ6TGLGn5cANC1CSuzZIuPjTDEG9VN8L9dKRxzwwns/edit).


# Pipeline steps

## 1) Setting Up Anaconda Environment
All of the scripts are ran in HPC server using Anaconda environment. For installation of Anaconda environment, please follow [this instruction to set up Anaconda environment](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html). Then import [comparative_genomics.yml](https://github.com/beoungl/CS189_project/blob/master/comparative_genome.yml) following [this instruction](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html). 
*Make sure the Python version is in 2.7.

## 2) Downloading Genome and Pre-processing
This process was required to filter out any data less than 1kb, and shorten contig name so it is easier to visualize in graph.

##### 2.1) Data download
Data for this project can be found in yeastgenome.org. [S288C](https://www.yeastgenome.org/strain/S000203483), [SK1](https://www.yeastgenome.org/strain/S000204513), [W303](https://www.yeastgenome.org/strain/S000203491), [g833-1B](https://www.yeastgenome.org/strain/S000203504) and [Saccharomyces uvarum](https://sgd-prod-upload.s3.amazonaws.com/S000209332/CBS7001_UColDMed_2011_SRX055453.fsa.gz).
However, to reproduce exactly same data, you could also use this [genomes](https://github.com/beoungl/CS189_project/tree/master/data/originals) that we used for experiment, in case genome has been updated.

##### 2.2) Filter conting less than 1kb
The data was processed using [python script](https://github.com/beoungl/CS189_project/blob/master/scripts/ren_condensed.py). This python script remove any contig less than 1kb and change their name to more conscise, presentable name so it is easier to display them on graph/images.

## 3) Phylogenetic tree
In this step, phylogenetic tree was created using BLAST to find common gene amongst the yeast strains, ClustalW to obtain branch length between yeasts and Etetoolkit treeview to create phylogenetic tree.

##### 3.1) BLAST
Common gene was found using BLAST. Following links have been used to find common gene in [W303](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&PROG_DEF=blastn&BLAST_SPEC=Assembly&ASSEMBLY_NAME=GCA_000766265.2), [SK1](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&PROG_DEF=blastn&BLAST_SPEC=Assembly&ASSEMBLY_NAME=GCA_002250225.1), and [g833-1B](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&PROG_DEF=blastn&BLAST_SPEC=Assembly&ASSEMBLY_NAME=GCA_000766265.2) using [yll065w](https://www.yeastgenome.org/locus/S000003988) yeastgenome.org. For Saccharomyces uvarum, we went into [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) and entered Saccharomyces uvarum under organism name, excluded Saccharomyces ceresiviae, and used BLASTN as an alignment option. After finding alignment through BLAST, copy and paste the gene onto one file, and if there are gaps between sequences, manually enter N's in between. 

If you have trouble doing this step, download this [multiple fasta sequence file](https://github.com/beoungl/CS189_project/blob/master/yll065w.fasta).

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

There were two scripts for this part of experiment, [gen_fig.sh](https://github.com/beoungl/CS189_project/blob/master/gen_figs.sh) and [qsub_satsuma.sh](https://github.com/beoungl/CS189_project/blob/master/qsub_satsuma.sh). Before running the script, make sure to make outputs directory using:

```
mkdir outputs
````

##### 4.1) Satsuma

Follow [qsub_satsuma.sh](https://github.com/beoungl/CS189_project/blob/master/qsub_satsuma.sh) for detail.

In this script, Satusma2 takes S288C as reference genome, and align other genome individually as a query genome. ****WARNING: MAKE SURE TO HAVE OUTPUTS DIRECTORY BEFORE RUNNING THE SCRIPT, AS THIS SCRIPT CAN POTENTIALLY DELETE ALL FILES IN DIRECTORY IF OUTPUTS DIRECTORY IS NOT PRESENT.

```
SatsumaSynteny2 -t data/${REF} -q data/${SEED}.fasta -o outputs/${SEED}
```
Following code creates output as out format, and this out format is then used in BlockDisplaySatusma to visualized.

##### 4.2) BlockDisplaySatusma

Follow [gen_figs.sh](https://github.com/beoungl/CS189_project/blob/master/gen_figs.sh)

In this script, BlockDisplaySatsuma takes out file from Satsuma2, and produces image below. The output is in postscript format.

```
BlockDisplaySatsuma -i outputs/g833-1B_reference/satsuma_summary.chained.out -t data/S288C_reference.fasta -q data/g833-1B_reference.fasta > S288C_v_g833.out
ChromosomePaint -d 10 -s 400 -i S288C_v_g833.out -o S288C_v_g833.ps
```

![Alt text](https://github.com/beoungl/CS189_project/blob/master/w303_satsuma.png)

```
MicroSyntenyPlot -i outputs/g833-1B_reference/xcorr_aligns.final.out -s 4000 -o g833-1B.ps
```

This part of script is optional and will generate MicrosyntennyPlot that looks like this.

![Alt text](https://github.com/beoungl/CS189_project/blob/master/microsyntenny/SK1-1.png)

## 5) MUMMER

This process requires [nucmer.ls](), which contains names of fasta files that are used for comparison. Follow [qsub_nucmer.sh](https://github.com/beoungl/CS189_project/blob/master/qsub_nucmer.sh).

##### 5.1) NUCMER

This part of script takes each fasta file, and align each fasta file into reference genome S288C. REF represents refernce genome and SEED represents query sequence. The main output is delta file.
```
nucmer --maxmatch -c 100 -p ${SEED} ${REF} ${SEED}
```
##### 5.2) Mummerplot

This part of script takes output delta file and graph it using Mummerplot with png format. X-axsis represents reference genome and y-axis represents query genome. Line represents continuity, while dots represents translocaton or indels.

```
mummerplot --png --fat --layout --filter ${SEED}.delta -R ${REF} -Q ${SEED} --prefix=${SEED}
```

![Alt text](https://github.com/beoungl/CS189_project/blob/master/nucmer_png/SK1_new.fasta.png)

## 6) Assembly-stats

N50 score was analyzed using Assemblystats.

The resulting N50 score should look simlar to this table (ignore sequencing technology column, as they were not obtained through Assembly-stats):

![Alt text](https://github.com/beoungl/CS189_project/blob/master/n50.png)


# Conclusion
Refer to the [final paper](https://docs.google.com/document/d/1KNQ6TGLGn5cANC1CSuzZIuPjTDEG9VN8L9dKRxzwwns/edit) for conclusion and analysis.

# Directory tree

**Nucmer_pdf and nucmer_ps directories are not included in this tree, as they are huge folder that were byproducts of experiment.

```
|-- assembly_stats
|   |-- g833-1B_reference.stats
|   |-- S288C_reference.stats
|   |-- SK1_reference.stats
|   |-- suvarum_cbs7001.stats
|   `-- W303_reference.stats
|-- beoungl.yml
|-- data
|   |-- 18s
|   |   |-- S288C.fasta
|   |   |-- SK1.fasta
|   |   `-- W303.fasta
|   |-- 18s_rrna.aa.fasta
|   |-- dat.ls
|   |-- g833-1B_reference.fasta
|   |-- originals
|   |   |-- g833-1B_reference.fasta
|   |   |-- S288C_reference.fasta
|   |   |-- SK1_reference.fasta
|   |   |-- suvarum_cbs7001.fasta
|   |   `-- W303_reference.fasta
|   |-- README
|   |-- S288C_reference.fasta
|   |-- SK1_reference.fasta
|   |-- smol
|   |   |-- g833-1B_reference.fasta
|   |   |-- S288C_reference.fasta
|   |   |-- SK1_reference.fasta
|   |   |-- suvarum_cbs7001.fasta
|   |   |-- W303_reference.fasta
|   |   `-- yeast.txt
|   |-- suvarum_cbs7001.fasta
|   `-- W303_reference.fasta
|-- gen_figs.sh
|-- hub
|   |-- Anc0
|   |   |-- Anc0.2bit
|   |   |-- chrom.sizes
|   |   |-- description.html
|   |   `-- trackDb.txt
|   |-- bayanus_uvarum_strain_CBS7001
|   |   |-- bayanus_uvarum_strain_CBS7001.2bit
|   |   |-- chrom.sizes
|   |   |-- description.html
|   |   `-- trackDb.txt
|   |-- cerevisiae_strain_g833-1B
|   |   |-- cerevisiae_strain_g833-1B.2bit
|   |   |-- chrom.sizes
|   |   |-- description.html
|   |   `-- trackDb.txt
|   |-- cerevisiae_strain_S288C
|   |   |-- cerevisiae_strain_S288C.2bit
|   |   |-- chrom.sizes
|   |   |-- description.html
|   |   `-- trackDb.txt
|   |-- cerevisiae_strain_SK1
|   |   |-- cerevisiae_strain_SK1.2bit
|   |   |-- chrom.sizes
|   |   |-- description.html
|   |   `-- trackDb.txt
|   |-- cerevisiae_strain_W303
|   |   |-- cerevisiae_strain_W303.2bit
|   |   |-- chrom.sizes
|   |   |-- description.html
|   |   `-- trackDb.txt
|   |-- documentation
|   |   `-- hubCentral.html
|   |-- genomes.txt
|   |-- groups.txt
|   |-- haltree.nw
|   |-- hub.txt
|   |-- lod
|   |   |-- yeast_lod_1531.hal
|   |   |-- yeast_lod_23935.hal
|   |   |-- yeast_lod_245.hal
|   |   |-- yeast_lod_3829.hal
|   |   |-- yeast_lod_59837.hal
|   |   |-- yeast_lod_612.hal
|   |   |-- yeast_lod_9574.hal
|   |   `-- yeast_lod_98.hal
|   |-- lod.txt
|   `-- yeast.hal -> /dfs3/pub/beoungl/CS189_project/outputs_satsuma_cactus_take1/yeast.hal

|-- nucmer_png
|   |-- g833-1B_reference.fasta.png
|   |-- g833_new.fasta.png
|   |-- g833_xy.png
|   |-- old_g833.png
|   |-- old_SK1.png
|   |-- old_suvarum.png
|   |-- old_W303.png
|   |-- out.png
|   |-- SK1_new.fasta.png
|   |-- SK1_reference.fasta.png
|   |-- SK1_reference.png
|   |-- SK1_xy.png
|   |-- suvarum_cbs7001.fasta.png
|   |-- suvarum_cbs7001_new.fasta.png
|   |-- suvarum_xy.png
|   |-- W303_new.fasta.png
|   |-- W303_reference.fasta.png
|   `-- W303_xy.png
|-- outputs
|   |-- g833-1B_reference
|   |   |-- kmatch_results.k11
|   |   |-- kmatch_results.k13
|   |   |-- kmatch_results.k15
|   |   |-- kmatch_results.k17
|   |   |-- kmatch_results.k19
|   |   |-- kmatch_results.k21
|   |   |-- kmatch_results.k23
|   |   |-- kmatch_results.k25
|   |   |-- kmatch_results.k27
|   |   |-- kmatch_results.k29
|   |   |-- kmatch_results.k31
|   |   |-- MergeXCorrMatches.chained.out
|   |   |-- satsuma.log
|   |   |-- satsuma_summary.chained.out
|   |   `-- xcorr_aligns.final.out
|   |-- SK1_reference
|   |   |-- kmatch_results.k11
|   |   |-- kmatch_results.k13
|   |   |-- kmatch_results.k15
|   |   |-- kmatch_results.k17
|   |   |-- kmatch_results.k19
|   |   |-- kmatch_results.k21
|   |   |-- kmatch_results.k23
|   |   |-- kmatch_results.k25
|   |   |-- kmatch_results.k27
|   |   |-- kmatch_results.k29
|   |   |-- kmatch_results.k31
|   |   |-- MergeXCorrMatches.chained.out
|   |   |-- satsuma.log
|   |   |-- satsuma_summary.chained.out
|   |   `-- xcorr_aligns.final.out
|   |-- suvarum_cbs7001
|   |   |-- kmatch_results.k11
|   |   |-- kmatch_results.k13
|   |   |-- kmatch_results.k15
|   |   |-- kmatch_results.k17
|   |   |-- kmatch_results.k19
|   |   |-- kmatch_results.k21
|   |   |-- kmatch_results.k23
|   |   |-- kmatch_results.k25
|   |   |-- kmatch_results.k27
|   |   |-- kmatch_results.k29
|   |   |-- kmatch_results.k31
|   |   |-- MergeXCorrMatches.chained.out
|   |   |-- satsuma.log
|   |   |-- satsuma_summary.chained.out
|   |   `-- xcorr_aligns.final.out
|   `-- W303_reference
|       |-- kmatch_results.k11
|       |-- kmatch_results.k13
|       |-- kmatch_results.k15
|       |-- kmatch_results.k17
|       |-- kmatch_results.k19
|       |-- kmatch_results.k21
|       |-- kmatch_results.k23
|       |-- kmatch_results.k25
|       |-- kmatch_results.k27
|       |-- kmatch_results.k29
|       |-- kmatch_results.k31
|       |-- MergeXCorrMatches.chained.out
|       |-- satsuma.log
|       |-- satsuma_summary.chained.out
|       `-- xcorr_aligns.final.out
|-- outputs_satsuma_cactus_take1
|   |-- g833-1B_reference
|   |   |-- kmatch_results.k11
|   |   |-- kmatch_results.k13
|   |   |-- kmatch_results.k15
|   |   |-- kmatch_results.k17
|   |   |-- kmatch_results.k19
|   |   |-- kmatch_results.k21
|   |   |-- kmatch_results.k23
|   |   |-- kmatch_results.k25
|   |   |-- kmatch_results.k27
|   |   |-- kmatch_results.k29
|   |   |-- kmatch_results.k31
|   |   |-- MergeXCorrMatches.chained.out
|   |   |-- satsuma.log
|   |   |-- satsuma_summary.chained.out
|   |   `-- xcorr_aligns.final.out
|   |-- S288C_reference
|   |   |-- kmatch_results.k11
|   |   |-- kmatch_results.k11.finished
|   |   |-- kmatch_results.k13
|   |   |-- kmatch_results.k13.finished
|   |   |-- kmatch_results.k15
|   |   |-- kmatch_results.k15.finished
|   |   |-- kmatch_results.k17
|   |   |-- kmatch_results.k17.finished
|   |   `-- satsuma.log
|   |-- SK1_reference
|   |   |-- kmatch_results.k11
|   |   |-- kmatch_results.k13
|   |   |-- kmatch_results.k15
|   |   |-- kmatch_results.k17
|   |   |-- kmatch_results.k19
|   |   |-- kmatch_results.k21
|   |   |-- kmatch_results.k23
|   |   |-- kmatch_results.k25
|   |   |-- kmatch_results.k27
|   |   |-- kmatch_results.k29
|   |   |-- kmatch_results.k31
|   |   |-- MergeXCorrMatches.chained.out
|   |   |-- satsuma.log
|   |   |-- satsuma_summary.chained.out
|   |   `-- xcorr_aligns.final.out
|   |-- suvarum_cbs7001
|   |   |-- kmatch_results.k11
|   |   |-- kmatch_results.k13
|   |   |-- kmatch_results.k15
|   |   |-- kmatch_results.k17
|   |   |-- kmatch_results.k19
|   |   |-- kmatch_results.k21
|   |   |-- kmatch_results.k23
|   |   |-- kmatch_results.k25
|   |   |-- kmatch_results.k27
|   |   |-- kmatch_results.k29
|   |   |-- kmatch_results.k31
|   |   `-- satsuma.log
|   |-- W303_reference
|   |   |-- kmatch_results.k11
|   |   |-- kmatch_results.k13
|   |   |-- kmatch_results.k15
|   |   |-- kmatch_results.k17
|   |   |-- kmatch_results.k19
|   |   |-- kmatch_results.k21
|   |   |-- kmatch_results.k23
|   |   |-- kmatch_results.k25
|   |   |-- kmatch_results.k27
|   |   |-- kmatch_results.k29
|   |   |-- kmatch_results.k31
|   |   |-- MergeXCorrMatches.chained.out
|   |   |-- satsuma.log
|   |   |-- satsuma_summary.chained.out
|   |   `-- xcorr_aligns.final.out
|   `-- yeast.hal
|-- packages.list
|-- papers
|   |-- examples
|   |   |-- hidden_genetic_variation_shapes_the_structure_of_functional_elements_in_drosophila.pdf
|   |   |-- long_read_sequence_assembly_of_the_gorilla_genome.pdf
|   |   |-- structural_variants_clonal_propagation_and_genome_evolution_in_grapevine.pdf
|   |   |-- structural_variants_exhibit_allelic_heterogeneity_and_shape_variation_in_complex_traits.pdf
|   |   `-- syntenic_gene_analysis_between_brassica_rapa_and_other_brassicaceae_species.pdf
|   `-- protocol
|       |-- cactus_algorithms_for_genome_multiple_sequence_alignment.pdf
|       |-- cinteny_flexible_analysis_and_visualization_of_synteny_and_genome_rearrangements_in_multiple_organisms.pdf
|       |-- inferring_synteny_between_genome_assemblies_a_systematic_evaluation.pdf
|       |-- simplesynteny_a_web_based_tool_for_visualization_of.pdf
|       `-- synchro_a_fast_and_easy_tool_to_reconstruct_and_visualize_synteny_blocks_along_eukaryotic_chromosomes.PDF
|-- qsub_nucmer.sh
|-- qsub_satsuma.sh
|-- README.md
|-- sample_pipeline.txt
|-- scripts
|   |-- gen_mini_fasta.py
|   |-- get_contig_desc.py
|   |-- ren_condensed.py
|   `-- ren_contigs.py
|-- yeast.txt
|-- yll065w.fasta
`-- yll065w.ph
```
