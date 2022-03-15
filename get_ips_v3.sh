#!/usr/bin/bash

# +-----------------------------------------------------+
# |                                                     |
# |       This script still needs to be optimized       |
# |                                                     |
# +-----------------------------------------------------+

#Usage function
usage() { echo "Usage: $0 [-e (env) <string>] [-s (save) <string>] [-c (cluster) <string>]" 1>&2; exit 1; }


#Initilizing constants
EXT=".json" 
REGION="eu-west-1"
PROFILE="ttp_dev"   # ttp_dev / 
OUTPUT_TYPE="table" # table / text / json


#Flags Proccessing
while getopts e:s:c: flag
do
    case "${flag}" in
        e) env=${OPTARG};;
        s) save=${OPTARG};;
        c) cluster=${OPTARG};;
        *) usage ;;
    esac
done


if [ ! "$env" ] && [ ! "$cluster" ]; then
    aws --profile $PROFILE \
    --region $REGION \
    ec2 describe-instances \
    --filters \
    "Name=tag-key,Values=Name" \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value,PrivateIpAddress:PrivateIpAddress}' \
    --output $OUTPUT_TYPE
elif [ ! "$env" ] && [ "$cluster" ]; then
    aws --profile $PROFILE \
    --region $REGION \
    ec2 describe-instances \
    --filters \
    "Name=tag-key,Values=Name" \
    "Name=key-name,Values=$cluster" \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value,PrivateIpAddress:PrivateIpAddress}' \
    --output $OUTPUT_TYPE
elif [ "$env" ] && [ ! "$cluster" ]; then
    aws --profile $PROFILE \
    --region $REGION \
    ec2 describe-instances \
    --filters \
    "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=$env" \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value,PrivateIpAddress:PrivateIpAddress}' \
    --output $OUTPUT_TYPE
else
    aws --profile $PROFILE \
    --region $REGION \
    ec2 describe-instances \
    --filters \
    "Name=tag-key,Values=Name" \
    "Name=key-name,Values=$cluster" \
    "Name=tag-value,Values=$env" \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value,PrivateIpAddress:PrivateIpAddress}' \
    --output $OUTPUT_TYPE
fi


# awsCmdExecution(){
#     aws --profile ttp_dev \
#     --region eu-west-1 \
#     ec2 describe-instances \
#     --filters \
#     "Name=tag-key,Values=Name" \
#     "Name=key-name,Values=$1" \
#     "Name=tag-value,Values=$2" \
#     --query 'Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key==`Name`]|[0].Value,PrivateIpAddress:PrivateIpAddress}' \
#     --output table
# }


#
#   @Author Anas TRAK.
#