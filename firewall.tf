# Security Group para a aplicação ECS
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main.id

  # Permitir acesso HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir acesso HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir tráfego de entrada da VPC (mesma rede ou subnet)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Pode ser mais restritivo
  }

  # Permitir tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-security-group"
  }
}

# Security Group para o RDS PostgreSQL
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  # Permitir tráfego na porta 5432 (PostgreSQL) vindo do Security Group da aplicação ECS
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]  # Permite tráfego do grupo de segurança ECS
  }

  # Permitir tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}