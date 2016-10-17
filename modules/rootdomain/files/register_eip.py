#!/usr/bin/python
# This script will assign an EIP

AWS_ACCESS_KEY_ID = "AKIAJP4JPICIDF7QVQIQ"
AWS_SECRET_ACCESS_KEY = "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"

EIP = "50.19.101.216"

import urllib
from boto import ec2
from boto import utils

instances = [urllib.urlopen("http://169.254.169.254/latest/meta-data/instance-id").read()]
ec2conn = ec2.connection.EC2Connection(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
instance = ec2conn.get_all_instances(instance_ids=instances)[0].instances[0]
user_data = utils.get_instance_userdata()

if user_data == "rootdomain":
    ec2conn.associate_address(instance.id, EIP)
