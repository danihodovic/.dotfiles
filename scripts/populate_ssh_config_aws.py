#!/usr/bin/env python
'''
Reads aws instances and populates ~/.ssh/config with the IPs.
'''

import boto3
import os
from os.path import expanduser

ec2 = boto3.client('ec2')
home = expanduser('~')
ssh_config_file = '{}/.ssh/config'.format(home)
aws_profile = os.environ['AWS_PROFILE']

def instance_ssh_config(zone, ip):
    return '''
Host {profile}--{zone}--{ip}
    HostName {ip}
'''.format(profile=aws_profile, zone=zone, ip=ip)

ssh_lines = []
with open(ssh_config_file) as f:
    ssh_lines = f.readlines()

for reservation in ec2.describe_instances()['Reservations']:
    for instance in reservation['Instances']:
        zone = instance['Placement']['AvailabilityZone']
        ip = instance['PublicIpAddress']
        if not any([ip in line for line in ssh_lines]):
            with open(ssh_config_file, 'a') as f:
                f.write(instance_ssh_config(zone, ip))
