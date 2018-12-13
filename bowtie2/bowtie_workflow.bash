#!/usr/bin/env/bash

cd fda_biothreat
working=$(pwd)

#Mapping Challenge reads to HG19 index and extracting out unmapped reads
for i in C{01..21}; do
	#mapping to hg19 and writing output to sam
	bowtie2 -x hg19/hg19 -1 $working/ChallengeData/$i_R1.fastq -2 $working/ChallengeData/$i.fastq -S ${i}_mapped_and_unmapped.sam

	#converting sam to bam
	samtools view -bS $working/ChallengeData/${i}_mapped_and_unmapped.sam > $working/ChallengeData/${i}_mapped_and_unmapped.bam

	#separating unmapped reads 
	samtools view -b -f 12 -F 256 $working/ChallengeData/${i}_mapped_and_unmapped.bam > $working/ChallengeData/${i}_bothEndsUnmapped.bam

	#sort bam file by read name (-n) to have paired reads next to each other as required by bedtools
	samtools sort -n $working/ChallengeData/${i}_bothEndsUnmapped.bam -o $working/ChallengeData/${i}_bothEndsUnmapped_sorted.bam

	#rewriting unmapped bam file as fastq files with each read pair separated
	bedtools bamtofastq -i $working/ChallengeData/${i}_bothEndsUnmapped_sorted.bam -fq $working/ChallengeData/${i}_host_removed_R1.fastq -fq2 $working/ChallengeData/${i}_host_removed_R2.fastq
	
	done;

#cleanup
mkdir $working/host_removed_challengedata
mv $working/ChallengeData/*.host_removed_R[12].fastq $working/host_removed_challengedata/
	
rm $working/ChallengeData/*_mapped_and_unmapped.sam
rm $working/ChallengeData/*_bothEndsUnmapped.bam
rm $working/ChallengeData/*_bothEndsUnmapped_sorted.bam


#indexing challenge_genomes
mkdir $working/ChallengeGenomes/index
ls $working/ChallengeGenomes/C* | xargs -n1 basename | cut -f1 -d. | xargs -I {} bowtie2-build $working/ChallengeGenomes/{}.fasta $working/ChallengeGenomes/index/{}

#Mapping host removed challenge_data to challenge_genomes
for i in C{0..21}; do
	ls $working/ChallengeGenomes/index/ | cut -f1 -d "." | sort -V | uniq | xargs -I {} sh -c "bowtie2 -x ~$working/ChallengeGenomes/index/{} -1 $working/ChallengeData/${i}_host_removed_R1.fastq -2 $working/ChallengeData/${i}_host_removed_R2.fastq -p 12 > $working/aln_outputs/${i}_{}.sam 2>$working/aln_outputs/${i}_{}.log "
	
	grep "alignment rate" $working/aln_outputs/${i}_CR_*.log | cut -f1 -d " " | sed "s/:/\t/g" | sed "s/_*index.fasta.log//g" | sed "s/${i}_/${i}\t/g" > $working/aln_outputs/${i}_aln_rates.out
	
	samtools view -c -F 260 $working/aln_outputs/${i}_CR_*.sam > $working/aln_outputs/${i}_abundance.out
done;	
	