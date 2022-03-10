#!/usr/bin/bash




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


if [ ! "$env" ]; then
    aws ec2 describe-instances \
    --region eu-west-1 \
    --filters \
    "Name=tag-key,Values=Name" \
    "Name=key-name,Values=$cluster" \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value,PrivateIpAddress:PrivateIpAddress}' \
    --output table
else
    aws ec2 describe-instances \
    --region eu-west-1 \
    --filters \
    "Name=tag-key,Values=Name" \
    "Name=tag-value,Values=$env" \
    "Name=key-name,Values=$cluster" \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value,PrivateIpAddress:PrivateIpAddress}' \
    --output table
fi

