#https://sourceforge.net/p/bio-bwa/mailman/message/35608412/mkdir -p ~/.local/bin
dir=$(mktemp -d)
cd "$dir"

conda create --name gdc
source activate gdc

### biobambam ver. 2.0.57 - version causes segmentation faults when converting file with multiple readgroups
#conda install -y -c bioconda biobambam=2.0.57

### biobambam ver. 2.0.87 -updated to most recent version
conda install -y -c bioconda biobambam=2.0.87

### bwa ver. 0.7.15
conda install -y -c bioconda  bwa=0.7.15
### samtools ver. 1.1
conda install -y -c bioconda samtools=1.1
mv $CONDA_PREFIX/bin/samtools $CONDA_PREFIX/bin/samtools-1.1
### picard ver. 2.5.0
conda install -y -c bioconda picard=2.5.0
### somatic-sniper ver. 1.0.5.0
conda install -y -c bioconda somatic-sniper=1.0.5.0
### varscan ver. 2.4.0
conda install -y -c bioconda varscan=2.4.0

### GATK ver. 4.0.4.0
# only used in tumor-only workflow
# conda install -y -c bioconda GATK4=4.0.4.0

### samtools ver. 1.3.1
wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2
tar xaf samtools-1.3.1.tar.bz2
cd samtools-1.3.1
./configure --prefix=$CONDA_PREFIX
make
make install

### muSE ver. rc_submission_c039ffa -dockerized version used by GDC
# wget /opt/bin/MuSEv1.0rc http://bioinformatics.mdanderson.org/Software/MuSE/MuSEv1.0rc_submission_c039ffa

### MuSE ver. 1.0
conda install -y -c bioconda muse=1.0.rc

### GATK ver. 3.5-5 GDC ver. nightly-2016-02-25gf39d340
#FIXME: does not give GenomeAnalysis.tk file due to licensing
#conda install -y -c bioconda gatk=3.5


### dbSNP ver. 144 - currently does not work
#wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/hg38/

### alternative to dbSNP currently being used
wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/GATK/common_all_20180418.vcf.gz

### bcftools
conda install -c bioconda bcftools tabix

### tool for bgzipping alternative dbSNP file
bcftools view common_all_20180418.vcf -Oz -o common_all_20180418.vcf.gz
tabix common_all_20180418.vcf.gz
add common


cd -
mkdir cosmic-files
cd cosmic-files

### Cosmic.vcf - Catalogue Of Somatic Mutations In Cancer
### Make account here: https://cancer.sanger.ac.uk/cosmic
### Follow scripted directions to download vcf files for coding and non-coding mutations
### https://cancer.sanger.ac.uk/cosmic/file_download_info?data=GRCh38%2Fcosmic%2Fv89%2FVCF%2FCosmicCodingMuts.vcf.gz
### https://cancer.sanger.ac.uk/cosmic/file_download_info?data=GRCh38%2Fcosmic%2Fv89%2FVCF%2FCosmicNonCodingVariants.vcf.gz

### Combining Cosmic vcf files
conda install -c bioconda vcftools

vcf-concat CosmicCodingMuts.vcf.gz CosmicNonCodingVariants.vcf.gz | gzip -c  > CosmicCoding.vcf.gz

vcf-sort > CosmicCoding.vcf.gz

cd -
mkdir references
cd references

### reference genome - GRCh38.d1.vd1
wget https://api.gdc.cancer.gov/data/254f697d-310d-4d7d-a27b-27fbf767a834 -O GRCh38.d1.vd1.fa.tar.gz
tar xvf GRCh38.d1.vd1.fa.tar.gz

### indexed reference genome - GRCh38.d1.vd1_BWA
wget https://api.gdc.cancer.gov/data/25217ec9-af07-4a17-8db9-101271ee7225 -O GRCh38.d1.vd1_BWA.tar.gz
tar xvf GRCh38.d1.vd1_BWA.tar.gz

### creating index (fai) and dictionary (dict) files
samtools faidx GRCh38.d1.vd1.fa

java -jar picard.jar CreateSequenceDictionary R= GRCh38.d1.vd1.fa  O= GRCh38.d1.vd1.dict
