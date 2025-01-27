provider "local" {}

resource "local_file" "example" {
  filename = var.filename
  content  = var.content
}
