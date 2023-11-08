packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "cfpdx-web"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name             = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type = "ebs"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "cfpdx-web-ubuntu-20"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "./templates/cfpdxweb.config.template"
    destination = "/tmp/cfpdxweb.config"
  }

  provisioner "shell" {
    environment_vars = ["ENV=prod"]
    scripts          = ["./scripts/sysbootstrap.sh"]
  }

  provisioner "file" {
    source      = "./templates/sshconfig.template"
    destination = "/tmp/sshconfig"
  }

  provisioner "breakpoint" {
    disable = false
    note    = "ADD web_ssm_access IAM INSTANCE PROFILE TO EC2 IN AWS CONSOLE TO CONTINUE..."
  }

  provisioner "shell" {
    environment_vars = ["ENV=prod"]
    scripts          = ["./scripts/appbootstrap.sh"]
  }
}
