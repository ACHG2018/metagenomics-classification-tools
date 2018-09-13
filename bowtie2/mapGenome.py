#!/usr/bin/python
import os
#Looping through the directory

genomeDir = '/mnt/c/Users/Vasanta Chivukula/Documents/Vannberg class/Challenge/testGenomes'
outputDir = '/mnt/c/Users/Vasanta Chivukula/Documents/Vannberg class/Challenge/testGenomeOutput'
indexDir = '/mnt/c/Users/Vasanta Chivukula/Documents/Vannberg class/Challenge/ChallengeGenomes'
createdIndexFolder='/mnt/c/Users/Vasanta Chivukula/Documents/Vannberg class/Challenge/index'
genomeFileList = []

# Generating the index file

#bowtie2-build humangenome.fasta index.fasta


#bowtie2-build for challenge genomes
for indexFile in os.listdir(indexDir):
	if indexFile.startswith("CR"):
		cStr = indexFile.split(".")
		#print("bowtie2-build "+indexDir+"/"+indexFile+" "+createdIndexFolder+"/"+cStr[0]+"index.fasta") 
		os.system("bowtie2-build "+indexDir+"/"+indexFile+" "+createdIndexFolder+"/"+cStr[0]+"index.fasta")


for genomeFile in os.listdir(genomeDir):
	if genomeFile.startswith("C"):
		genomeFileList.append(genomeFile)
		
# Looping through file list to get 2 consecutive files.
for x,y in zip(genomeFileList[::2],genomeFileList[1::2]):
	#print (x,y)
	data = x.split("_")
	if not os.path.exists(outputDir+"/"+data[0]):
		os.mkdir(outputDir+"/"+data[0])
	# Running bowtie
	#bowtie2 –x index -1 C16_R1.fastq -2 C16_R2.fastq –S C16_human_out.sam
	#print("bowtie2 -x index -1"+" "+genomeDir+"/"+x+" -2 "+genomeDir+"/"+y+" -S "+outputDir+"/"+data[0]+"/"+data[0]+"_human_out.sam")
	os.system("bowtie2 -x index -1"+" "+genomeDir+"/"+x+" -2 "+genomeDir+"/"+y+" -S "+outputDir+"/"+data[0]+"/"+data[0]+"_human_out.sam")
	
	
	# Running samtools
	#samtools view –S –b C16_human_out.sam > C16_human_out.bam 
	#print("samtools view –S –b "+outputDir+"/"+data[0]+"/"+data[0]+"_human_out.sam > "+outputDir+"/"+data[0]+"/"+data[0]+"_human_out.bam") 
	os.system("samtools view –S –b "+outputDir+"/"+data[0]+"/"+data[0]+"_human_out.sam > "+outputDir+"/"+data[0]+"/"+data[0]+"_human_out.bam")
	
	
	# Sorting bam file
	#samtools sort C16_human_out.bam –o human.sorted.bam
	#print("samtools sort "+outputDir+"/"+data[0]+"/"+data[0]+"_human_out.bam" + " -o " +outputDir+"/"+data[0]+"/human.sorted.bam") 
	os.system("samtools sort "+outputDir+"/"+data[0]+"/"+data[0]+"_human_out.bam" + " -o " +outputDir+"/"+data[0]+"/human.sorted.bam")
	
	# Getting unmapped reads.
	#samtools view –f 12 -F 256 C16_human.sorted.bam > C16_human.unmapped.bam
	#print("samtools view –f 12 -F 256 "+outputDir+"/"+data[0]+"/"+data[0]+"_human.sorted.bam > "+outputDir+"/"+data[0]+"/"+data[0]+"_human.unmapped.bam") 
	os.system("samtools view –f 12 -F 256 "+outputDir+"/"+data[0]+"/"+data[0]+"_human.sorted.bam > "+outputDir+"/"+data[0]+"/"+data[0]+"_human.unmapped.bam")
	
	# Sorting the files to get the paired reads next to each other
	#samtools sort -n C16_human_bothendsunmapped.bam -o C16_human_bothendsunmapped_sorted.bam
	#print("samtools sort -n "+outputDir+"/"+data[0]+"/"+data[0]+"_human_bothendsunmapped.bam -o "+outputDir+"/"+data[0]+"/"+data[0]+"_human.bothendsunmapped_sorted.bam")
	os.system("samtools sort -n "+outputDir+"/"+data[0]+"/"+data[0]+"_human_bothendsunmapped.bam -o "+outputDir+"/"+data[0]+"/"+data[0]+"_human.bothendsunmapped_sorted.bam")
	
	# Splitting and converting to fastq
	#bedtools bamtofastq -i C16_human_bothendsunmapped_sorted.bam -fq C16_human_unmapped_read1.fastq -fq2 C16_human_unmapped_read2.fastq
	#print("bedtools bamtofastq -i "+outputDir+"/"+data[0]+"/"+data[0]+"_human.bothendsunmapped_sorted.bam -fq "+outputDir+"/"+data[0]+"/"+data[0]+"_human_unmapped_read1.fastq -fq2 " +outputDir+"/"+data[0]+"/"+data[0]+"_human_unmapped_read2.fastq")
	os.system("bedtools bamtofastq -i "+outputDir+"/"+data[0]+"/"+data[0]+"_human.bothendsunmapped_sorted.bam -fq "+outputDir+"/"+data[0]+"/"+data[0]+"_human_unmapped_read1.fastq -fq2 " +outputDir+"/"+data[0]+"/"+data[0]+"_human_unmapped_read2.fastq")