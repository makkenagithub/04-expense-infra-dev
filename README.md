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

Web ALP: (front end)

web-dev.daws81s.online

If we give

app-dev.dwas81s.online - it will repsond -> default resonse

backend.app-dev.dwas81s.online -> forward this request to backend target group

