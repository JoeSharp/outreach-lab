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
           "Resource": "arn:aws:s3:::dcv-license.region/*"
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

resource "aws_instance" "student_vm" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "student-desktop"
  }
}
