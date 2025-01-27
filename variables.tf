variable "filename" {
  type        = string
  default     = "example.txt"
  description = "The name of the file to create."
}

variable "content" {
  type        = string
  default     = "Hello, Terraform!"
  description = "The content of the file."
}
