#Mutect2
#Panel of Normals Creation
#java -jar "/home/users/industry/chicago-university/meghan/miniconda3/bin/GenomeAnalysisTK.jar" -T MuTect2 -R "/home/users/industry/chicago-university/meghan/GDC-Pipeline/GRCh38.d1.vd1.fa" -I:tumor "/home/users/industry/chicago-university/meghan/GDC-Pipeline/S5-OUTPUT/Sample1/Tumor/S5S1Tumor.bam" -I:normal "/home/users/industry/chicago-university/meghan/GDC-Pipeline/S5-OUTPUT/Sample1/Normal/S5S1Norm.bam" --dbsnp "/home/users/industry/chicago-university/meghan/GDC-Pipeline/common_all_20180418.vcf" [--cosmic COSMIC.vcf][-L targets.interval_list] -o output.vcf

#Variant Calling
java -jar "/home/users/industry/chicago-university/meghan/miniconda3/bin/GenomeAnalysisTK.jar" -T MuTect2 -R "/home/users/industry/chicago-university/meghan/GDC-Pipeline/GRCh38.d1.vd1.fa" -I:tumor "/home/users/industry/chicago-university/meghan/GDC-Pipeline/ST4-OUTPUT/Sample1/Tumor/S1Tumor.bam" -I:normal "/home/users/industry/chicago-university/meghan/GDC-Pipeline/ST4-OUTPUT/Sample1/Normal/S1Norm.bam" --cosmic "/home/users/industry/chicago-university/meghan/GDC-Pipeline/CosmicCoding.vcf" --dbsnp "/home/users/industry/chicago-university/meghan/GDC-Pipeline/common_all_20180418.vcf" --contamination_fraction_to_filter 0.02 -o "/home/users/industry/chicago-university/meghan/GDC-Pipeline/MUTECT-OUTPUT/mutect_variants.vcf" --output_mode EMIT_VARIANTS_ONLY --disable_auto_index_creation_and_locking_when_reading_rods