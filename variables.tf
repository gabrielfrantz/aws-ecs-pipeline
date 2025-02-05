variable "region" {
    type = string
    description = "Região da AWS"
    default = "sa-east-1"
}

variable "aws_key_pub" {
  type        = string
  description = "Chave pública para a máquina da AWS"
}