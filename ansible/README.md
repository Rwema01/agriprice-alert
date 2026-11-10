# Ansible Configuration

This playbook uses Ansible Roles to ensure idempotency and clean code organization. 

## Usage
Run the playbook using the following command:
`ansible-playbook -i inventory.ini playbook.yml`

It installs Docker, configures UFW firewall rules, hardens SSH, and deploys the AgriPrice application container.