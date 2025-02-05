
flowchart TD
    %% GitHub Actions e ECR
    A[GitHub Actions<br/>(Build & Deploy Pipeline)] -->|Build & Push Image| B[ECR<br/>(Container Registry)]
    
    %% ECS Fargate e Deployment
    B -->|Trigger Deploy| C[ECS Fargate Service]
    
    %% VPC com subnets
    subgraph VPC[Virtual Private Cloud<br/>(10.0.0.0/16)]
      direction LR
      subgraph PUB[Public Subnet<br/>(10.0.1.0/24)]
        C
      end
      subgraph PRIV[Private Subnet<br/>(10.0.2.0/24)]
        D[RDS PostgreSQL]
      end
    end

    %% Acesso Externo
    E[Usuários / Internet] -->|Acesso via IP Público| PUB

    %% Comunicação interna
    PUB --- PRIV
