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
8. create ASG (auto scaling group) using launch template and place it in target group
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

Terraform taint command is deprecated. Terraform recommends to use -replace command instead of taint

```
terraform apply -replace="aws_instance.example[0]"
```

The terraform taint command marks specified objects in the Terraform state as tainted. Use the terraform taint command when objects become degraded or damaged. Terraform prompts you to replace the tainted objects in the next plan you create.

This command is deprecated. Instead, add the -replace option to your terraform apply command.

Terraform target:

When you apply changes to your Terraform projects, Terraform generates a plan that includes all of the differences between your configuration and 
the resources currently managed by your project, if any. When you apply the plan, Terraform will add, remove, and modify resources as proposed by the plan.

In a typical Terraform workflow, you apply the entire plan at once. Occasionally you may want to apply only part of a plan, 
such as when Terraform's state has become out of sync with your resources due to a network failure, a problem with the upstream cloud platform, 
or a bug in Terraform or its providers. To support this, Terraform lets you target specific resources when you plan, apply, or destroy your infrastructure. 
Targeting individual resources can be useful for troubleshooting errors, but should not be part of your normal workflow.

You can use Terraform's -target option to target specific resources, modules, or collections of resources. 

```
terraform plan -target="module.s3_bucket"
terraform apply -target="random_pet.bucket_name"
```


To create/delete the resources 

for i in 10-vpc 20-sg 30-baston-ec2 40-rds 50-app-alb 60-vpn 70-backend; do cd $i ; terraform apply -auto-approve ; cd .. ; done

for i in 70-backend 60-vpn 50-app-alb 40-rds 30-baston-ec2 20-sg 10-vpc; do cd $i ; terraform destroy -auto-approve ; cd .. ; done

Target Group:

We need to give instances, target group name, protocol, port, health check protocol and path while creating target group.

Auto scaling group (ASG):

Input for auto scaling group involves launch template, target group arn, subnet IDs

Auto scaling policy:

Input is ASG name, scaling policy type (CPU utilisation etc)

create auto scaling policy with average CPU utilisation 70% as threshold.

Here if the avg cpu utilisation of 2 instances crosses 70% then 3rd instance will be created. If 3 instances average cpu util crosses 70% , then 4th instance created and so on.

If the average cpu util of 4 insatnces goes below 70%, then 4th instance will be terminated. Similarly if avg cpu util of 3 insatnces goes below 70% usage, then 3rd instance will be terminated.


Trafic flow:

Route 53 -> ALB -> listener -> Rule -> Traget group -> health check -> instance


Rolling update:

Assume we have 4 instances. Now a new version came in backend servers.

Rolling update will be as follows

Create a 1st new instance and once its healthy, delete one old instance

Then create 2nd new instance and delete one more old instance

Then create 3rd new instance and delete one more old instance and so on

Amazon certificate manager (ACM):

When the request comes from public, we need to use https for our domain name and not http.

Usual process to make our domain as https is we need ssl/tls certificate. We have certian cert providers, we need to request them. 

They provide some records and then we need add them to out domain in the domain provider such as hostinger/godaddy/route53.

If we have domain from route 53, then amazon provides the certificate and then we can add the records in our domain.

We did this using terraform in 75-acm directory












