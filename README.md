# outreach-lab

This is a set of scripts for spinning up an lab of VMs in AWS for use in Outreach activities.

## Running

Create a file in the same directory `terraform.tfvars`

give it contents such as this

```
key_name        = "my-student-key"
ssh_public_key_path = "~/.ssh/my_student_lab_key.pub"
ssh_private_key_path = "~/.ssh/my_student_lab_key.pub"
```

I used to need these, but they are derived now by the my_ip_cidr and ubuntu_ami modules.

```
#ubuntu_ami      = "ami-0224ce6f9504665ee"  # Replace with real AMI ID
#my_ip_cidr      = "<lookup your ip>"        # Your IP address for SSH access
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
  --output text

# Used to need this on the end, doesn't seem to now
   | base64 --decode
```

ssh on with

```
ssh -i ~/.ssh/<your key file> ubuntu@<ip address from stack>
```

Then dump the init script logs with

```
sudo cat /var/log/cloud-init-output.log
```

## Running Terraform

Inside the `terraform` directory.

```bash
# Run once to sort out the backend
terraform init

# See what will be run
terraform plan

# Actually do the business
terraform apply
```

## Running ansible

Once the terraform has applied, it should have created an inventory in `ansible/inventory.ini` and the setup to connect in `ansible/group_vars/lab.yml`

```bash
ansible-playbook -i inventory.ini ping.yml
```
