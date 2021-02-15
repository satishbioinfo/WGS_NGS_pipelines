#!/usr/bin/python
## This Script will extract regions in a BAM file and create a smaller BAM for investigation
## This Script is also equiped with option of converting BAM --- > CRAM
## The mapper used here is BWA ###############
#### Author: Satish RG #######
import sys
import os
import glob
import argparse


def get_arg():
    parse = argparse.ArgumentParser()
    reqargs = parse.add_argument_group('Required')
    reqwdef = parse.add_argument_group('Required with default')
    # optarg = parse.add_argument_group('optional arguments')
    reqargs.add_argument('-i', '--inpBAMfiile', type=str, required=True, help='Provide the full path of the BAM file.')
    reqargs.add_argument('-o', '--outpath', type=str, required=True, help='Provide the full path for output file.')
    reqargs.add_argument('-n', '--name', type=str, required=True, help='Provide the preferred name of output file.')
    reqargs.add_argument('-p', '--position', type=str, required=True, help='Provide the postion to be extracted chr#:start-stop.')
    reqargs.add_argument('-f', '--outputformat', type=str, required=True, help='Provide the format the output to be obtain, BAM or CRAM.')
    reqwdef.add_argument('-m', '--map_file', type=str, default = 'GATK/Homo_sapiens_assembly38.fasta', help='provide the sample mapping file if you have')
    allarg = parse.parse_args()
    return allarg


def mapping(inpbam, opath, oname, pos, format, mapfile):
    #samtools = ''
    if (format == "BAM"):
        #samtools = ''
        ## cmd1 can be substituted by providing the path of the Samtools installed path
        outbam = opath + oname +'.bam'
        cmd1 = 'module load samtools'
        cmd2 = 'samtools view -b -h ' + inpbam + ' ' + pos + ' - o '+outbam
        cmd3 = 'samtools index ' + outbam
        os.system(cmd1)
        os.system(cmd2)
        os.system(cmd3)
    if (format == "CRAM"):
        #samtools = ''
        outbam = opath + oname + '.bam'
        cramout = opath + oname + '.cram'
        cmd1 = 'module load samtools'
        cmd2 = 'samtools view -b -h '+inpbam+' '+pos+ ' - o '+outbam
        cmd3 = 'samtools index '+outbam
        cmd4 = 'samtools view -C -T '+mapfile+ ' -o '+cramout+' '+outbam
        cmd5 = 'samtools index '+cramout
        os.system(cmd1)
        os.system(cmd2)
        os.system(cmd3)
        os.system(cmd4)
        os.system(cmd5)

def main():
    arg = get_arg()
    print(arg.inpBAMfiile + "\t" + arg.outpath + "\n"+arg.name+ "\n"+arg.positon + "\n"+arg.outputformat+"\n"+map_file)
    print("It is working")


if __name__ == "__main__":
    main()
