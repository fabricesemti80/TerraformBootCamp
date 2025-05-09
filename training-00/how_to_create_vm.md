# Azure Virtual Machine Deployment with Terraform: A Guide for Engineers

See: [Azure Windows VM Terraform Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine)

## Pre-requisites

1. Authentication

Refer to: [Authenticate Terraform to Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash)

2. Define configuration

The configuration, in its most basic form is defined in a file called `main.tf` (name is arbitrary, `somefile.tf` would also work)

A config would look like something like this:

```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "example" {
  name                 = "acctestmd"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "5"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_windows_virtual_machine.example.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
```

3. Configuration details

Let's go through this block by block:

```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}
```

- This is the provider definition
- `azurerm` is the provider used to communicate with the [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview)

```terraform
provider "azurerm" {
  features {}
}
```

- The features - by default an empty block - that we would want to specify when we use the provider

```terraform
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}
```

- In Azure all resources are placed in a "virtual container" called `resource group`; the logic upon what you place in one is down to you
- The name will be what is displayed on Azure
- The location is one of the [Azure regions](https://learn.microsoft.com/en-us/azure/reliability/regions-list)

```terraform
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
```
- Here we define a virtual network (which will host the subnet, which in turn will host the network interface giving connection to the VM)
- It has a name
- It has a CIDR range
- Its location can be defined as "West Europe", but since we already defined that in the `resource group`, we might as well reference it
- Same way we could put `example-resources` as the value of the `resource_group_name` key; however it is better to reference the current value of the resource group (*if in the future the name of the resource group changes, you would only need to update one place instead of many by using [dot-notation](https://builtin.com/data-science/dot-notation)*)

```terraform
resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}
```
- Here we define a subnet
- The subnet has a name
- We refer to the earlier resource group by name
- We also refer to the previously created virtual network
- And we give a resource a CIDR prefix
- Again, due to the dot-notation, in the event of a future change (of the name of the resource group or virtual network), if we refer to these rather than hardcoding them - a potential change will be easy to make

```terraform
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
```
- This block defines a network interface card (NIC) that will be attached to our virtual machine
- It has a name ("example-nic") and uses dot notation to reference the location and resource group name
- The `ip_configuration` block specifies:
  - A name for this configuration ("internal")
  - References the subnet ID using dot notation
  - Sets the IP address allocation method to "Dynamic" (IP will be assigned automatically)

```terraform
resource "azurerm_managed_disk" "example" {
  name                 = "acctestmd"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "5"

  tags = {
    environment = "staging"
  }
}
```
- This creates an additional data disk for the VM (separate from the OS disk)
- It defines the disk name, location, and resource group using dot notation
- `storage_account_type` specifies the performance tier (Standard_LRS = Standard Locally Redundant Storage)
- `create_option` set to "Empty" means we're creating a blank disk
- `disk_size_gb` defines the disk size in gigabytes
- `tags` allow you to add metadata for organizing and tracking resources

```terraform
resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_windows_virtual_machine.example.id
  lun                = "10"
  caching            = "ReadWrite"
}
```
- This resource attaches the managed disk we created to the VM
- It references the disk ID and VM ID using dot notation
- `lun` (Logical Unit Number) is a unique identifier for the disk within the VM
- `caching` defines the disk caching strategy (ReadWrite, ReadOnly, or None)

```terraform
resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
```
- Finally, this is the Windows VM resource itself
- It specifies:
  - Name, resource group, and location
  - VM size (`Standard_F2` defines the CPU, memory, and other hardware characteristics)
  - Administrator credentials (username and password)
  - Reference to the network interface we created earlier
  - OS disk configuration with caching setting and storage type
  - Source image details specifying which OS to install:
    - `publisher`: The organization that created the image (Microsoft)
    - `offer`: The name of the image group
    - `sku`: The specific image version
    - `version`: Which iteration of the SKU to use ("latest" means the most current version)

## Applying the Configuration

After creating your `main.tf` file, you need to:

1. Initialize Terraform:
```bash
terraform init
```

2. Preview the changes:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

When prompted, type "yes" to confirm the creation of resources.

## Managing Resources

- To update resources, modify the `main.tf` file and run `terraform apply` again
- To destroy all resources:
```bash
terraform destroy
```

## Best Practices

1. **Use variables** for values that might change or be reused
2. **Store state remotely** using Azure Storage Account for team collaboration
3. **Use modules** to organize complex configurations
4. **Never hardcode sensitive values** like passwords; use environment variables or a secure vault
5. **Use output values** to expose important information like IP addresses