#!/usr/bin/python
## This Script will process the generate VCF file normalizing it (unpad multiple allele into two separate rows##
## This also cleans up VCF file filtering out variants AC>0###
## bcftools is majorly used for this process ###############
#### Author: Satish RG #######
import sys
import os
import glob
import argparse


def get_arg():
    parse = argparse.ArgumentParser()
    reqargs = parse.add_argument_group('Required')
    #reqwdef = parse.add_argument_group('Required with default')
    optarg = parse.add_argument_group('optional arguments')
    reqargs.add_argument('-i', '--inpVCF', type=str, required=True, help='Provide the full path of the BAM file.')
    reqargs.add_argument('-o', '--outpath', type=str, required=True, help='Provide the full path for output file.')
    #optarg.add_argument('-m', '--mapfile', type=str, help='provide the sample names to be remapped')
    allarg = parse.parse_args()
    return allarg

def vcfproc(invcf, outfold):
    #invcf= ''
    #ref = ''
    normvcf = outfold+"normalized_vcf.gz"
    cleanvcf= outfold+"normalized_clean_vcf.gz"
    bcftool='/usr/bin/bcftools'
    #Normalize the VCF with bcftools
    cmd = bcftool+' norm -m -any -- threads 12 -Oz -o '+normvcf+' '+invcf+';tabix -p vcf '+normvcf
    #clean the normalized VCF for AC>0
    cmd1= bcftool+' view -e "AC=0" -Oz -o '+cleanvcf+' '+normvcf+';tabix -p vcf '+cleanvcf
    ##Executing the commands ######
    os.system(cmd)
    os.system(cmd1)

def main():
    arg = get_arg()
    print(arg.inpVCF+"\t"+arg.outpath+"\n")
    print("It is working")
    vcfproc(arg.inpVCF,arg.outpath)



if __name__ == "__main__":
    main()