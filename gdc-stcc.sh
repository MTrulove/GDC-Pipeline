#eq Co-Cleaning Command Line Parameters - Uses tumor and normal bam files
#Step one - RealignTargetCreator
java -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R "/home/users/industry/chicago-university/meghan/254f697d-310d-4d7d-a27b-27fbf767a834" -known <known_indels.vcf> [ -I <input.bam> ] -o <realign_target.intervals>

#Step two - IndelRealigner
java -jar GenomeAnalysisTK.jar -T IndelRealigner -R "/home/users/industry/chicago-university/meghan/254f697d-310d-4d7d-a27b-27fbf767a834" -known <known_indels.vcf> -targetIntervals <realign_target.intervals> --noOriginalAlignmentTags [ -I <input.bam> ] -nWayOut <output.map>

#Step three - BaseRecalibrator; dbSNP v.144
java -jar GenomeAnalysisTK.jar -T BaseRecalibrator -R "/home/users/industry/chicago-university/meghan/254f697d-310d-4d7d-a27b-27fbf767a834" -I <input.bam> -knownSites <dbsnp.vcf> -o <bqsr.grp>

#Step four - PrintReads
java -jar GenomeAnalysisTK.jar -T PrintReads -R "/home/users/industry/chicago-university/meghan/254f697d-310d-4d7d-a27b-27fbf767a834" -I <input.bam> --BQSR <bqsr.grp> -o <output.bam>

