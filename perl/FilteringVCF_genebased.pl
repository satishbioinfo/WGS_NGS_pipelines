#!/usr/bin/perl

#### This script uses the information from an ANNOVAR annotated  file #####
#### Author : satish kumar #####
### bioinformatics (dot) satish (at)gmail (dot)com #####

use strict;
use warnings;

my ($infile, $genefile, $output) = @ARGV;

open (OUT,">$output") or die "Can't open it $!";

my %hash;
open (F, "$genefile") or die "Can't open it $!";
while (my $inp = <F>){
chomp($inp);
#my @a = split(/\t/,$inp);
$hash{$inp}='';
}

open (F1, "$infile") or die "Can't open it $!";
while (my $inp1 = <F1>){
chomp($inp1);
my @a = split(/\t/,$inp1);
if (exists $hash{$a[4]}){

	print OUT $inp1."\n";
}
}
