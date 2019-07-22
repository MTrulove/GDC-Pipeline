#Step 1
#samtools mpileup -f "/home/users/industry/chicago-university/meghan/GDC-Pipeline/GRCh38.d1.vd1.fa" -q 1 -B "/home/users/industry/chicago-university/meghan/GDC-Pipeline/S5-OUTPUT/Sample1/Normal/S5S1Norm.bam" "/home/users/industry/chicago-university/meghan/GDC-Pipeline/S5-OUTPUT/Sample1/Tumor/S5S1Tumor.bam" > "/home/users/industry/chicago-university/meghan/GDC-Pipeline/Varscan-Output/intermediate_mpileup.pileup"

#Step 2
#java -jar "/home/users/industry/chicago-university/meghan/miniconda3/share/varscan-2.4.0-1/VarScan.jar" somatic "/home/users/industry/chicago-university/meghan/GDC-Pipeline/Varscan-Output/intermediate_mpileup.pileup" "/home/users/industry/chicago-university/meghan/GDC-Pipeline/Varscan-Output/VS-S1.vcf" --mpileup 1 --min-coverage 8 --min-coverage-normal 8 --min-coverage-tumor 6 --min-var-freq 0.10 --min-freq-for-hom 0.75 --normal-purity 1.0 --tumor-purity 1.00 --p-value 0.99 --somatic-p-value 0.05 --strand-filter 0 --output-vcf "/home/users/industry/chicago-university/meghan/GDC-Pipeline/Varscan-Output/VS-S1.vcf" 

#Step 3
java -jar "/home/users/industry/chicago-university/meghan/miniconda3/share/varscan-2.4.0-1/VarScan.jar" processSomatic "/home/users/industry/chicago-university/meghan/GDC-Pipeline/Varscan-Output/VS-S1.vcf" --min-tumor-freq 0.10 --max-normal-freq 0.05 --p-value 0.07