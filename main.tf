resource "aws_key_pair" "auth_key" {

  key_name   = "${var.project_name}-${var.project_env}-publickey"
  public_key = file("shoppingapp.pub")
  tags = {
    Name = "${var.project_name}-${var.project_env}-publickey"
  }

}

resource "aws_security_group" "sg_freedom" {

  name        = "${var.project_name}-${var.project_env}-sgfrontend"
  description = "Allowing http and https access"

  ingress {

    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]


  }


  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]


  }

  egress {
    description = "Allowing all outgoing traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

  tags = {
    Name = "${var.project_name}-${var.project_env}-sgfrontend"

  }

}

resource "aws_instance" "shoppingapp_frontend" {

  ami                    = data.aws_ami.customami_latest.id
  instance_type          = var.itype
  key_name               = aws_key_pair.auth_key.key_name
  vpc_security_group_ids = [aws_security_group.sg_freedom.id]
  tags = {
    Name = "${var.project_name}-${var.project_env}"
    Project = var.project_name
    Environment = var.project_env
  }

}

resource "aws_route53_record" "frontend_record" {

  zone_id = var.hosted_zone_id
  name = "${var.hostname}.${var.hosted_zone_name}"
  type = "A"
  ttl = 100
  records = [aws_instance.shoppingapp_frontend.public_ip]

}
