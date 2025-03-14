variable "filename" {
  type        = string
  default     = "foo.txt"
  description = "The name of the file to create."
}

variable "content" {
  type        = string
  default     = "Hello, World!"
  description = "The content of the file."
}
