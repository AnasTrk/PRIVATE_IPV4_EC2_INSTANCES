# PUBLIC_IPV4_EC2_INSTANCES

PYTHON SCRIPT

# GET_EC2_IPS

## _command_

command that returns ec2 instances ips in a dynamic manner.

### usage (get_ips_v2.py)

```python
py .\get_ips_v2.py --env prod
```

> **_Note_** :: This Script return only private Ip Adresse for a given **_RUNNING!!_** EC2 instance.
>
> Au cas d'erreur verifiez vous le nom d'instance donner et aussi que il est en etat Running.
> La command utiliser pour la récupération des donnees c'est :: 'aws ec2 describe-addresses'
>
> _Flags_ ::
> pour l'usage de la commande c'est comme suit : python .\get_ips_v2.py --env NOM_ENV [--save]
>
> [NOM_ENV] --> Nom d'environement (instance ec2)
> [--save] --> c'est optionnel pour le sauvgaurde d'adresse ip privée de l'instance sur un fichier
> pour change le nom du fichier , modifiez vous le constant FILE_NAME sur code .
>
> Merci.


### usage (get_ips_v3.sh)


#########################################################################################################
#                                       USAGE                                                           #
#   command :: get_ips_v3.sh [-e (env) <string>] [-s (save) <string>] [-c (cluster) <string>]           #
#                                                                                                       #
#                                                                                                       #
#   [-e] :: this flag allows you sepcify the environement you're searching for .                        #
#   [-s] :: this flag allows you save the output of command into a file (Not working yet just ignore)   #
#   [-c] :: you can specify the cluster name that the environement belongs to .                         #
#                                                                                                       #
#   the aws cli command used in this script is aws describe-instances                                   #
#   (Not like the one in get_ips_v2.py)                                                                 #
#########################################################################################################



>***_Give Execution permission to file ._***

```bash
chmod +x .\get_ips_v3.sh
```

>Run script

```bash
./get_ips_v3.sh  -e prod-front  -c prod-server [-s]
```