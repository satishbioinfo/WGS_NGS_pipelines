#!/usr/bin/perl
use strict;
use warnings;
#### Author : Satishkumar RG #####
### bioinformatics (dot) satish (at)gmail (dot)com #####

#### Trio VCF analysis ####

my ($proband, $dad, $mom, $outpath) = @ARGV;

##### Creating and opening Output files #####
################################################
my $tempmomdadvar = $outpath."tempallmomdadvar.txt";


#my $allmomdadvar = $outpath."allmomdadvar";
my $allmomdadvargeno = $outpath."allmd_genotype_matrix.txt";

my $incldprb = $outpath."proband_md_genotype_matrix.txt";

open (OUT, ">>$tempmomdadvar") or die "Can't open it $!";
open (OUT1, ">$allmomdadvargeno") or die "Can't open it $!";
open (OUT2, ">$incldprb") or die "Can't open it $!";



open (D, "$dad") or die "Can't open it $!";
while (my $inp = <D>){
chomp($inp);
if ($inp=~/#/){
	next;
}
my @a = split(/\t/,$inp);
my @b = split(/\:/,$a[9]);
my $str = $a[0]."\t".$a[1]."\t".$a[3]."\t".$a[4]."\t".$b[0]."\tDAD";
print OUT $str."\n";
}

open (M, "$mom") or die "Can't open it $!";
while (my $inp1 = <M>){
chomp($inp1);
if ($inp1=~/#/){
	next;
}
my @a1 = split(/\t/,$inp1);
my @b1 = split(/\:/,$a1[9]);
my $str1 = $a1[0]."\t".$a1[1]."\t".$a1[3]."\t".$a1[4]."\t".$b1[0]."\tMOM";
print OUT $str1."\n";
}

close OUT;

my %hash;

open (F, "$tempmomdadvar") or die "Can't open it $!";
while (my $in = <F>){
chomp($in);
my @c = split(/\t/,$in);
my $ts = $c[0]."\t".$c[1]."\t".$c[2]."\t".$c[3];
my $st = $c[5].":".$c[4];
push (@{$hash{$ts}},$st);
}

my %hash1;


foreach my $list1 (keys %hash)
{
my @arr=@{$hash{$list1}};
#print "@array";
#my @tmp='';
foreach my $arr (@arr) {
@arr = join (',',@arr);
my $string = join ("\t",$list1,@arr);
print OUT1 "$string\n";
my @d = split(/\t/,$string);
my $tr = $d[0]."\t".$d[1]."\t".$d[2]."\t".$d[3];
$hash1{$tr}=$d[4];
}
}


foreach my $key (keys %hash1){
	#print $key."\t".$hash1{$key}."\n";
}

open (P, "$proband") or die "Can't open it $!";
while (my $ip = <P>){
chomp($ip);
if ($ip=~/#/){
	next;
}
my @a2 = split(/\t/,$ip);
my @b2 = split(/\:/,$a2[9]);
my $st1 = $a2[0]."\t".$a2[1]."\t".$a2[3]."\t".$a2[4];
my $st2 = $b2[0].":Proband";

if (exists ($hash1{$st1})){
	print OUT2 $st1."\t".$st2."\t".$hash1{$st1}."\n";
}

}



