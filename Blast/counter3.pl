#!/usr/bin/perl
use strict;
use warnings;

my %ref_count;
my $total_count = 0;
my @tmpArray;
my $tmpNum = 0;
my $keyStr = "CR_";
my $tmpKey;
my $inputFile;
my $key1_refid = "";
my $count_of_match;

while ($tmpNum <= 517){
	$tmpKey = ($keyStr . $tmpNum);
	$ref_count{$tmpKey} = 0;
	$tmpNum += 1;
}

$inputFile = $ARGV[0];

open(my $FILE1, "<", $inputFile) or die "Counld not open file '$inputFile'. $!";

while(my $tmpLine1 = <$FILE1>){
        chomp $tmpLine1;
        @tmpArray = split /\s+/, $tmpLine1;
        $total_count += $tmpArray[1];
}


close $FILE1;


open(my $FILE2, "<", $inputFile) or die "Counld not open file '$inputFile'. $!";

while(my $tmpLine2 = <$FILE2>){
	chomp $tmpLine2;
	@tmpArray = split /\s+/, $tmpLine2;
	$key1_refid = $tmpArray[2];
	$count_of_match = $tmpArray[1]/$total_count;
	$ref_count{$key1_refid} = $count_of_match;	
}

print "$_\t$ref_count{$_}\n" for keys %ref_count;

close $FILE2;


