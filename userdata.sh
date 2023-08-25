#!/bin/bash

yum install ansible -y  &>>/opt/userdata.log
ansible-pull -i localhost -u https://github.com/sreedharm07/roboshop-ansible.git -e component=rabbitmq
