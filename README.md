# Features

* VSCode over SSH.
* Docker.
* zsh + oh-my-zsh.
* linuxbrew.
* node.js + nvm.
* Terraform.
* `aws` cli.
* `aws-vault`.
* tmux.
* git.
* auto-shutdown on inactivity.
* EBS encryption at rest.
* Expand disk when running low.
* Optional VNC desktop

# Why
* Your dev machine as code. Configure it the way you like, stand up new machines whenever you like.
* Provision more resources for your machine when needed.
* Work on the same environment from different computers. From your home PC, your laptop on the move - even mobile / tablet.
* Screwed up your dev environment? No biggie. Tear it down and create a new one.
* Create a machine in aws for fast access to cloud resources e.g. s3 / databases.
* Benefit from the speed of a cloud NIC - package installs / downloads very fast within datacenters.
* Avoid bloat and malicious packages being installed onto your real machine.

# Install

1. Install python:

        sudo apt install -y python3 python3-pip

2. Install terraform with homebrew or linuxbrew:

        brew install terraform

    Or download direct: https://learn.hashicorp.com/tutorials/terraform/install-cli

3. Install `aws-vault` for AWS authentication: https://github.com/99designs/aws-vault#installing

4. Fork this repo and clone locally. Then run:

    ```bash
    ./bin/setup
    ```

    This will install ansible and dependencies.

[Optional] set up vscode extensions:

  * ansible - https://marketplace.visualstudio.com/items?itemName=redhat.ansible
  * terraform - https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform

# Create new machine
```bash
cp .env.example .env
```

Set variables in .env, then:

```bash
aws-vault exec <your-profile> -- ./bin/create
```

**NOTE -**
These examples use [`aws-vault`](https://github.com/99designs/aws-vault#quick-start) for aws access. You can omit this if you use another method of authentication, or already have AWS credentials in your environment.

This will show you a preview of resources to set up in AWS and ask to confirm.

Once you confirm it will provision resources in aws and setup the machine.

# Run a playbook
```bash
[AS_USER=username] bin/playbook playbook-name [playbook args]
```
For example:

```bash
AS_USER=ubuntu bin/playbook inactivity --extra-vars ssh_port=15847
```

# Start & Stop
```bash
aws-vault exec <your-profile> -- ./bin/start
```

```bash
aws-vault exec <your-profile> -- ./bin/stop
```

# VNC tunnel
```bash
bin/vnc-tunnel
```

# Tear down
```bash
aws-vault exec <your-profile> -- ./bin/destroy
```

# Customise desktop
```bash
AS_USER=<your-user> ./bin/playbook xfwm4
```

# run a playbook on local machine
```bash
AS_USER=[user] bin/playbook-local [playbook] [--become --ask-become-pass] [playbook args]
```

# Best practises
* Spin up in a nearby region to minimise latency.
  * You may however wish to place it in a particular region (e.g. where your company has heavy data resources).
* Try to commit and push to github when you've finished making changes. It will reduce the risk of losing work if you have to tear down the machine.

# How it works

Terraform provisions machine resources, ansible installs and configures the machine.

Resources are defined in the `.tf` files.

`playbooks/` contains the ansible playbooks.

# VNC desktop
* Minimal XFCE desktop.
* Chromium browser.
* Firefox browser.
* 1password.
* Connect from mobile / tablet.

# IAM user
Used for starting and stopping the instance.
```bash
export AWS_ACCESS_KEY_ID="$(terraform output -raw access_key)"
export AWS_SECRET_ACCESS_KEY="$(terraform output -raw secret_key)"
```
