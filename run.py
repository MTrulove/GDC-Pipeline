import json
import os
import shutil

import parsl
from parsl.app.app import bash_app

from swag.core.readgroups import make_readgroup_dict

import apps
from aspire import config

output_dir = 'analysis-v9'
reference = '/home/projects/11001079/anna/GDC-Pipeline/references/GRCh38.d1.vd1.fa'
known_sites = '/home/projects/11001079/anna/GDC-Pipeline/common_all_20180418.vcf.gz'
config.run_dir = os.path.join(output_dir, 'runinfo')

with open('data.json') as f:
    data = json.load(f)

with open('executables.json') as f:
    executables = json.load(f)

if os.path.exists(output_dir):
    shutil.rmtree(output_dir)
os.makedirs(os.path.join(output_dir, 'fastq'))

parsl.set_stream_logger()
parsl.load(config)


for patient, bams in data.items():
    merged_bams = {}
    for tissue in ['tumor', 'normal']:
        read_groups = make_readgroup_dict(bams[tissue], executables['samtools'])
        aligned_bams = []
        head, tail = os.path.split(bams[tissue])
        fastq_dir = apps.bamtofastq(
            executables,
            bams[tissue],
            label=patient,
            outputs=[os.path.join(os.path.abspath(output_dir), 'fastq', tail.replace('.bam', ''))]
        ).outputs[0]
        for rg_id, rg_line in read_groups.items():
            output = os.path.join(
                    os.path.abspath(output_dir), 
                    tail.replace('.bam', '{}.sorted.aligned.bam'.format(rg_id))
            )
            aligned_bams.append(apps.align_and_sort(
                executables,
                fastq_dir,
                rg_id,
                rg_line.replace('\t', '\\t'), 
                reference, 
                label=patient, 
                outputs=[output]
                ).outputs[0]
            )
        output = os.path.join(os.path.abspath(output_dir), tail.replace('.bam', '.merged.bam'))
        merged_bams[tissue] = apps.merge_and_mark_duplicates(
            executables,
            label=patient,
            inputs=aligned_bams,
            outputs=[output]
        ).outputs[0]

    apps.somaticsniper(
            executables, 
            reference,
            merged_bams['normal'],
            merged_bams['tumor'],
            os.path.abspath(output_dir),
            label='{}-somaticsniper'.format(patient)
    )

    apps.muse(
            executables, 
            reference,
            merged_bams['normal'],
            merged_bams['tumor'],
            known_sites,
            os.path.abspath(output_dir),
            label='{}-muse'.format(patient)
    )

    apps.varscan(
        executables, 
        reference,
        merged_bams['normal'],
        merged_bams['tumor'],
        os.path.abspath(output_dir),
        label='{}-varscan'.format(patient)
    )

parsl.wait_for_current_tasks()         
