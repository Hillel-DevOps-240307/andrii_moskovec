# get id instance
aws ec2 describe-instances
>     i-0d83c6755c72030bf

# set var instance_id
export INST_ID=i-0d83c6755c72030bf

# get id vpc
aws ec2 describe-vpc
>     vpc-0f527bdf4636aa964

# set var vpc_id
export VPC_ID=vpc-0f527bdf4636aa964

# get id public_subnet (Tags: "Value": "public-sub")
aws ec2 describe-subnets
>     subnet-0d6c740560312cda6

# get id private_subnet (Tags: "Value": "private-sub")
aws ec2 describe-subnets
>     subnet-055548cfcc2cbcb11

# set var public-sub & private-sub
export PUB_SUB_ID=subnet-0d6c740560312cda6
export PRIV_SUB_ID=subnet-055548cfcc2cbcb11

# get last ec2 ami
aws ssm get-parameters --name "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id" --output table
>     ami-0607a9783dd204cae

# set var  ami_id
export AMI_ID=ami-0607a9783dd204cae

# create security-groups
aws ec2 create-security-group \
    --group-name demo-sg \
    --description "AWS ec2 CLI Demo SG" \
    --tag-specification 'ResourceType=security-group,Tags=[{Key=Name,Value=demo-sg}]' \
    --vpc-id $VPC_ID

# get id security group demo-sg
aws ec2 describe-security-groups
>     sg-090cac993f1481ea0

# set var sec-group
export SG_ID=sg-090cac993f1481ea0

# create sg demo-web
aws ec2 create-security-group \
    --group-name demo-web-sg \
    --description "AWS ec2 CLI Demo web SG" \
    --tag-specification 'ResourceType=security-group,Tags=[{Key=Name,Value=demo-web-sg}, {Key=Project,Value=demo}]' \
    --vpc-id "$VPC_ID"
>     ###### "GroupId": "sg-05e840ecd80f360a9"

# set var demo-web-sg
export SG_WEB_ID=sg-05e840ecd80f360a9

# create sg demo-db
aws ec2 create-security-group \
    --group-name demo-db-sg \
    --description "AWS ec2 CLI Demo db SG" \
    --tag-specification 'ResourceType=security-group,Tags=[{Key=Name,Value=demo-db-sg}, {Key=Project,Value=demo}]' \
    --vpc-id "$VPC_ID"
>     ###### "GroupId": "sg-0872dd5d5a4e7aa1c"

# set var demo-db-sg
export SG_DB_ID=sg-0872dd5d5a4e7aa1c

# add inbound rules
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 22 \
    --cidr "0.0.0.0/0"
>     ###### "GroupId": "sg-090cac993f1481ea0"

aws ec2 authorize-security-group-ingress \
    --group-id "$SG_WEB_ID" \
    --protocol tcp \
    --port 80 \
    --cidr "0.0.0.0/0"
>     ##### "GroupId": "sg-099e34e9eb89cd13e"

aws ec2 authorize-security-group-ingress \
    --group-id "$SG_DB_ID" \
    --protocol -1 \
    --port -1 \
    --source-group $SG_DB_ID
>     ##### "GroupId": "sg-06f70c53037d9bf7d"




# create ec2 instance

## public
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name aws-mykey \
    --security-group-ids $SG_WEB_ID $SG_DB_ID \
    --subnet-id $PUB_SUB_ID \
    --block-device-mappings "[{\"DeviceName\":\"/dev/sdf\",\"Ebs\":{\"VolumeSize\":30,\"DeleteOnTermination\":false}}]" \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=demo-web-server}, {Key=Project,Value=demo}]' \
    --user-data file://~/HILL/andrii_moskovec/HomeWorks/hw-2/web.sh

## private
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name aws-mykey \
    --security-group-ids $SG_DB_ID \
    --subnet-id $PRIV_SUB_ID \
    --block-device-mappings "[{\"DeviceName\":\"/dev/sdf\",\"Ebs\":{\"VolumeSize\":30,\"DeleteOnTermination\":false}}]" \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=demo-db-server}, {Key=Project,Value=demo}]' \
#    --user-data file://db.sh
