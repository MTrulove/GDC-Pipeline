"""Configuration for running on ASPIRE 1.

NOTE: on ASPIRE 1, it is necessary to force compilation of the zmq bindings. First,
make sure that all versions of pyzmq are removed from the path. Then set up your
environment using anaconda3, installing pyzmq FIRST:
    conda create --name swag
    source activate swag
    pip install --no-binary pyzmq pyzmq
    cd Swag
    python setup.py install

Alternatively, you can run `python setup.py develop` instead of `python setup.py install`.

"""
import os

from parsl.providers import PBSProProvider
from parsl.launchers import MpiRunLauncher
from parsl.config import Config
from parsl.executors import HighThroughputExecutor
from parsl.addresses import address_by_hostname, address_by_interface
from parsl.monitoring.monitoring import MonitoringHub
import logging

# debug queue
nodes = 2
walltime ='02:00:00'
max_blocks = 1

# medium queue
nodes = 8
walltime ='24:00:00'
max_blocks = 1

config = Config(
    executors=[
        HighThroughputExecutor(
            label="htex",
            cores_per_worker=1,
            address=address_by_interface('ib0'),
            provider=PBSProProvider(
                launcher=MpiRunLauncher(),
                scheduler_options='#PBS -P 11001079',
                worker_init='module load gromacs; export PYTHONPATH={}:$PYTHONPATH'.format(os.path.abspath('.')),
                nodes_per_block=nodes,
                max_blocks=max_blocks,
                cpus_per_node=24,
                walltime=walltime
           ),
        ),
    ],
    monitoring=MonitoringHub(
        hub_address=address_by_interface('ib0'),
        hub_port=55055,
        logging_level=logging.INFO,
        resource_monitoring_interval=10,
    ),
    strategy='simple',
    retries=3
)

