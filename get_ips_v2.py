import json
import subprocess
import sys
import numpy as np


'''
Note :: This Script return only private Ip Adresse for a given RUNNING!!  EC2 instance.

Au cas d'erreur verifiez vous le nom d'instance donner et aussi que il est en etat Running.
La command utiliser pour la récupération des donnees c'est :: 'aws ec2 describe-addresses'

Flags :: 
    pour l'usage de la commande c'est comme suit : python .\get_ips_v2.py --env NOM_ENV [--save]

    [NOM_ENV]   --> Nom d'environement (instance ec2)
    [--save]    --> c'est optionnel pour le sauvgaurde d'adresse ip privée de l'instance sur un fichier 
                    pour change le nom du fichier , modifiez vous le constant FILE_NAME sur code .

    Merci.
'''


'''
Initilizing ... 
'''

# load arguments values to a numpy array
args = np.array(sys.argv)

# define constants values


# Prefixes values
SINGLE_PREFIX = '-'
DOUBLE_PREFIX = '--'


# Avaialble command attributes(flags)
ENV = 'env'
SAVE = 'save'


# Filename and extension to save the result on a file.(Here you can define the file name)
FILE_NAME = 'addresse'
EXT = '.json'


# AWS CLI Command to return addresses
AWS_CMD = 'aws ec2 describe-addresses'


'''
Processing phase :)
'''


try:
    # The process that's going to execute the command :)
    out = subprocess.Popen(AWS_CMD,
                           stdout=subprocess.PIPE,
                           stderr=subprocess.STDOUT)

    # Return the result of the command from stdout (subprocess PIPE).
    stdout, stderr = out.communicate()

    # load and decode the incoming json result to an indexed array.
    addresses = json.loads(stdout.decode('utf-8'))
except:
    print("Couldn't rettreive data from the process ---> Consider checking if aws cli works properly")

# check for --env flag
try:
    searchIpv4PrivateAddr = None
    searchIpv4Found = False
    if (DOUBLE_PREFIX+ENV) in args:
        index = np.where(args == (DOUBLE_PREFIX+ENV))[0][0]
        try:
            if args[(index + 1)]:
                for addr in addresses['Addresses']:

                    if args[(index + 1)] == addr['Tags'][0]['Value']:
                        print(f"Private IP :: {addr['PrivateIpAddress']}")
                        searchIpv4PrivateAddr = f"Private IP :: {addr['PrivateIpAddress']}"
                        searchIpv4Found = True

                if not searchIpv4Found:
                    print(
                        f'The searched ec2 instance --> {args[(index + 1)]} Not found :/')

        except Exception:
            print(f'An error accured while excuting this commande please check --env')

    if f'{DOUBLE_PREFIX}{SAVE}' in args:
        file = open('private_ip.json', 'w')
        file.write(json.dumps(searchIpv4PrivateAddr))
        file.close()
except:
    print(f'Something went wrong !!! ')
