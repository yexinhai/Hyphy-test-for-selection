#!/bin/bash
# Xinhai Ye, yexinhai@zju.edu.cn
input_table_list=./input.table.list

for i in `cat $input_table_list`
do
	exec 3>$i.\lsf

	echo "#!/bin/bash" >&3
	echo "#BSUB -J hyphy" >&3
	echo "#BSUB -n 1" >&3
	echo "#BSUB -R \"span[hosts=1]\"" >&3
	echo "#BSUB -o hyphy_output_20200615" >&3
	echo "#BSUB -e hyphy_errput_20200615" >&3


	echo "PATH=/gpfs/bioinformatics/software/glibc-2.14/installed/bin:\$PATH" >&3
	echo "LD_LIBRARY_PATH=//gpfs/bioinformatics/software/glibc-2.14/installed/lib:\$LD_LIBRARY_PATH" >&3

	echo "perl positive_selection_hyphybusted.pl ../all.pep.fasta ../all.cds.fasta $i" >&3
done
