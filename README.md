# outreach-lab

This is a set of scripts for spinning up an lab of VMs in AWS for use in Outreach activities.

## Running
Create a file in the same directory `terraform.tfvars`

give it contents such as this

```
key_name        = "my-student-key"
public_key_path = "~/.ssh/my_student_lab_key.pub"
ubuntu_ami      = "ami-019a63e66799737f9"  # Replace with real AMI ID
my_ip_cidr      = "<lookup your ip>"        # Your IP address for SSH access
```

You can get your IP with
```
curl https://checkip.amazonaws.com
```

You can get the AMI value with
```
aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
            "Name=architecture,Values=x86_64" \
            "Name=virtualization-type,Values=hvm" \
  --query "Images[*].[ImageId,Name]" \
  --output text | sort -k2
```

