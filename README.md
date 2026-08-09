# outreach-lab

This is a set of scripts for spinning up an lab of VMs in AWS for use in Outreach activities.

## Setting up

First, login to AWS, this is how I currently start it, but...you may do it another way.

```bash
aws sso login
```

Create a file in the same directory `terraform.tfvars`

give it contents such as this

```
key_name        = "my-student-key"
ssh_public_key_path = "~/.ssh/my_student_lab_key.pub"
ssh_private_key_path = "~/.ssh/my_student_lab_key.pub"
dns_zone_id = "Z0330107OSB54ZK2JBIG"
dns_root_domain = "joesharpcs.co.uk"

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

## Checking the Machine manually

You may not need to do this, I used to have userData.sh with stuff in, but ansible is doing
all the heavy lifting now, so feel free to skip to that step.

### Getting instance ID

Once the VM is up, you can get the instance ID with

```
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output text
```

### Observing init logs

Get the logs with

```
aws ec2 get-console-output \
  --instance-id i-xxxxxxxxxxxxx \
  --query 'Output' \
  --output text
```

ssh on with

## Running ansible

Once the terraform has applied, it should have created an inventory in `ansible/inventory.ini` and the setup to connect in `ansible/group_vars/lab.yml`

```bash
ansible-playbook -i inventory.ini main.yml

# or to just run a specific sub part
ansible-playbook -i inventory.ini main.yml --tags dcv-session
```

## SSH Access to VM

Still useful, and I imagine doing this as the 'teacher' when the students are on the VM.

```
ssh -i ~/.ssh/<your key file> ubuntu@<ip address from stack>

# or if DNS resolution has worked (replace values as required)

ssh -i ~/.ssh/<your key file> ubuntu@student01.joesharpcs.co.uk
```

Then dump the init script logs with

```
sudo cat /var/log/cloud-init-output.log
```

## Provisioning HTTPS

Creating the certificate (the spec of folders is so you don't have to run as root)

```bash
certbot certonly \
  --manual \
  --key-type rsa \
  --preferred-challenges dns \
  --config-dir ~/.certbot \
  --work-dir ~/.certbot \
  --logs-dir ~/.certbot \
  -d "*.joesharpcs.co.uk"
```

Figure out AWS hosted zones

Ignore the "/hostedzone/" on the front of the ID.

```bash
aws route53 list-hosted-zones
```
