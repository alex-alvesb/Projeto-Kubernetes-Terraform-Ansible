import subprocess
import time

# Directories
TOFU_DIR = "path_to_file/projeto_k8s_tofu_ansible_github/tofu"
ANSIBLE_DIR = "path_to_file/projeto_k8s_tofu_ansible_github/ansible"
ANSIBLE_INVENTORY = f"{ANSIBLE_DIR}/hosts"
ANSIBLE_PLAYBOOK = f"{ANSIBLE_DIR}/master_playbook.yaml"

# Run Terraform (Tofu)
print("\U0001F680 Running Terraform (Tofu)...")
subprocess.run(["tofu", "init"], cwd=TOFU_DIR, check=True)
subprocess.run(["tofu", "apply", "-auto-approve"], cwd=TOFU_DIR, check=True)

# Wait for VM to be ready
print("⏳ Waiting for VM to be ready...")
time.sleep(30)  # Adjust as needed

# Run Ansible
print("\U0001F680 Running Ansible...")
subprocess.run(["ansible-playbook", "-i", ANSIBLE_INVENTORY, ANSIBLE_PLAYBOOK], cwd=ANSIBLE_DIR, check=True)

print("\U0001F389 Deployment completed successfully!")
