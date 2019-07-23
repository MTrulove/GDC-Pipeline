#MuSE Variant Call Command
#MuSE call
"/home/users/industry/chicago-university/meghan/miniconda3/bin/MuSE" call -f "/home/users/industry/chicago-university/meghan/GDC-Pipeline/GRCh38.d1.vd1.fa" "/home/users/industry/chicago-university/meghan/GDC-Pipeline/ST4-OUPUT/Sample1/Tumor/S1Tumor.bam" "/home/users/industry/chicago-university/meghan/GDC-Pipeline/ST4-OUPUT/Sample1/Normal/S1Norm.bam" -O "/home/users/industry/chicago-university/meghan/GDC-Pipeline/MuSEOutput/MuSE-S1.txt"

#MuSE sump

"/home/users/industry/chicago-university/meghan/miniconda3/bin/MuSE" sump -I "/home/users/industry/chicago-university/meghan/GDC-Pipeline/MuSEOutput/MuSE-S1.txt" -E -D "/home/users/industry/chicago-university/meghan/GDC-Pipeline/common_all_20180418.vcf" -O "/home/users/industry/chicago-university/meghan/GDC-Pipeline/MuSEOutput/MuSE-S1variants.vcf"

#Note -E is used for WXS and -G for WGS data
