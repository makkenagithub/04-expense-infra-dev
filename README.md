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

