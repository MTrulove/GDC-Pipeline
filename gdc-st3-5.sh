#step three
java -jar picard.jar SortSam CREATE_INDEX=true INPUT=<input.bam> OUTPUT=<output
.bam> SORT_ORDER=coordinate VALIDATION_STRINGENCY=STRICT

#step four
java -jar picard.jar MergeSamFiles ASSUME_SORTED=false CREATE_INDEX=true [INPUT
= <input.bam>] MERGE_SEQUENCE_DICTIONARIES=false OUTPUT=<output_path> SORT_ORDE
R=coordinate USE_THREADING=true VALIDATION_STRINGENCY=STRICT

#step five
java -jar picard.jar MarkDuplicates CREATE_INDEX=true INPUT =<input.bam> VALIDA
TION_STRINGENCY=STRICT
