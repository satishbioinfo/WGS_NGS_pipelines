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
    # reqwdef = parse.add_argument_group('Required with default')
    # optarg = parse.add_argument_group('optional arguments')
    reqargs.add_argument('-i', '--inpBAMfiile', type=str, required=True, help='Provide the full path of the BAM file.')
    reqargs.add_argument('-o', '--outBAMfile', type=str, required=True, help='Provide the full path and the name for the output extracted BAM file.')
    reqargs.add_argument('-p', '--position', type=str, required=True, help='Provide the postion to be extracted chr#:start-stop.')
    reqargs.add_argument('-f', '--outputformat', type=str, required=True, help='Provide the format the output to be obtain, BAM or CRAM.')
    # optarg.add_argument('-m', '--map_file', type=str, required=False, help='provide the sample mapping file if you have')
    allarg = parse.parse_args()
    return allarg


def mapping(inpbam, outbam, pos, format):
    #samtools = ''
    if (format == "BAM"):
        #samtools = ''
        cmd1 = 'module load samtools'
        cmd2 = 'samtools view -b -h ' + inpbam + ' ' + pos + ' - o '+outbam
        cmd3 = 'samtools index ' + outbam
        os.system(cmd1)
        os.system(cmd2)
        os.system(cmd3)
    #if (format == "CRAM"):
        #samtools = ''
     #   cmd1 = 'module load samtools'
     #  cmd2 = 'samtools view -b -h '+inpbam+' '+pos+ ' - o '+outbam
     #   cmd3 = 'samtools index '+outbam
     #   cmd4 =
     #   os.system(cmd1)
     #   os.system(cmd2)
     #   os.system(cmd3)

def main():
    arg = get_arg()
    print(arg.inpBAMfiile + "\t" + arg.outBAMfile + "\n"+arg.positon+ "\n"+arg.format)
    print("It is working")


if __name__ == "__main__":
    main()
