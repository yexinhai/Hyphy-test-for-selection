#!/bin/bash
# Xinhai Ye, yexinhai@zju.edu.cn


#BSUB -J hyphy
#BSUB -n 1
#BSUB -R "span[hosts=1]"
#BSUB -o hyphy_output_20200615
#BSUB -e hyphy_errput_20200615

PATH=/gpfs/bioinformatics/software/glibc-2.14/installed/bin:$PATH
LD_LIBRARY_PATH=//gpfs/bioinformatics/software/glibc-2.14/installed/lib:$LD_LIBRARY_PATH
perl positive_selection_hyphybusted.pl ../all.pep.fasta ../all.cds.fasta single_copy_5047.aa
