Entendido! Sem problemas. Aqui está o README ajustado para o provisionamento na Azure.

IaC - Trabalho Terraform e Ansible

Este projeto demonstra o uso de Terraform e Ansible para automatizar o provisionamento e a configuração de infraestrutura na Azure.

O Terraform é utilizado para criar a infraestrutura base (Máquina Virtual, Grupos de Segurança de Rede, IP Público, etc.), e o Ansible é responsável por configurar o software dentro dessa VM (neste caso, instalar a aplicação Nginx).

🏗️ Estrutura do Projeto

O repositório está dividido em duas pastas principais: terraform e ansible.

iac-trabalho-terraform-ansible/
│
├── ansible/
│   ├── hosts.sample      # Modelo para o inventário de hosts do Ansible
│   ├── playbook.yml      # Playbook principal que define as tarefas (ex: instalar Nginx)
│   └── requirements.yml  # (Opcional) Dependências de roles do Ansible
│
├── terraform/
│   ├── main.tf           # Definição principal dos recursos Azure (VM, NSG, VNet)
│   ├── outputs.tf        # Define as saídas (ex: IP público da VM)
│   ├── variables.tf      # Declaração de todas as variáveis
│   └── variables.tfvar.sample # Modelo para os valores das variáveis
│
├── .gitignore            # Ignora arquivos gerados pelo terraform e arquivos com credenciais
├── projeto_rsa.pub       # Chave SSH pública
└── README.md             # Este arquivo

⚙️ Configuração Prévia

Antes de executar o projeto, você precisa se autenticar na Azure e configurar os arquivos de variáveis e inventário.

1. Autenticação na Azure

A forma mais simples de autenticar o Terraform é via Azure CLI.

    Instale o Azure CLI.

    Execute o comando de login e siga as instruções no navegador:
    Bash

az login

O Terraform usará automaticamente essas credenciais.

2. Terraform (variables.tfvar)

O Terraform precisa saber as especificações da infraestrutura (como localização, tamanho da VM, etc.).

    Navegue até o diretório terraform/:
    Bash

cd terraform

Copie o arquivo de exemplo:
Bash

    cp variables.tfvar.sample variables.tfvar

    Edite o arquivo variables.tfvar com seus dados.

Exemplo de terraform/variables.tfvar:
Terraform

# Configuração do Grupo de Recursos e Localização
location      = "northcentralus"  # região recomendada
resource_group_name = "rg-meu-trabalho-iac"

# Configuração da Máquina Virtual
vm_size       = "Standard_B2s"
admin_username = "azureuser" # Usuário para acessar a VM

# IMPORTANTE: Forneça o caminho para sua CHAVE PÚBLICA SSH
# O Terraform vai ler o conteúdo deste arquivo e injetá-lo na VM
admin_ssh_key_path = "~/.ssh/id_rsa.pub" 

3. Ansible (hosts)

O Ansible precisa de um inventário (hosts) que liste os servidores onde ele deve atuar. O IP deste arquivo será obtido após a execução do Terraform.

    Navegue até o diretório ansible/:
    Bash

cd ansible

Copie o arquivo de exemplo:
Bash

    cp hosts.sample hosts

    Você ainda não vai editar este arquivo. Você precisará do IP gerado pelo Terraform no próximo passo.

O arquivo hosts deverá ser preenchido da seguinte forma (após o Terraform rodar):
Ini, TOML

[azure_vm]
# Substitua X.X.X.X pelo IP público da VM
# Substitua o usuário e o caminho da chave privada
X.X.X.X ansible_user=azureuser ansible_ssh_private_key_file=~/.ssh/id_rsa

Pontos importantes:

    ansible_user: Deve ser o mesmo admin_username que você definiu no variables.tf.

    ansible_ssh_private_key_file: Deve ser o caminho local no seu computador para a chave privada (id_rsa) correspondente à chave pública que você usou no Terraform.

🚀 Como Executar o Projeto

Siga estes passos na ordem correta.

Passo 1: Provisionar a Infraestrutura (Terraform)

    Acesse a pasta terraform:
    Bash

cd terraform

Inicialize o Terraform (só precisa fazer isso na primeira vez):
Bash

terraform init

Verifique o plano de execução (o que o Terraform vai criar):
Bash

terraform plan

Aplique a infraestrutura (crie os recursos na Azure):
Bash

    terraform apply

    Confirme digitando yes quando solicitado.

Outputs:

public_ip_address = "X.X.X.X" 

    Este é o ip que será usado no próximo passo.

Passo 2: Configurar o Inventário (Ansible)

    Agora, vá para a pasta ansible/:
    Bash

    cd ../ansible

    Edite o arquivo hosts (que você criou na seção de Configuração).

    Substitua X.X.X.X pelo public_ip_address que o Terraform retornou.

Passo 3: Configurar o Servidor (Ansible)

Execute o playbook para configurar o servidor (instalar o Nginx):
Bash

    ansible-playbook -i inventory/hosts playbook.yml

Pronto! Após a execução, você pode acessar http://X.X.X.X no seu navegador e deverá ver a página de boas-vindas do Nginx.

🧹 Limpeza (Destroy)

Para destruir todos os recursos criados na Azure e evitar custos, volte à pasta do Terraform e execute:

    Acesse a pasta terraform:
    Bash

cd ../terraform

Execute o comando destroy:
Bash

terraform destroy

Confirme digitando yes.