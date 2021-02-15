#!/usr/bin/python
## This Script will map the reads to the reference genome
## The mapper used here is BWA ###############
#### Author: Satish RG #######
import sys
import os
import glob
import argparse

def get_arg():
    parse = argparse.ArgumentParser()
    reqargs = parse.add_argument_group('Required')
    reqargs.add_argument('-i', '--inpBAMfiile', type=str, required=True, help='Provide the full path of the fastq input directory.')
    reqargs.add_argument('-o', '--outBAMfile', type=str, required=True, help='Provide the full path to the output directory.')
    #optarg.add_argument('-m', '--map_file', type=str, required=False, help='provide the sample mapping file if you have')
    allarg = parse.parse_args()
    return allarg

def mapping(read1, read2, outfile):
    bwa = ''
    ref = ''
    cmd = bwa+'mem -t 4 -M ' + ref + read1 + read2 + '>' + outfile
    os.system(cmd)

def main():
    arg = get_arg()
    print(arg.inputdir+"\t"+arg.outputdir+"\n")
    print("It is working")

if __name__ == "__main__":
    main()
