# How to modularise a configuration 
*(and why should we do it?)*

Let's start by answering the question "why" first, and then we will cover the "how" part.

Our starting point will be the [Azure Linux VM resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine). (The choice of OS matters little, but generally it is easier to work with Linux servers.)

If we take a look on the example provided at that link, we will see how we can relatively easily set up a complete "stack" ( by "stack" I mean the combination `resource group`, `virtual network`, `subnet`, `network interface`, and finally `virtual machine` ). 
This is great, but as soon as we want to create multiple machines, (perhaps in the same resource group, or in another, perhaps in the same VNET or in another, etc.) - we will have to keep repeating a large chunk of the codeblock, and manually edit it, which is not a great practice, source of errors (not to mention it goes against the [D.R.Y. principle of programing](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)). 
That is, where modules come in.

## Pre-requisites

We will start the writing of the code from scratch, but we still have to have a few things in place:

- [Terraform installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on the system (I will not cover this here, feel free to follow the link to do this)
- Terraform often downloads providers and intenal modules from [GitHub](https://github.com/) and HashiCorp/Terraform software repositories, so it is a good idea to unlock at least:
  - `*.github.com` 
  - `*.terraform.io`
  - `*.hashicorp.com` 
wildcard domain. Generally port `443` is used, but consider unlocking `80` and `22` too just in case
- we will also need to have an Azure tenant and subscription, and a means to authenticate with these; there are multiple ways to achive this; my recommended way is to use [service principal with a client secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret), which is both relatively easy to implement and compatbile with future-CI/CD implementation, but on the link we can find explanations on other methods as well. (To not make this guide extremely long, I will not detail this here, but in short: Step 1. Create service principal and note down it's client ID and client secret; Step 2. Assign roles as and when needed; start with subscription contributor; might need other roles later)
- if we go with my method, we will need to supply a few environment variables; as I am currently working from a Windows-system, I use PowerShell as my console, and therefore commands will reflect this; Unix-like systems and bash needs slightly different methods, but I leave the reading on this - or AI-ing - down to the reader.

## Start Terraforming

We will start with with a clean slate in terms of our code.

- we have no env variables at start, as confirmed by PowerShell

```powershell
PS C:\Users\admin-fsemti> get-childItem Env: | where-object {$_.Name -like "ARM*"}

Name                           Value
----                           -----
ARM_USE_MSI                    true


PS C:\Users\admin-fsemti>
```
- 
