#!/usr/bin/perl
### Author: Satishkumar R G #####
### Script Description:  #####
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
GetOptions ($settings, qw (idir=s odir=s build=s));
my $indir = $$settings{idir} or die usage ();
my $outdir = $$settings{odir} or die usage ();
my $hgbuild = $$settings{build} or die usage();
varscan ($indir, $outdir);
#annovar ($outdir, $hgbuild);
return 0;
}

##### Input file would be a Mpileup directory from the SAM BAM module #####

###########################################################################
sub varscan{
  my ($indir, $outdir) = @_;

  chomp ($outdir);

  ###################################
  ### Making Varscan Output Dir #####
  ###################################

  my $varscanodir = $outdir."varscan";
  system ("mkdir $varscanodir");
  system ("chmod 777 -R  $varscanodir");

  opendir (DIR, "$indir") or die "unable to open $!";
  my @list = grep /\.mpileup/, readdir DIR;
  close DIR;
print "Performing varscan calling\n";
for (my $i=0; $i<= $#list; $i++)
{
chomp ($list[$i]);
print "$list[$i]\n";
my @a = split(/\./,$list[$i]);
my $vcf = $varscanodir."/".$a[0].".vcf";
my $inp = $indir.$list[$i];

system ("java -jar /home/satishk/VarScan.v2.3.9.jar mpileup2cns $inp --min-coverage 10 --min-avg-qual 15 --min-var-freq 0.20 --strand-filter 0 --variants 1 --output-vcf 1 >$vcf");
}
print "Completed Variant Calling\n";
return 1;
}


sub usage{
"Performing Varscan variant calling processing
Usage $0 -i <Input folder> -o <Output Folder> -b <build>";
}
