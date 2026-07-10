# Ansible Docker Deployment for Wazuh

This repository contains an Ansible playbook that prepares a Ubuntu-based host for running a Wazuh Docker deployment.

## What the playbook does

The playbook performs the following on the target host:

- Installs required system packages such as Git, Make, Python tooling, and APT dependencies
- Adds the Docker APT repository and installs Docker Engine and Docker Compose plugins
- Installs the Python Docker SDK
- Clones the Wazuh Docker repository into `/opt/wazuh-docker`
- Runs the repository's Make-based workflow to bring up the stack

## Repository files

- `playbook.yml` - Main Ansible playbook
- `inventory.ini` - Target host inventory
- `requirements.txt` - Python dependencies for Ansible

## Prerequisites

- An Ubuntu-based target machine reachable over SSH
- An SSH key configured for authentication
- Python 3 and `pip` on the control machine

## Setup

1. Create and activate a Python virtual environment:

   ```bash
   python3 -m venv env
   source env/bin/activate
   ```

2. Install the required Python packages:

   ```bash
   pip install -r requirements.txt
   ```

3. Update the target host in `inventory.ini`:

   ```ini
   [docker_servers]
   YOUR_SERVER_IP ansible_user=YOUR_USERNAME
   ```

4. Ensure your SSH private key is available and referenced correctly in `inventory.ini`:

   ```ini
   [docker_servers:vars]
   ansible_ssh_private_key_file=~/.ssh/id_rsa
   ```

## Run the deployment

Run the playbook with:

```bash
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
```

## Using Ansible Vault

If you need to store sensitive values such as passwords or tokens, you can use Ansible Vault.

Create an encrypted file:

```bash
ansible-vault create vars.yml
```

Edit an existing encrypted file:

```bash
ansible-vault edit vars.yml
```
View an existing encrypted file:

```bash
ansible-vault view vars.yml
```

Run the playbook with a vault password prompt:

```bash
ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass
```

## Notes

- The current inventory uses `192.168.1.70` as the target host. Update it to match your environment.
- The playbook clones the Wazuh Docker repository from GitHub into `/opt/wazuh-docker`.
- If you need to customize the deployment, update the repository contents under `/opt/wazuh-docker` after the playbook finishes.
