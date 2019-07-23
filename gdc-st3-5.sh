#step three
java -jar "/home/users/industry/chicago-university/meghan/miniconda3/share/picard-2.5.0-2/picard.jar" SortSam CREATE_INDEX=true INPUT="/home/users/industry/chicago-university/meghan/GDC-Pipeline/S1Tumor.bam" OUTPUT=S3S1Tumor.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=STRICT

#step four
java -jar "/home/users/industry/chicago-university/meghan/miniconda3/share/picard-2.5.0-2/picard.jar" MergeSamFiles ASSUME_SORTED=false CREATE_INDEX=true I="/home/users/industry/chicago-university/meghan/GDC-Pipeline/S3S1Tumor.bam" I="/home/users/industry/chicago-university/meghan/GDC-Pipeline/S3S1Tumor.bam" MERGE_SEQUENCE_DICTIONARIES=false OUTPUT="/home/users/industry/chicago-university/meghan/GDC-Pipeline/ST4-OUPUT/Sample1/Tumor/S1Tumor.bam" SORT_ORDER=coordinate USE_THREADING=true VALIDATION_STRINGENCY=STRICT

#step five
java -jar "/home/users/industry/chicago-university/meghan/miniconda3/share/picard-2.5.0-2/picard.jar" MarkDuplicates CREATE_INDEX=true I="/home/users/industry/chicago-university/meghan/GDC-Pipeline/S3S1Tumor.bam" OUTPUT="/home/users/industry/chicago-university/meghan/GDC-Pipeline/S5-OUTPUT/Sample1/Tumor/S1-5-tumor.bam" M=S5S1TumorDup.txt VALIDATION_STRINGENCY=STRICT

