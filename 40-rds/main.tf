module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.resource_name  #expense-dev

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 5 # 5 GB

  db_name  = "transactions"
  username = "root"
  manage_master_user_password = false
  password = "ExpenseApp1"
  port     = "3306"

# below param set to true. It will not create snapshot before deleting RDS db.
# by default its false in the module. By default it creates final snap before deleting DB and attach to VPC.
# if snap s attached to VPC, we cant delete VPC. Just for practice purpose , we are setting true
  skip_final_snapshot = true

  #iam_database_authentication_enabled = true

  vpc_security_group_ids = [local.mysql_sg_id]

  tags = merge(
    var.common_tags,
    var.rds_tags
  )

  # DB subnet group
  #create_db_subnet_group = true
  #subnet_ids             = ["subnet-12345678", "subnet-87654321"]

  db_subnet_group_name = local.database_subnet_group_name

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  #deletion_protection = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
