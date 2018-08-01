#!/usr/bin/perl
### Author: Satishkumar R G #####
### Script Description: Perform preparation of mapped file in sam format for downstream analysis #####
#### This script also creates the mpileup folder with mpileup for variant calling #########
############################################################################

#### Here the input folder will be the SAM folder created in the previous step#####
#### Output folder will be the "Map_folder" - where a sub folder "BAM" will be created #####
###################################################################
use strict;
use warnings;
use Getopt::Long;
exit(main());

sub main{
my $settings={};
GetOptions ($settings, qw (idir=s odir=s stats=s ref=s));
my $indir = $$settings{idir} or die usage ();
my $outdir = $$settings{odir} or die usage ();
my $stats = $$settings{stats} or die usage();
my $ref = $$settings{ref} or die usage();
sambam ($indir, $outdir, $stats, $ref);
return 0;
}

##### Step2 : SAM--->BAM processing Module -- Performs sam to bam conversion along with cleaning up the BAM #####
###### We use SamTools to get this analysis done ###################
#####################################################################

sub sambam{

my ($indir, $outdir, $stats, $ref)=@_;

########################################
### Creating a Stats file to capture all mapping stats ##
########################################
chomp ($stats);
my $statsout = $outdir.$stats.".txt";

open (OUT, ">>$statsout") or die "Can't open $!";

print OUT ("Sample Name\tTotal Reads\t# of Mapped Reads\t# of Unmapped Reads\t% of Mapped\t% of Unmapped\n");


########################################
### Creating a  BAM folder map folder ##
########################################
chomp ($outdir);

my $bmfold = $outdir."/Map_folder/BAM";
system ("mkdir $bmfold");
system ("chmod 777 -R $bmfold");

###########################################



########################################
### Creating a  mpileup ouput folder ##
########################################
chomp($ref);

my $mpfold = $outdir."/Mpileup";
system ("mkdir $mpfold");
system ("chmod 777 -R $mpfold");

###########################################


opendir (DIR, "$indir") or die "unable to open $!";
my @list = grep /\.sam/, readdir DIR;
close DIR;

my %hash;
my $totreads ='';
my $mappedreads='';
my $unmapreads='';
my $mapper='';
my $unmapper='';
for (my $i=0; $i<= $#list; $i++)
{
chomp ($list[$i]);
print "$list[$i]\n";
my @a = split(/\./,$list[$i]);

my $inp = $indir.$a[0].".sam";
my $of = $bmfold."/".$a[0].".bam";
my $ofs = $bmfold."/".$a[0]."_sorted.bam";

####################################################

###### To customize the script: Add your BWA Path here ####################

system ("/home/satishk/samtools-1.6/samtools view -bS $inp >$of");
system ("/home/satishk/samtools-1.6/samtools sort $of -o $ofs");

############################################################
################ Adding Statistics to the stats file #######
############################################################
$totreads=`/home/satishk/samtools-1.6/samtools view -c $ofs`;
$totreads=~s/\s//g;

$mappedreads=`/home/satishk/samtools-1.6/samtools view -c -F 4 $ofs`;
$mappedreads=~s/\s//g;

$unmapreads=`/home/satishk/samtools-1.6/samtools view -c -f 4 $ofs`;
$unmapreads=~s/\s//g;

my $mapper=(($mappedreads/$totreads)*100);
$mapper= sprintf("%.2f",$mapper);

my $unmapper=(($unmapreads/$totreads)*100);
$unmapper= sprintf("%.2f",$unmapper);

####################################################
print OUT $a[0]."\t".$totreads."\t".$mappedreads."\t".$unmapreads."\t".$mapper."\t".$unmapper."\n";



##############################################################
###### Generating Mpileup file ################################
###########################################

my $mpileout = $mpfold."/".$a[0].".mpileup";

system ("/home/satishk/samtools-1.6/samtools mpileup -f $ref $ofs >$mpileout");

print "Completed Mapping Sample :".$a[0]."\n";
}
return 1;
}

sub usage{
"Performing Sam file processing
Usage $0 -i <Input folder> -o <Output Folder> -s <Mapping Summary name> -r <reference path>";
}
