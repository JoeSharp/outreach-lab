provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "dcv_sg" {
  name        = "student-dcv-sg"
  description = "Allow SSH and NICE DCV access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NICE DCV Web Access Standard Port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "dcv-lab-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "dcv_license_access" {
  name        = "dcv-lab-license-access"
  description = "Allow EC2 to fetch DCV License from S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
           "Effect": "Allow",
           "Action": "s3:GetObject",
           "Resource": "arn:aws:s3:::dcv-license.eu-west-2/*"
       }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dcv_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.dcv_license_access.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "dcv-lab-profile"
  role = aws_iam_role.ec2_role.name
}

module "student_lab" {
  source = "./student_machine"
  for_each = toset(var.students)

  security_group_id = aws_security_group.dcv_sg.id
  instance_type     = var.instance_type
  student_name      = each.key
  key_name          = aws_key_pair.student_key.key_name
  instance_profile  = aws_iam_instance_profile.ec2_profile.name

  providers = {
    aws = aws
  }
}

resource "aws_route53_record" "student_dns" {
  for_each = module.student_lab

  zone_id = var.dns_zone_id
  name    = "${each.key}.${var.dns_root_domain}"
  type    = "A"
  ttl     = 60

  records = [each.value.public_ip]
}
