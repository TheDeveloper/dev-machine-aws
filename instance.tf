variable "ami_id" {
  description = "ami id"
  type        = string
}

variable "instance_type" {
  type        = string
  description = "ec2 instance type"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "subnet" {
  type        = string
  description = "subnet id"
}

variable "ssh_port" {
  type        = string
  description = "ssh port"
}

variable "kms_key_arn" {
  # aws/ebs
  # https://eu-west-2.console.aws.amazon.com/kms/home#/kms/defaultKeys/
  default = "arn:aws:kms:eu-west-2:<account-id>:key/<key-id>"
  type    = string
}

variable "vol_size" {
  type        = string
  description = "volume size"
}

resource "aws_instance" "instance" {
  lifecycle {
    ignore_changes = [
      # for some reason terraform thinks this changes
      associate_public_ip_address,
      root_block_device["volume_size"]
    ]
  }

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name

  vpc_security_group_ids = [
    aws_security_group.security_group.id,
  ]

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.kms_key_arn
    iops                  = 3000
    throughput            = 125
    tags = {
      Name = var.name
      role = var.name
    }
  }
}

resource "aws_security_group" "security_group" {
  name        = var.name
  description = var.name
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "all"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    ipv6_cidr_blocks = [
      "::/0"
    ]
  }
}

resource "aws_key_pair" "key" {
  key_name   = var.name
  public_key = file("./key.pub")
}

output "ip" {
  value = aws_instance.instance.public_ip
}

output "id" {
  value = aws_instance.instance.id
}

output "volume_id" {
  value = aws_instance.instance.root_block_device.0.volume_id
}
