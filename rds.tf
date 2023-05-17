resource "aws_db_subnet_group" "db_subnet_group" {
  name = "mysql-db-subnet-group"
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = var.rds_username
  password             = var.rds_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}

output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}
