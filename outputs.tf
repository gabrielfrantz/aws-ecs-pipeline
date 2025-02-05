output "subnet_public_id" {
  description = "ID da subnet pública criada na AWS"
  value       = aws_subnet.public.id
}

output "subnet_private_id" {
  description = "ID da subnet privada criada na AWS"
  value       = aws_subnet.private.id
}