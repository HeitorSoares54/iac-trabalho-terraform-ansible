variable "resource_group_name" {
  description = "O nome do seu grupo de recursos sandbox (ex: rg-a123456)."
  type        = string
}

variable "location" {
  description = "A região do Azure onde seus recursos serão criados."
  type        = string
}

variable "vm_size" {
  description = "Tamanho da VM."
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Nome de usuário do administrador da VM."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Caminho para a chave pública SSH a ser usada para autenticação na VM."
  type        = string
}