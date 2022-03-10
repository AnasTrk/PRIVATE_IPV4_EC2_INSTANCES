#!/usr/bin/bash



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
usage() { echo "Usage: $0 [-e (env) <string>] [-s (save) <string>] [-c (cluster) <string>]" 1>&2; exit 1; }


#Initilizing =
    #Constants
EXT=".json" 
REGION="eu-west-1"
while getopts e:s:c: flag
do
    case "${flag}" in
        e) env=${OPTARG};;
        s) save=${OPTARG};;
        c) cluster=${OPTARG};;
        *) usage ;;
    esac
done

aws ec2 describe-instances \
    --region $REGION 
    --filters   Name=tag-key,Values=Name \
                Name=key-name,Values=$cluster \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value,PrivateIpAddress:PrivateIpAddress}' \
    --output table 
