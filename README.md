# 04-expense-infra-dev
stateful vs stateless

stateful - which has state .i.e data

stateless - which dont have data

DB - stateful, it keeps track of data

backend/frontend - stateless

If DB server crashes we cant recover. So backup neds to taken.

DB:

backup -> hourly/daily/weekly

Restore test

data replication -> Assue 2 DBs. DB1 is connected to app. But DB2 is not connected to app. But it replicates data from DB1

DB - storage increment, load balancing

All the above things like storage increment / load balancing can be done with cloud provider. RDS.

RDS - load balancing, auto storage increment, backups/snapshots.

Its difficult to create EC2 and install DB in ec2 etc. We donot do RDS installations in EC2 instances.

So we create a RDS resource from cloud provider.


When a terraform module is changed, then we need to give init upgrade command to get the module coe updated.

terraform init upgrade

Load balancing and Auto scalng:

We have 2 types of LBs. One is internet facing aand other is not facing internet.

target group, load balancer, listener and rules, health check

Target group: contains a lst of servers.

Load balancer: container listener and rules. It checks target group servers health every (say 10 secs) time , based on the time we set.

The LB flow is like below:

First request comes to LB listener -> port 80 (nginx) -> nginx -> port 80 -> 2 target insances -> LB will check instances helath -> sends the request to health server. (if all target servers are healthy , then select a server randomly)

1. first create target group
2. launch servers and add to target group
3. create LB, listener and rules.

Auto Scaling:

1. Launch template (options to create servers) -> plac them inside target group
2. Based on CPU utilisation

![Capture](https://github.com/user-attachments/assets/ee84b798-70d6-4ef0-a664-87c8eeae13f3)

1. Project infra: basement to a house -> no frequesnt changes, only rare changes
2. Application infra: frequent changes - yes

Project infra:

1. VPC - not changes frequently
2. SG - SG may not change, but rules may change frequently
3. Bastion host - no frequent changes
4. DB - No frequent chnages. (probably once in 2 years upgrade)
5. LB - no changes frequently

Application Infra:

1. EC2 instances
2. target groups

We have 3 types of LBs in AWS

1. Classic LB
2. Application LB - we are working on it
3. Network LB

host path based:

backend.daws81s.online -> backend LB

frontend.daws81s.online -> frontend LB

Application LB - It works on layer 7 of networking

Context path based:

daws81s.online/backend

daws81s.online/frontend



Application LB: (backend applications)

app-dev.dwas81s.online

Web ALB: (front end)

web-dev.daws81s.online

If we give

app-dev.dwas81s.online - it will repsond -> default resonse

backend.app-dev.dwas81s.online -> forward this request to backend target group

I think PORT FOR LB is 80 (please check)

VPN:

user laptop -> VPN -> can access secure servers

and company can monitor our traffic

Dedicted team will be there for VPN in companies. Devops team no need to worry on VPN.

Search for "OpenVPN Access Server Community Image-f" in EC2 launch instance. Create EC2 with that.

This AMI contains open VPN server is already installed and configured.

Once we launch thid EC2, we need to do little configuration to make our expence project connection with VPN instead of Bastion.

VPN ports are - 943, 443, 1194, 22 - 22 is for ssh access

command to generate key pair
```
ssh-keygen -f openvpn
```

command to connect to the above open VPN server 
```
ssh -i <private key filename> openvpnas@<public IP of vpn server>
```
openvpnas is a default user in open vpn AMI server.

Then it asks for lot of things.
Initially give yes, and then press enter to make all values as default. In between it asks for user name password. Give a user name (openvpn) and a password of min 8 chars and remember it.

Finally it provides admin UI url and client UI url.

Open admin url and giver the user name and password. Then change some vpn settings.

Install open vpn connect. Open it and give client url there
Here also give the username and password as above. Then click import.



![Capture](https://github.com/user-attachments/assets/6adb5818-978e-4773-944f-6b7ba5e3d19a)



New Deployments:

If there is a new version, stop the server, remove old code, download new code and restart the server.

or

Create ec2, configure using ansible, stop instance, take AMI (launch template), launch it using auto scaling. 

When traffic increases , use AMI to add servers.

If there is traffic increase - create new ec2, configure with backend.


Its not good to take AMI when the instance is running, because we may get lot of descripencies. At the time  of taking AMI, if some using in the background using the server and may create/update/delete data. Hence it always better to take the AMI after stopping the instance.

1. Create ec2
2. configure it using ansible
3. stop server
4. take AMI -> with new version
5. delete ec2 instance of step 1
6. create launch templetae (it contains ami, network ,sg etc)
7. create target group
8. create ASG using launch template and place it in target group
9. then create rule in load balancer.

Ansible push: We have ansible server. We install packages in ansible nodes with the help of ansible server. 

Ansible push: If we want to install packages in a node, then install ansible in that node, then pull ansible palybooks from git, then run palybooks locally. Its ansible pull. Ansible is light weight.


Null Resource and Trigger:

Null resource - It wont do anything, means it wont create any resource. But useful for provisioners

Null resource is used to connect to EC2 insatnce through provisioners. We can use to run some bootstrap scripts to run on the created EC2s

Provisioners will run only when the resource is created. If we want to run tthe provisoners, then the resource need to be recreated. So we can use taint command to force recreate the resource.

```
terraform taint null_resource.backend
```
So the resource is tainted. Then run terraform plan and apply, It creates the resource again.

When a resource is tainted , then terraform will rerun that resource. 

Terraform creates the resources paralely which do not have dependency. To make some resource to create after a resource is created, then we have to depends on block in the resource.


