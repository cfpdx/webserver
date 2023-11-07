# Running Packer for AMI Creation

This README provides instructions for running Packer to create an Amazon Machine Image (AMI) using the provided configuration.

## Prerequisites

Before running Packer, make sure you have the following prerequisites in place:

1. **Packer Installed:** Ensure you have Packer installed on your local machine. You can download it from the [Packer website](https://www.packer.io/).

2. **AWS Account:** You should have an AWS account and the necessary AWS credentials (access key and secret key) configured on your machine. If you haven't set up AWS credentials, you can do so using the AWS CLI with the `aws configure` command.

3. **Required Plugins:** Make sure you have the required Packer plugin for Amazon EC2 (Amazon EBS) installed. If it's not already installed, you can install it using the `packer init .` command.

## Running Packer
You can update the Packer configuration in the provided .hcl file according to your specific requirements.
Build the AMI:

Run the following Packer command to validate the Packer template:
`packer validate aws-ec2-ubuntu.pkr.hcl`

Run the following Packer command to run the Packer template:
`packer build aws-ec2-ubuntu.pkr.hcl`


---
**Important**

Follow instructions in AWS Console when Packer build hits breakpoint. Use prefabricated `web_ssm_access` role to allow provisioning EC2 access to ssm. Failure to do so will cause deployment error and incorrect AMI configuration.

---
