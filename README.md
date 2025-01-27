# Introduction to Terraform

Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp. It allows you to define and manage infrastructure resources (such as virtual machines, networks, and storage) using a high-level configuration language. Terraform is platform-agnostic and works with multiple cloud providers, including Azure, AWS, and Google Cloud.

## Key Concepts of Terraform

### 1. Providers

Providers are responsible for interacting with the APIs of cloud platforms or other services. Each provider manages specific types of resources. For Azure, the provider is `azurerm`.

```hcl
provider "azurerm" {
  features {}
}
```

> Author's note: provider is what allows Terraform to abstract the underlying APIs, eliminating the need for "consumers" to understand the underlying APIs, as we only have to understand Terraform and HCL.

### 2. Resources

Resources are the fundamental building blocks of Terraform. They define the infrastructure components you want to create, such as virtual machines, storage accounts, or networks.

Example of an Azure resource:

```hcl
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}
```

> Author's note: in Terraform any "deployment" is a resource. And if you compare this resource - in this case a `resource group` - to for example a `local file` (as you can see in the demo latter in this document) you can see that they are following a very similar pattern: they have a "type" (e.g. `azurerm_resource_group`) and a "name" (e.g. `example`) and a few properties which are usually key-value pairs.
> Sure, things can go complex quickly - for example using inputs/outputs from modules, loops and object maps, but the principle is the same!

### 3. Variables

Variables allow you to parameterize your configuration and make it reusable. You can define variables in a separate file (e.g., `variables.tf`) and provide values in a `terraform.tfvars` file or directly in the command line.

```hcl
variable "location" {
  description = "The Azure region to deploy resources into."
  default     = "East US"
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = var.location
}
```

### 3.1 Locals

Locals allow you to define reusable values within your Terraform configuration. Unlike variables which are meant for external input, locals are computed values used internally in your configuration. They help reduce repetition and make your code more maintainable.

Example of using locals:

```hcl
locals {
  common_tags = {
    environment = "production"
    project     = "demo"
    owner       = "team-infrastructure"
  }
  
  resource_prefix = "${var.project_name}-${var.environment}"
}

resource "azurerm_resource_group" "example" {
  name     = "${local.resource_prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "example" {
  name                = "${local.resource_prefix}storage"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  tags                = local.common_tags
}
```

> Author's note: the `locals` block is a great way to reduce repetition in your Terraform code. It allows you to define reusable values that can be used throughout your configuration. This can help make your code more readable and maintainable.

### 4. Outputs

Outputs allow you to extract useful information from your Terraform configuration, such as IP addresses or resource IDs, to use elsewhere.

```hcl
output "resource_group_name" {
  value = azurerm_resource_group.example.name
}
```

### 5. State

Terraform maintains a state file (`terraform.tfstate`) to keep track of the resources it manages. The state file is critical for detecting changes and ensuring the current infrastructure matches your configuration.

### 6. Modules

Modules are reusable units of Terraform configuration. They allow you to organize your code into logical components, making it easier to manage and scale.

```hcl
module "network" {
  source = "./modules/network"

  vnet_name    = "example-vnet"
  vnet_address = "10.0.0.0/16"
}
```

## Basic Example: Azure Deployment

Here is a simple example of deploying an Azure Resource Group and Virtual Network:

### File: `main.tf`

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
```

### File: `variables.tf`

```hcl
variable "location" {
  description = "The Azure region to deploy resources into."
  default     = "East US"
}
```

### File: `outputs.tf`

```hcl
output "vnet_name" {
  value = azurerm_virtual_network.example.name
}
```

> Author's note: while this is the conventional naming for terraform files, and - especially for modules published  on the Terraform Registry - it is a good idea to follow this, Terraform actually does not care what are the `*.tf` files names. It reads all the files in the current directory, so you can split or merge the code as you see fit and use any file name you like.

### Steps to Deploy

1. **Initialize**:

   ```bash
   terraform init
   ```

2. **Plan**:

   ```bash
   terraform plan
   ```

3. **Apply**:

   ```bash
   terraform apply
   ```

4. **Destroy** (optional):

   ```bash
   terraform destroy
   ```

## Local Example: Creating a File

Terraform is not limited to cloud providers. It can also manage local resources. Here is a simple example of creating a local file with some content.

### File: `main.tf`

```hcl
provider "local" {}

resource "local_file" "example" {
  filename = "example.txt"
  content  = "Hello, Terraform!"
}
```

### Steps to Deploy

1. **Initialize**:

   ```bash
   terraform init
   ```

2. **Plan**:

   ```bash
   terraform plan
   ```

3. **Apply**:

   ```bash
   terraform apply
   ```

4. **Check the Result**:
   Verify that a file named `example.txt` has been created in your working directory with the specified content.

5. **Destroy** (optional):

   ```bash
   terraform destroy
   ```

#### Demo

*Here is a simple demonstration of Terraform. The only requirement for this is Internet connection and Terraform installed.*

```powershell
PS D:\FS_Workspace\TerraformBootCamp> terraform init
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of hashicorp/local from the dependency loc
k file
- Using previously-installed hashicorp/local v2.5.2

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan
" to see
any changes that are required for your infrastructure. All Terraform
commands
should now work.

If you ever set or change modules or backend configuration for Terraf
orm,
rerun this command to reinitialize your working directory. If you for
get, other
commands will detect it and remind you to do so if necessary.
PS D:\FS_Workspace\TerraformBootCamp> terraform plan

Terraform used the selected providers to generate the following
execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # local_file.example will be created
  + resource "local_file" "example" {
      + content              = "Hello, Terraform!"
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "example.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + file_checksum = (known after apply)

────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform
can't guarantee to take exactly these actions if you run "terraform
apply" now.
PS D:\FS_Workspace\TerraformBootCamp> terraform apply

Terraform used the selected providers to generate the following
execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # local_file.example will be created
  + resource "local_file" "example" {
      + content              = "Hello, Terraform!"
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "example.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + file_checksum = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

local_file.example: Creating...
local_file.example: Creation complete after 0s [id=42086c02e03bf671dd
f621ed9922f52f2c7a605c]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

file_checksum = "42086c02e03bf671ddf621ed9922f52f2c7a605c"
PS D:\FS_Workspace\TerraformBootCamp>
```

## Modules vs Direct Resource Definitions

### Direct Resource Definitions

Directly defining resources in Terraform involves specifying individual resources within your `main.tf` file or similar configuration files. This approach is simple and works well for small setups or when creating resources that don't require repeated patterns.

Example:

```hcl
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
```

### Using Modules

Modules encapsulate a set of resource definitions into a reusable package. This is especially useful for complex or repeated setups. Modules improve organization, reduce code duplication, and make your configuration easier to maintain.

Example:

#### Module Structure

```
modules/
  network/
    main.tf
    variables.tf
    outputs.tf
```

#### Module Code (`modules/network/main.tf`)

```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_address]
  location            = var.location
  resource_group_name = var.resource_group_name
}
```

#### Using the Module in `main.tf`

```hcl
module "network" {
  source              = "./modules/network"
  vnet_name           = "example-vnet"
  vnet_address        = "10.0.0.0/16"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
```

### Choosing Between Modules and Direct Definitions

- **Direct Definitions**: Use these for smaller projects or when resources are unique and not repeated.
- **Modules**: Use these for complex projects, repeated patterns, or when organizing resources into logical components is beneficial.

## Terraform Workflow

1. **Write Configuration**: Create `.tf` files that define your desired infrastructure.
2. **Initialize**: Run `terraform init` to initialize the working directory and download the required provider plugins.
3. **Plan**: Use `terraform plan` to preview the changes Terraform will make.
4. **Apply**: Run `terraform apply` to create or update your infrastructure.
5. **Destroy**: Use `terraform destroy` to tear down the infrastructure managed by Terraform.

## Summary

Terraform provides a powerful way to manage infrastructure as code, enabling repeatable and consistent deployments. By understanding its key concepts—providers, resources, variables, outputs, state, and modules—you can start building robust infrastructure configurations. The examples provided demonstrate how Terraform can be used to deploy Azure resources and manage local resources, serving as a foundation for more complex setups. Understanding the difference between modules and direct resource definitions is crucial for scaling and organizing your projects effectively.
