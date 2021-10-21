data "template_file" "api-shell-script" {
  template = file("scripts/user-data-api.sh")
  vars = {
    DBUSER = var.DBUSER
    DBPASS = var.RDS_PASSWORD
    DBHOST = aws_db_instance.postgres.address
    DB     = var.DB
    DBPORT = var.API_PORT  
    ELK_IP = aws_instance.elk-server.private_ip
  }
  depends_on = [
    aws_instance.elk-server
  ]
}

resource "aws_security_group" "api-instance" {
  vpc_id = aws_vpc.main.id
  name = "allow-ssh"
  description = "security group that allows all egress traffic"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = var.API_PORT
    to_port = var.API_PORT
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.allow_connection.id]
  }

  tags = {
    Name = "api-instance"
  }
}