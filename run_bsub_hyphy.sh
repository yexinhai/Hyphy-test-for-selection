#!/bin/bash
# Ye Xinhai, yexinhai@zju.edu.cn;
input_table_list=./input.table.list

for i in `cat $input_table_list`
do
	mkdir $i
	cd $i
	ln -s ../positive_selection_hyphybusted.pl .
	ln -s ../input.table/$i .
	cp ../lsf/$i.lsf .
	bsub< $i.lsf
	cd ..
done
