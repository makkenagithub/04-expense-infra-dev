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
