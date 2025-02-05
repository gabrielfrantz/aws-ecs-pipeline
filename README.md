# GitHub Actions - Build, Push e Deploy no ECS da AWS

Este repositório contém uma pipeline configurada no GitHub Actions para realizar o build e push de uma imagem Docker para o ECR (Elastic Container Registry) da AWS, e o deploy para o ECS (Elastic Container Service).

#Arquitetura do projeto

![image](https://github.com/user-attachments/assets/aae64d15-f715-40f3-8687-9511adb0f5e5)

## Funcionalidades

- **Build da imagem Docker**
- **Push para o ECR (Elastic Container Registry) da AWS**
- **Deploy automatizado para o ECS (Elastic Container Service)**

### Ajustando as Secrets no Repositório do GitHub
1. **Crie as seguintes secrets e vá preenchendo conforme o andamento do projeto**
   - AWS_ACCESS_KEY_ID=Sua key da AWS
   - AWS_SECRET_ACCESS_KEY=Sua secret da AWS
   - AWS_ACCOUNT_ID=Sua account id da AWS
   - AWS_KEY_PUB=Sua chave pública da máquina local
   - AWS_REGION=Região
   - ECS_TASK_DEFINITION=Nome da sua definição de tarefa do ECS
   - ECS_SERVICE_NAME=Nome do seu serviço do ECS
   - ECS_CLUSTER_NAME=Nome do cluster do ECS
   - ECR_REPOSITORY=Nome completo do seu repositório ECR
   - ECS_EXECUTION_ROLE_ARN=Valor do ARN da role criada (ecsTaskExecutionRole)
   - ECS_TASK_ROLE_ARN=Valor do ARN da role criada (ecsTaskRole)
   - DB_HOST=Nome do host do seu RDS
   - DB_NAME=Nome da database inicial criada no RDS
   - DB_PASSWORD=Senha do usuário do RDS
   - DB_USER=Usuário do RDS
   - DB_PORT=Porta do banco de dados

![image](https://github.com/user-attachments/assets/7ec34782-90b2-4e9c-9ec5-31f3881e97ad)

### Criar um bucket manualmente na AWS (Privado)
1. Crie um bucket privado na AWS.
2. Atualize o arquivo `main.tf`, configurando o nome do bucket no bloco `backend "s3"` para armazenar o estado remoto do Terraform.

![image](https://github.com/user-attachments/assets/47c640d0-7897-45c9-bdff-8d92f83856ca)

### Executando a Pipeline
1. Clone o repositório, ajuste as secrets e crie o bucket conforme os passos anteriores.
2. Acesse a aba **Actions** no repositório.
3. Selecione o workflow `terraform plan-apply` para iniciar a criação da infraestrutura.
4. Aguarde a conclusão do processo.

![image](https://github.com/user-attachments/assets/d23fdb0a-c4f3-4c35-a4a8-91f174d80ee6)

## Opcional - Destruir Toda a Infraestrutura

1. Execute o workflow `terraform destroy` na aba **Actions**.
2. Exclua o bucket criado manualmente.
3. Delete a Service Account utilizada.

---

### Criar um Repositório no ECR (Elastic Container Registry) da AWS
1. Escolha um nome para o repositório.
2. Mantenha o restante das opções como padrão.
- OBS: O número que antecede o `.dkr.ecr.sa-east-1.amazonaws.com` é o valor da sua secret AWS_ACCOUNT_ID

![image](https://github.com/user-attachments/assets/e19cda46-ff41-462a-824e-5ddc8fc084a3)

### Crie seu banco de dados no RDS da AWS
1. Selecione o mecanismo (postgresql, mysql, etc)
2. Adicione o identificador da instância
3. Crie o nome do usuário principal
4. Crie uma senha
5. Altere a VPC para a sua VPC criada pelo Terraform
6. Altere o grupo de segurança da VPC para o grupo que foi criado para o RDS
7. Em configuração adicional, coloque o nome da database inicial

![image](https://github.com/user-attachments/assets/efebee0a-48df-472a-a861-8640c8a531c4)

### Criando roles/funções necessárias
1. Acessar o IAM > roles/funções > criar
2. Em **Select trusted entity**, escolha **AWS service**.
4. Em **Use case**, selecione **Elastic Container Service** e escolha **ECS Task**.
5. Na próxima tela, selecione a política gerenciada **AmazonECSTaskExecutionRolePolicy**. Essa política já inclui as permissões necessárias para puxar imagens do ECR, enviar logs ao CloudWatch, entre outras.
6. Dê um nome ao role, por exemplo, `ecsTaskExecutionRole`.
7. Finalize e crie o role.
8. Após criado, copie o ARN do role para usar na sua task definition (secret `ECS_EXECUTION_ROLE_ARN`).
9. Acessar o IAM > roles/funções > criar
10. Em **Select trusted entity**, escolha **AWS service**.
11. Em **Use case**, selecione **Elastic Container Service** e escolha **ECS Task**.
12. Na próxima tela, selecione a política gerenciada **AmazonRDSFullAccess**.
13. Dê um nome ao role, por exemplo, `ecsTaskRole`.
14. Finalize e crie o role.
15. Após criado, copie o ARN do role para usar na sua task definition (secret `ECS_TASK_ROLE_ARN`).

![image](https://github.com/user-attachments/assets/67face18-96df-4829-91b2-22b3d18c7574)

### Crie o cluster no ECS (Elastic Container Service) da AWS
1. Crie o nome do cluster
2. Selecione o tipo de infraestrutura AWS Fargate (sem servidor)
3. Clique em criar
4. Clique em definições de tarefa
5. Dê um nome a família de definição de tarefa
6. Selecione o tipo de inicialização como AWS Fargate
7. Ajuste o tamanho e recurso da sua infraestrutura (CPU, Memória, SO)
8. Coloque o nome do container `ecs-frontend-container`
9. Coloque a URI da imagem do seu repositório ECR (Elastic Container Registry)
10. Coloque a porta do container como 5000
11. Adicione as varivéis de ambiente do seu banco de dados
- DB_HOST
- DB_NAME
- DB_PASSWORD
- DB_USER
- DB_PORT
12. Depois disso, vá no seu cluster criado, acesso ele e clique em Serviços > Criar
13. Selecione o provedor Fargate
14. Tipo de aplicação colocar serviço (container fica rodando sem parar)
15. Selecionar a família criada na definição de tarefa anteriormente
16. Adicionar um nome ao serviço
17. Número de replicas (tarefas) = deixar 1
18. Na aba redes, alterar para a VPC criada
19. Deixar as duas subnets (privada e pública)
20. Selecionar o grupo de segurança da ECS criado
21. Deixar marcado a opção de ativado para o IP Público (para conseguir acessar a aplicação externamente)

![image](https://github.com/user-attachments/assets/7ef18abc-4508-4424-8878-d0dab2ae22f9)
![image](https://github.com/user-attachments/assets/1810cb04-5787-48de-a243-35f8c462595e)
![image](https://github.com/user-attachments/assets/93f25731-b685-4b55-8d94-854f2a067824)

### Após cada deploy, as replicas/tarefas serão atualizadas e substituidas por novas, conforme a nova imagem da aplicação hospedada no ECR

![image](https://github.com/user-attachments/assets/e731d76e-b55b-4af5-9657-040ffd2bdcf3)
