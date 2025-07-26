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

Once the VM is up, you can get the instance ID with
```
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output text
```

Get the logs with
```
aws ec2 get-console-output \
  --instance-id i-xxxxxxxxxxxxx \
  --query 'Output' \
  --output text | base64 --decode
```

ssh on with
```
ssh -i ~/.ssh/<your key file> ubuntu@<ip address from stack>
```

Then dump the init script logs with
```
sudo cat /var/log/cloud-init-output.log
```
