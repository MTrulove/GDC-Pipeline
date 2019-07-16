https://sourceforge.net/p/bio-bwa/mailman/message/35608412/mkdir -p ~/.local/bin
dir=$(mktemp -d)
cd "$dir"
### biobambam ver. 2.0.57
conda install -c bioconda biobambam=2.0.57
### bwa ver. 0.7.15
conda install -c bioconda  bwa=0.7.15
### samtools ver. 1.1
conda install -c bioconda samtools=1.1
### picard ver. 2.5.0
conda install -c bioconda picard=2.5.0
### somatic-sniper ver. 1.0.5.0
conda install -c bioconda somatic-sniper=1.0.5.0
### varscan ver. 2.4.0
conda install -c bioconda varscan=2.4.0
### GATK ver. 4.0.4.0
conda install -c bioconda GATK4=4.0.4.0

### samtools ver. 1.3.1
wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2
tar xaf samtools*
tar xaf samtools-1.3.1.tar.bz2

### muSE ver. rc_submission_c039ffa
wget /opt/bin/MuSEv1.0rc http://bioinformatics.mdanderson.org/Software/MuSE/MuSEv1.0rc_submission_c039ffa

### GATK ver. 3.5-5 GDC ver. nightly-2016-02-25gf39d340

conda install -c bioconda gatk=3.5-5

### dbSNP ver. 144
conda install -c bioconda bioconductor-snplocs.hsapiens.dbsnp144.grch38

### reference genome - GRCh38.d1.vd1
wget https://api.gdc.cancer.gov/data/254f697d-310d-4d7d-a27b-27fbf767a834
tar xvf 254f697d-310d-4d7d-a27b-27fbf767a834

### indexed reference genome - GRCh38.d1.vd1_BWA
wget https://api.gdc.cancer.gov/data/25217ec9-af07-4a17-8db9-101271ee7225
tar xvf 25217ec9-af07-4a17-8db9-101271ee7225