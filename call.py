import json
import os
import shutil
import sqlite3

import parsl
from parsl.app.app import bash_app

from swag.core.readgroups import make_readgroup_dict

from apps import somaticsniper, muse, varscan, mutect2
from aspire import config
# from parsl.configs.local_threads import config

output_dir = 'analysis-v20'
reference = '/ime/users/industry/chicago-university/woodard/references/GRCh38.d1.vd1.fa'
known_sites = '/ime/users/industry/chicago-university/woodard/common_all_20180418.vcf.gz'
normal_panel = '/ime/users/industry/chicago-university/woodard/MuTect2.PON.4136.vcf.gz'
config.run_dir = os.path.join(output_dir, 'runinfo')

with open('ime.data.json') as f:
    data = json.load(f)

with open('executables.json') as f:
    executables = json.load(f)

if os.path.exists(output_dir):
    shutil.rmtree(output_dir)

parsl.set_stream_logger()
parsl.load(config)

for patient, bams in data.items():
    somaticsniper(
        executables,
        reference,
        bams['normal'],
        bams['tumor'],
        os.path.abspath(output_dir),
        label='{}-somaticsniper'.format(patient)
    )
    muse(
        executables,
        reference,
        bams['normal'],
        bams['tumor'],
        known_sites,
        os.path.abspath(output_dir),
        label='{}-muse'.format(patient)
    )
    varscan(
        executables,
        reference,
        bams['normal'],
        bams['tumor'],
        os.path.abspath(output_dir),
        label='{}-varscan'.format(patient)
    )
    mutect2(
        executables,
        reference,
        bams['normal'],
        bams['tumor'],
        os.path.abspath(output_dir),
        normal_panel,
        known_sites,
        label='{}-mutect2'.format(patient),
    )

parsl.wait_for_current_tasks()
