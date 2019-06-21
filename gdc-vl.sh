mkdir -p ~/.local/bin

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

### muSE ver. rc_submission_c039ffa
wget -O /opt/bin/MuSEv1.0rc http://bioinformatics.mdanderson.org/Software/MuSE/MuSEv1.0rc_submission_c039ffa

### GATK ver. 3.5-5 GDC ver. nightly-2016-02-25gf39d340
conda install -c bioconda gatk-3.5-5

### dbSNP ver. 144
conda install -c bioconda bioconductor-snplocs.hsapiens.dbsnp144.grch38

