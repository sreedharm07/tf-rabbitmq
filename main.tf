resource "aws_security_group" "main" {
  name        =  "${local.name_pre}-rabbitmq"
  description = "${local.name_pre}-rabbitmq"
  vpc_id      = var.vpc_id
  tags = merge(local.tags,{Name= "${local.name_pre}-rabitmq-sg"})

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.sg-ssh-ingress-cidr]
  }
  ingress {
    description      = "RABBITMQ"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = var.sg-ingress-cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_instance" "rabbitmq" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = var.subnet_id[0]
  tags                   = merge(local.tags, { Name = "${local.name_pre}" })
  user_data              = file("${path.module}/userdata.sh")
}

resource "aws_route53_record" "main" {
  zone_id = "Z09444252M01QG3Q8GZAK"
  name    =  "rabbitmq-${var.env}"
  type    = "CNAME"
  ttl     = 30
  records = [aws_instance.rabbitmq.private_ip]
}