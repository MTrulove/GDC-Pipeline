import json
import os
import shutil
import sqlite3

import parsl
from parsl.app.app import bash_app

from swag.core.readgroups import make_readgroup_dict

import apps
from aspire import config
# from parsl.configs.local_threads import config
# from local import config

output_dir = 'analysis-v14'
reference = '/home/projects/11001079/anna/GDC-Pipeline/references/GRCh38.d1.vd1.fa'
known_sites = '/home/projects/11001079/anna/GDC-Pipeline/common_all_20180418.vcf.gz'
config.run_dir = os.path.join(output_dir, 'runinfo')

# db = sqlite3.connect('data.db')
# db.execute("""create table if not exists data(
#     output_dir text,
#     start int,
#     end int,
#     caller,
#     patient,
#     tumor_size,
#     normal_size
#     )""")
# db.commit()
# db.close()

with open('data.json') as f:
    data = json.load(f)

with open('executables.json') as f:
    executables = json.load(f)

if os.path.exists(output_dir):
    shutil.rmtree(output_dir)

parsl.set_stream_logger()
parsl.load(config)

for patient, bams in data.items():
    apps.somaticsniper(
            executables, 
            reference,
            bams['normal'],
            bams['tumor'],
            os.path.abspath(output_dir),
            label='{}-somaticsniper'.format(patient)
    )
    # apps.muse(
    #         executables, 
    #         reference,
    #         bams['normal'],
    #         bams['tumor'],
    #         known_sites,
    #         os.path.abspath(output_dir),
    #         label='{}-muse'.format(patient)
    # )

    # apps.varscan(
    #     executables, 
    #     reference,
    #     bams['normal'],
    #     bams['tumor'],
    #     os.path.abspath(output_dir),
    #     label='{}-varscan'.format(patient)
    # )

parsl.wait_for_current_tasks()         
