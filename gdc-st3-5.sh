#step three
java -jar "/home/users/industry/chicago-university/meghan/miniconda3/share/picard-2.5.0-2/picard.jar" SortSam CREATE_INDEX=true INPUT="/home/users/industry/chicago-university/meghan/GDC-Pipeline/S1Norm.bam" OUTPUT=S3S1Norm.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=STRICT

#step four
java -jar "/home/users/industry/chicago-university/meghan/miniconda3/share/picard-2.5.0-2/picard.jar" MergeSamFiles ASSUME_SORTED=false CREATE_INDEX=true I="/home/users/industry/chicago-university/meghan/GDC-Pipeline/S3S1Norm.bam" I="/home/users/industry/chicago-university/meghan/GDC-Pipeline/S3S1Norm.bam" MERGE_SEQUENCE_DICTIONARIES=false OUTPUT="/home/users/industry/chicago-university/meghan/GDC-Pipeline/ST4-OUPUT/Sample1/Normal/S1Norm.bam" SORT_ORDER=coordinate USE_THREADING=true VALIDATION_STRINGENCY=STRICT

#step five
java -jar "/home/users/industry/chicago-university/meghan/miniconda3/share/picard-2.5.0-2/picard.jar" MarkDuplicates CREATE_INDEX=true I="/home/users/industry/chicago-university/meghan/GDC-Pipeline/S3S1Norm.bam" OUTPUT="/home/users/industry/chicago-university/meghan/GDC-Pipeline/S5-OUPUT/Sample1/Normal/S5S1Norm.bam" M=S5S1NormDup.txt VALIDATION_STRINGENCY=STRICT

