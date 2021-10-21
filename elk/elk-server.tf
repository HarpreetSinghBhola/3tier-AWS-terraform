# Provisioning ELK EC2 server
resource "aws_instance" "elk-server" {
    instance_type = "t2.medium"
    ami           = lookup(var.AMIS, var.region)
    key_name      = var.keyname
    subnet_id     = aws_subnet.main-public-1.id
    associate_public_ip_address = true
    security_groups = [aws_security_group.allow_connection.id]
    tags = {
        Name   = "ELK Server"
    } 
}

# Null resource for configuring ELK server. 
resource "null_resource" "provision-server"{
    
    triggers = {
        always_run = timestamp()
    }

    connection{
        type = "ssh"
        host = aws_instance.elk-server.public_ip
        user = var.INSTANCE_USERNAME
        private_key = file("pem-file/${var.keyname}.pem") 
    }
    
    provisioner "file"{
        source = "Scripts-elk/elkSetup.sh"
        destination = "/tmp/elkSetup.sh"
    }
    
    provisioner "file"{
        source = "Scripts-elk/generateElaticsearchProperties.sh"
        destination = "/tmp/generateElaticsearchProperties.sh"
    }
    
    provisioner "file"{
        source = "ConfigFiles/02-beats-input.conf"
        destination = "/tmp/02-beats-input.conf"
    }
    
    provisioner "file"{
        source = "ConfigFiles/12-json.conf"
        destination = "/tmp/12-json.conf"
    }
    
    provisioner "file"{
        source = "ConfigFiles/30-output.conf"
        destination = "/tmp/30-output.conf"
    }

    provisioner "file"{
        source = "Scripts-elk/generateKibanaProperties.sh"
        destination = "/tmp/generateKibanaProperties.sh"
    }
    
    provisioner "local-exec" {
      command = "sleep 5"
    }
    
    provisioner "remote-exec"{
        inline = [
                    "chmod +x /tmp/elkSetup.sh",
                    "sudo sh /tmp/elkSetup.sh"
        ]
    }
    
    depends_on = [
        aws_instance.elk-server
    ]
    
}

data "http" "myip"{
    url = "https://ipv4.icanhazip.com"
}

resource "aws_security_group" "allow_connection" {
    name        = "allow_connection"
    description = "Allow all traffic to ELK server"
    vpc_id = aws_vpc.main.id

    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    }
    ingress {
        from_port   = 5601
        to_port     = 5601
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
      
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [aws_vpc.main.cidr_block]
    }
      
    ingress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = "true"
    }
      
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

output "server_instance_public_ip_addr" {
    value = aws_instance.elk-server.public_ip
}

output "server_instance_private_ip_addr" {
    value = aws_instance.elk-server.private_ip
}

output "SSH-Login-ELKServer-command" {
    value = "ssh -i ${var.keyname} ${var.INSTANCE_USERNAME}@${aws_instance.elk-server.public_dns}"
}

output "Kibana-interface" {
    value = "http://${aws_instance.elk-server.public_ip}:5601"
}