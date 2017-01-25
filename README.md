# Terraform and Ansible playbooks for deployment of Atlassian Bamboo server

Terraform is used for creating EC2 instance using AMI built by Packer, VPC configuration, Security Groups and RDS instance (Postgres)

Ansible is used for installing Bamboo

## Terraform usage

Install Terraform downloaded from [this website](https://terraform.io)

Place it in your `$PATH` variable for ease of use. You might also like [this Makefile](https://github.com/gstlt/dotfiles/tree/master/hashicorp) which will install also Packer if you want it to.

You will need API keys to AWS to be able to use it. MFA + AssumeRole is not covered here.

To use the variables without passing it or typing every time you need to run Terraform:
```
export TF_VAR_aws_access_key=ACCESSKEY
export TF_VAR_aws_secret_key=SECRETKEYWHICHISVERYLONGSTRING
```

Validating template:
```
cd repository/terraform
terraform verify
```

Check what would Terraform do if ran right now:
```
cd repository/terraform
terraform plan
```

To check what would be removed and how to destroy whole infrastructure (Dangerous! Duh!):
```
cd repository/terraform
terraform plan -destroy
terraform destroy
```

Before running Terraform
* create SSL certificate to be used on Load-Balancer (ELB)
* update certificate name in `./terraform/bamboo-ec2.tf` file (search for mysuperdomain)
* update ssh public key to access the EC2 instance (yes, you will need secret key too) - see terraform/ssh-keypairs.tf
* update your IP address to be able to SSH into machine: `./terraform/security-groups.tf`

How to request certificate documentation can be found [on this web page](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-request.html)

## How Ansible comes into play

We could use a Terraform provisioner found [here](https://github.com/jonmorehouse/terraform-provisioner-ansible) to do everything in one step, but such complication wasn't needed at this point.

After running Terraform, you will be able to actually deploy something to the server you've just started.

Before you start you will also need to update domain under which Bamboo will be visible. This is going to be template for nginx configuration placed in `./ansible-bamboo-master/templates/nginx-bamboo.j2` file. (also something to be parametrized later)

Do install Bamboo Server, invoke following after updating `inventory_prod` file with public IP address of EC2 server:
```
ansible-playbook playbook.yaml -i inventory_prod
```

If everything go well, you should be able to access Bamboo over Load-Balancer URL. You might want to add some Route53 records for your own domain later.

## Bamboo configuration

In order to make sure Bamboo installation won't redirect us to http and different host name, we will need to update configuration. This manual step has been left to develop this a bit faster as this was a temporary solution for me. Adding more parameters however might be added later.

Log in to server with ssh and navigate to `/opt/atlassian/bamboo-5.14.4.1/conf`

If you open server.xml file and scroll down to Catalina connectors configuration, you'll find something like this:

```
        <Connector
            protocol="HTTP/1.1"
            port="8085"

            maxThreads="150" minSpareThreads="25"
            connectionTimeout="20000"
            disableUploadTimeout="true"
            acceptCount="100"

            enableLookups="false"
            maxHttpHeaderSize="8192"

            useBodyEncodingForURI="true"
            URIEncoding="UTF-8"

            redirectPort="8443"

            proxyName="bamboo.mysuperdomain.com"
            proxyPort="443"
            scheme="https"
            />
```

See the last three lines: `proxyName`, `proxyPort` and `scheme`.

* `proxyName` - external domain
* `proxyPort` - port to which Catalina will redirect (you can have https running on 8002 port using this)
* `scheme` - this determine if you want to use http or https

## Testing locally

Terraform need to be tested on AWS, so just scroll up for a quick introduction how to create and destroy environments.

To test Ansible, you'll need installed Vagrant and Ansible on your local computer.

Testing:
```
vagrant up
```

This should download Vagrant box and run Ansible playbook that will install nginx and Bamboo for you. Use `vagrant ssh` to log in to the machine and investigate configuration.

To remove the machine, run `vagrant destroy` and confirm destroying this VM

## Conclusion

I know it's not an ideal solution and there are couple of quirks I will need to get rid of, but it's been developed just to avoid lock-in after Atlassian cancelled Bamboo cloud and it's a temporary solution for moving to other CI. Most likely I won't work on this anytime soon, but you're welcome to send pull requests if you have some improvements. Thanks!

