# Note: by default `*.tfvars` files are not tracked by git 
# but for the purpose of demonstration I make an exception here

# The `terraform.tfvars` file does not need to be specified with -var-file; 
# any other *.tfvars file will need to be specified with -var-file
# in other words:
# terraform plan 
# = 
# terraform plan -var-file="./terraform.tfvars"

filename = "foo.txt"
content  = "Hello, World from Foo!"
