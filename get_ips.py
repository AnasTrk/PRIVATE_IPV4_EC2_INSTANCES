#!/usr/bin/python
import json

import subprocess
import sys
from os.path import exists
from time import sleep
import numpy as np

'''
@All initilizition below !!
'''
# load arguments values to a numpy array
args = np.array(sys.argv)

# define prefixes values
singlePrefix = '-'
doublePrefix = '--'

# load instances json format
with open('instances.json', 'w') as output_f:
    p = subprocess.Popen('aws ec2 describe-instances',
                         stdout=output_f, stderr=output_f)
    output_f.close()

sleep(2)

instancesFile = open('instances.json')
reservations = json.load(instancesFile)

# Iterating through the json instances
# list
instances = []
index = 0
for reservation in reservations['Reservations']:
    index = +1
    instances.insert(index, reservation['Instances'])
# print(instances);
# Closing instances file
instancesFile.close()

'''
Available commands
'''

if f'{doublePrefix}name' in args:
    index = np.where(args == f'{doublePrefix}name')[0][0]
    try:
        if args[(index + 1)]:
            for instance in instances:
                if instance[0]["KeyName"] == args[(index + 1)]:
                    print(
                        f"{instance[0]['KeyName'] } {instance[0]['InstanceId']} :: PublicIpAddress is {instance[0]['PublicIpAddress']}")
    except Exception:
        print(f'An error accured while excuting this commande please check --name')
