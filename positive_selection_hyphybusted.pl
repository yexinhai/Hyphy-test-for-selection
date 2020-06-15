#!/usr/bin/perl -w
use strict;
# Xinhai Ye, yexinhai@zju.edu.cn

#用法：perl 程序.pl all.pep.fasta all.cds.fasta 1_1_1_group_sorted.txt
#读所有物种的序列；

sub Usage(){
	print STDERR "
	positive_selection_hyphybusted.pl <all.pep.fasta> <all.cds.fasta> <1_1_1_group_sorted.txt>
	\n";
	exit(1);
}
&Usage() unless $#ARGV==2;


my $genename;
my %hash_1;

open my $fasta1, "<", $ARGV[0] or die "Can't open file!";
while (<$fasta1>) {
	chomp();
	if (/^>(\S+)/){
		$genename = $1;
	} else {
		$hash_1{$genename} .= $_;
	}
}
close $fasta1;

my $cds_id;
my %hash_cds;

open my $fasta2, "<", $ARGV[1] or die "Can't open cds file!\n";
while (<$fasta2>) {
	chomp();
	if (/^>(\S+)/) {
		$cds_id = $1;
	} else {
		$hash_cds{$cds_id} .= $_;
	}
}
close $fasta2;

`mkdir hyphy_result`;

open my $Group, "<", $ARGV[2] or die "Cant't open group file!";
while (<$Group>) {
	chomp();
	my @array1 = split /\s/, $_;
	my $group_nogood = shift @array1;
	my @array2 = split /:/, $group_nogood;
	my $group = $array2[0];
	`mkdir $group`;
	open OUT1, ">","$group\.pep.fasta";
	foreach (@array1) {
		print OUT1 ">".$_."\n".$hash_1{$_}."\n";
	}
	close OUT1;
	open OUT2, ">","$group\.cds.fasta";
	foreach (@array1) {
		print OUT2 ">".$_."\n".$hash_cds{$_}."\n";
	}
	close OUT2;
	`mv $group\.pep.fasta $group`;
	`mv $group\.cds.fasta $group`;
	`mafft --auto $group/$group\.pep.fasta >$group\/$group\.pep.mafft.fasta`;
	`mkdir $group\/for_hyphy`;
	`perl ../pal2nal.pl $group\/$group\.pep.mafft.fasta $group\/$group\.cds.fasta -output fasta -nogap >$group\/for_paml/test.codon.fasta`;
	open my $codon_ala, "<", "$group\/for_hyphy/test.codon.fasta" or die "can't open test.codon.fasta in $group !\n";
	open OUT3, ">", "$group\/for_hyphy/test.codon.changename.fasta";
	while (<$codon_ala>) {
		chomp();
		if (/^(>\w\w\w\w)\S+\d+/) {
			print OUT3 $1."\n";
		} else {
			print OUT3 $_."\n";
		}
	}
	close $codon_ala;
	close OUT3;
	`cp ..\/wasp.tree $group\/for_hyphy`;
	chdir "$group\/for_hyphy";
	`hyphy busted --alignment test.codon.changename.fasta --tree wasp.tree  --branches Foreground`;
	open my $resultsfile, "<", "test.codon.changename.fasta.BUSTED.json" or die "can't open BUSTED.json file in $group !\n";
	open OUT4, ">", "$group\.busted.result";
	while (<$resultsfile>) {
		chomp();
		if (/^\s+\"p-value\"\:(\S+)$/) {
			print OUT4 $group."\t".$1."\t";
		} 
	}
	close OUT4;
	`cp $group\.busted.result ..\/..\/hyphy_result`;
	chdir "..\/..\/";

}
close $Group;




