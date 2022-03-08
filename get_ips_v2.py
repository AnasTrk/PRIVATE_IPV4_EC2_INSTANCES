

import json
import subprocess
import sys
import numpy as np


'''
Initilizing ... 
'''

# load arguments values to a numpy array
args = np.array(sys.argv)

# define constants values


# Prefixes values
SINGLE_PREFIX = '-'
DOUBLE_PREFIX = '--'
# Avaialble command attributes
ENV = 'env'
# Filename and extension to save the result on a file.
FILE_NAME = 'addresses'
EXT = '.json'
# AWS CLI Command to return addresses
AWS_CMD = 'aws ec2 describe-addresses'


'''
Processing phase :)
'''

# The process that's going to execute the command :)
out = subprocess.Popen(AWS_CMD,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.STDOUT)
# Return the result of the command from stdout (subprocess PIPE).
stdout, stderr = out.communicate()

# load and decode the incoming json result to an indexed array.
addresses = json.loads(stdout.decode('utf-8'))

# check for --env flag
if f'{DOUBLE_PREFIX}{ENV}' in args:
    index = np.where(args == f'{DOUBLE_PREFIX}{ENV}')[0][0]
    try:
        if args[(index + 1)]:
            for addr in addresses['Addresses']:
                if args[(index + 1)] == addr['Tags'][0]['Value']:
                    print(
                        f"Public IP :: {addr['PublicIp']}")
    except Exception:
        print(f'An error accured while excuting this commande please check --env')
