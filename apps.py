import os

import parsl
from parsl.app.app import bash_app

@bash_app
def bamtofastq(
        executables,
        filename,
        label=None,
        outputs=[],
        stderr=parsl.AUTO_LOGNAME,
        stdout=parsl.AUTO_LOGNAME):
    cmd = """
    printenv

    mkdir -p {output_dir}
    cd {output_dir}

    {bamtofastq} collate=1 exclude=QCFAIL,SECONDARY,SUPPLEMENTARY filename={filename} gz=1 inputformat=bam level=5 outputdir={output_dir} outputperreadgroup=1 outputperreadgroupsuffixF=_1.fq.gz outputperreadgroupsuffixF2=_2.fq.gz outputperreadgroupsuffixO=_o1.fq.gz outputperreadgroupsuffixO2=_o2.fq.gz outputperreadgroupsuffixS=_s.fq.gz tryoq=1 > /dev/null 

    """.format(
        output_dir=outputs[0],
        bamtofastq=executables['bamtofastq'],
        filename=filename
    )

    return cmd

@bash_app
def align_and_sort(
        executables,
        fastq_dir,
        rg_id,
        rg_line,
        reference,
        label=None,
        outputs=[],
        stderr=parsl.AUTO_LOGNAME,
        stdout=parsl.AUTO_LOGNAME):
    cmd = """
    average_depth=71 # FIXME speed up for testing

    if [ "$average_depth" -gt "70" ]; then
        {bwa} mem -t 8 -T 0 -R "{rg_line}" "{reference}" "{fastq_dir}/{rg_id}_1.fq.gz" "{fastq_dir}/{rg_id}_2.fq.gz" | {samtools} view -Shb -o {aligned_output} -
    else
        echo FIXME
    fi

    {java} -jar {picard} SortSam CREATE_INDEX=true INPUT={aligned_output} OUTPUT={sorted_aligned_output} SORT_ORDER=coordinate VALIDATION_STRINGENCY=STRICT

    """.format(
        fastq_dir=fastq_dir,
        samtools=executables['samtools'],
        bwa=executables['bwa'],
        reference=reference,
        rg_id=rg_id,
        rg_line=rg_line,
        aligned_output=outputs[0].replace('.sorted', ''),
        sorted_aligned_output=outputs[0],
        picard=executables['picard.jar'],
        java=executables['java']
    )

    return cmd

@bash_app
def merge_and_mark_duplicates(
        executables, 
        label=None,
        inputs=[], 
        outputs=[],
        stderr=parsl.AUTO_LOGNAME,
        stdout=parsl.AUTO_LOGNAME):
    merge_cmd = """

    {java} -jar {picard} MergeSamFiles ASSUME_SORTED=false CREATE_INDEX=true {inputs} MERGE_SEQUENCE_DICTIONARIES=false OUTPUT={merged} SORT_ORDER=coordinate USE_THREADING=true VALIDATION_STRINGENCY=STRICT

    """.format(
        java=executables['java'], 
        picard=executables['picard.jar'], 
        merged=outputs[0].replace('.bam', '.dupes.bam'),
        inputs=' '.join(['I={}'.format(x.filepath) for x in inputs])
    )
    if len(inputs) == 1: # cannot merge a single file
        merge_cmd = 'cp {merged} {output}'.format(merged=outputs[0].replace('.bam', '.dupes.bam'), output=outputs[0])

    cmd = """
    {merge_cmd}

    {samtools} view -o {cleaned}  -f 0x2 {merged}

    {java} -jar {picard} MarkDuplicates CREATE_INDEX=true I={cleaned} OUTPUT={output} M=S5S1TumorDup.txt VALIDATION_STRINGENCY=STRICT 
    """.format(
        merge_cmd=merge_cmd,
        java=executables['java'],
        picard=executables['picard.jar'],
        samtools=executables['samtools'],
        merged=outputs[0].replace('.bam', '.dupes.bam'),
        cleaned=outputs[0].replace('.bam', '.cleaned.dupes.bam'),
        output=outputs[0]
    )

    return cmd

@bash_app
def somaticsniper(
        executables, 
        reference,
        normal_bam,
        tumor_bam,
        output,
        label=None,
        stderr=parsl.AUTO_LOGNAME,
        stdout=parsl.AUTO_LOGNAME):
    cmd = """

    {somaticsniper} -q 1 -L -G -Q 15 -s 0.01 -T 0.85 -N 2 -r 0.001 -n NORMAL -t TUMOR -F vcf -f {reference} {tumor} {normal} {output}

    """.format(
        somaticsniper=executables['bam-somaticsniper'],
        reference=reference,
        tumor=tumor_bam,
        normal=normal_bam,
        output='{}/{}.vcf'.format(output, label)
    )

    return cmd

@bash_app
def muse(
        executables, 
        reference,
        normal_bam,
        tumor_bam,
        known_sites,
        output,
        label=None,
        stderr=parsl.AUTO_LOGNAME,
        stdout=parsl.AUTO_LOGNAME):
    cmd = """
      
    {muse} call -f {reference} {tumor} {normal} -O {call_output}
    {muse} sump -I {call_output}.MuSE.txt -E -D {known_sites} -O {sump_output}

    """.format(
        muse=executables['MuSE'],
        reference=reference,
        tumor=tumor_bam,
        normal=normal_bam,
        known_sites=known_sites,
        call_output='{}/{}'.format(output, label),
        sump_output='{}/{}.vcf'.format(output, label)
    )

    return cmd

@bash_app
def varscan(
        executables, 
        reference,
        normal_bam,
        tumor_bam,
        output,
        label=None,
        stderr=parsl.AUTO_LOGNAME,
        stdout=parsl.AUTO_LOGNAME):
    cmd = """

    {samtools} mpileup -f {reference} -q 1 -B {normal} {tumor} > {output}/intermediate_mpileup.pileup

    {java} -jar {varscan} somatic {output}/intermediate_mpileup.pileup {output}/varscan.vcf --mpileup 1 --min-coverage 8 --min-coverage-normal 8 --min-coverage-tumor 6 --min-var-freq 0.10 --min-freq-for-hom 0.75 --normal-purity 1.0 --tumor-purity 1.00 --p-value 0.99 --somatic-p-value 0.05 --strand-filter 0 --output-vcf {output}/varscan.vcf

    {java} -jar {varscan} processSomatic {output}/varscan.vcf.snp --min-tumor-freq 0.10 --max-normal-freq 0.05 --p-value 0.07

    """.format(
        samtools=executables['samtools'],
        java=executables['java'],
        varscan=executables['varscan.jar'],
        output=output,
        reference=reference,
        tumor=tumor_bam,
        normal=normal_bam
    )

    return cmd

@bash_app
def mutect2(
        executables,
        reference,
        normal_bam,
        tumor_bam,
        output,
        normal_panel,
        dbsnp,
        label=None,
        stderr=parsl.AUTO_LOGNAME,
        stdout=parsl.AUTO_LOGNAME):
    cmd = """

    {java} -jar {genomejar} -T MuTect2 -R {reference} -I:tumor {tumor} -I:normal {normal} --normal_panel {normal_panel} --dbsnp {dbsnp} --contamination_fraction_to_filter 0.02 -o {output} --output_mode EMIT_VARIANTS_ONLY --disable_auto_index_creation_and_locking_when_reading_rods

    """.format(
        java=executables['java'],
        genomejar=executables['GenomeAnalysisTK.jar'],
        normal_panel=normal_panel,
        dbsnp=dbsnp,
        output='{}/{}.vcf'.format(output, label),
        reference=reference,
        tumor=tumor_bam,
        normal=normal_bam
    )

    return cmd
