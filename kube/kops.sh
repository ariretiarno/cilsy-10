#!/bin/bash
##notes
#requirement tools
#1. Install Kops
#2. Install Kubectl
#3. Install AWS cli
#
#requirement aws
#3. Persiapkan s3 bucket
#4. persiapkan IAM User kops
#5. Persiapkan Iam group kops
#6. Attach Policies ke Group
#
#requirement DNS
#1. buat Hosted Zones di AWS
#2. Setting NS record

export KOPS_STATE_STORE=s3://kubernetes.retiarno.my.id
export KOPS_CLUSTER_NAME=kubernetes.retiarno.my.id

kops create cluster --node-count=1 --node-size=t2.micro --master-size=t2.micro --zones=us-east-2a --name=${KOPS_CLUSTER_NAME} --ssh-public-key=~/.ssh/id_rsa.pub --cloud=aws

kops update cluster --name kubernetes.retiarno.my.id --yes --admin

kops validate cluster --wait 10m