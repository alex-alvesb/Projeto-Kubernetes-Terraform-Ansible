# 🖥️ Kubernetes Cluster with Terraform + Ansible Deployment Guide in vSphere

Automatize a criação e configuração de **cluster Kubernetes** (com 5 máquinas) utilizando **Terraform (Open-Tofu)** e **Ansible**. 

## **Passos**

### **1️⃣ Inicializar o Terraform**
```sh
cd path_to_file/projeto_k8s_tofu_ansible/tofu
tofu init
```

### **2️⃣ Criar e executar o script de deploy**
Crie o arquivo `deploy.py`:
```sh
nano path_to_file/projeto_k8s_tofu_ansible/deploy.py
```
Adicione o conteúdo do script
[Documentação do script](https://github.com/alex-alvesb/Projeto-Kubernetes-Terraform-Ansible/blob/main/deploy.py)

Torne o script executável e rode:
```sh
chmod +x path_to_file/projeto_k8s_tofu_ansible/deploy.py
path_to_file/projeto_k8s_tofu_ansible/deploy.py
```

## **Agora seu ambiente está pronto! 🖥️**


### Para destruir a infraestrutura criada
```sh
cd path_to_file/projeto_k8s_tofu_ansible/tofu
tofu destroy -auto-approve
```
