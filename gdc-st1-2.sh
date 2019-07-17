#!/bin/bash
set -ex
bamtofastq collate=1 exclude=QCFAIL,SECONDARY,SUPPLEMENTARY filename=/home/project/11001079/datasets/swag/tumor-normal_test/sample2/tumor/TCGA-64-5774-01A-01D-1625-08/C509.TCGA-64-5774-01A-01D-1625-08.1.B0147.6.bam gz=1 inputformat=bam level=5 outputdir=/home/users/industry/chicago-university/meghan/GDC-Pipeline/ST1-2-OUTPUT/Sample2/Tumor outputperreadgroup=1 outputperreadgroupsuffixF=_1.fq.gz outputperreadgroupsuffixF2=_2.fq.gz outputperreadgroupsuffixO=_o1.fq.gz outputperreadgroupsuffixO2=_o2.fq.gz outputperreadgroupsuffixS=_s.fq.gz tryoq=1 > foo.fastq.gz

#Check Bam File Mapped Reads (TODO: Update file inputs to reflect filename for first step)
samtools view  /home/project/11001079/datasets/swag/tumor-normal_test/sample2/tumor/TCGA\
-64-5774-01A-01D-1625-08/C509.TCGA-64-5774-01A-01D-1625-08.1.B0147.6.bam | awk '{print length($10)}' | head -1000 | sort -u

#step two - for read length >=70 (TODO: Add step for read length <70 and create if statement that checks read length before directing accordingly
bwa mem -t 8 -T 0 -R "@RG\tID:D12EJ.3\tPL:illumina\tPU:D12EJACXX120801.3.CCTTCGCA\tLB:Catch-166018\tPI:0\tDT:2012-08-01T00:00:00-0400\tSM:TCGA-55-7816-01A-11D-2167-08\tCN:BI" "/home/users/industry/chicago-university/meghan/GDC-Pipeline/GRCh38.d1.vd1.fa" "/home/users/industry/chicago-university/meghan/GDC-Pipeline/ST1-2-OUTPUT/Sample1/Normal/D12EJ.3_1.fq.gz" "/home/users/industry/chicago-university/meghan/GDC-Pipeline/ST1-2-OUTPUT/Sample1/Normal/D12EJ.3_2.fq.gz" | samtools view -Shb -o S1Norm.bam -