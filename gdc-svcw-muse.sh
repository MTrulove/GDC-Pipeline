#MuSE Variant Call Command
#MuSE call
"/home/users/industry/chicago-university/meghan/miniconda3/bin/MuSE" MuSE call -f "/home/users/industry/chicago-university/meghan/GDC-Pipeline/GRCh38.d1.vd1.fa" -r "/home/users/industry/chicago-university/meghan/GDC-Pipeline/S5-OUTPUT/Sample1/Tumor/S5S1Tumor.bam" "/home/users/industry/chicago-university/meghan/GDC-Pipeline/S5-OUTPUT/Sample1/Normal/S5S1Norm.bam"  -O "/home/users/industry/chicago-university/meghan/GDC-Pipeline/MuSEOutput/MuSE-S1.txt"

#MuSE sump

#MuSe sump -I <intermediate_muse_call.txt> -E -D <dbsnp_known_snp_sites.vcf> -O <muse_variants.vcf>

#Note -E is used for WXS and -G for WGS data
