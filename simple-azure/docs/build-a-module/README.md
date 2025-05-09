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

## Create a single Linux VM

### Write code

We will start with with a clean slate in terms of our code.

- we check, if Terraform is properly imported

```powershell
PS D:\FS_Workspace\terraform\demo\simple-azure\linuxvm> terraform version
Terraform v1.11.2
on windows_amd64

Your version of Terraform is out of date! The latest version
is 1.11.3. You can update by downloading from https://www.terraform.io/downloads.html
PS D:\FS_Workspace\terraform\demo\simple-azure\linuxvm>
```

> note: you can see some helpful information about the available commands if you run `terraform --help` or just `terraform` (same results)

- we have no env variables at start, as confirmed by PowerShell

```powershell
PS C:\Users\admin-fsemti> get-childItem Env: | where-object {$_.Name -like "ARM*"}

Name                           Value
----                           -----
ARM_USE_MSI                    true


PS C:\Users\admin-fsemti>
```

- we also start with an empty folder

```powershell
PS D:\FS_Workspace\terraform\demo\simple-azure\linuxvm> get-childitem
PS D:\FS_Workspace\terraform\demo\simple-azure\linuxvm>
```

> note: this is `simple-azure\linuxvm` of this repo

- first of all we need to provide the environment variables, that Terraform use to authenticate for Azure

```powershell
$env:ARM_SUBSCRIPTION_ID = ''   # BCMG-Test-SubscriptionA
$env:ARM_TENANT_ID =''          # BCMGlobal ASI LIMITED
$env:ARM_CLIENT_ID = ''         # terraform-sp clientID
$env:ARM_CLIENT_SECRET = '' # terraform-sp client secret
```

> note: fill out the actual values with your ones

If these filled in correctly, you should be able to check them in your shell:

![alt text](image-16.png)

- now we create a file - `main.tf` to follow convention-  and add the contents from the Linux VM resource (see above)

![alt text](image-17.png)

- as the given example only shows the resources, we need to add the provider details too, this can easily found on the same page

![alt text](image-18.png)

- after this, we should be able to do `terraform init`

![alt text](image-19.png)

- unfortunately, `terraform plan` still leads to an error, but do not panic!

![alt text](image-20.png)

this error is very clear: we do not have the `id_rsa.pub` file in our user's home directory's `.ssh` subfolder :(

to address this, we could use [ssh-keygen](https://learn.microsoft.com/en-us/viva/glint/setup/sftp-ssh-key-gen) or similar tools  to create a key pair, but we probably want to keep this under the control of terraform; so we update the terraform block, to include a [new provider](https://registry.terraform.io/providers/hashicorp/tls/latest/docs) that will do this for us

```terrraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=4.1.0"
    }
  }
}
```

and that means we also add some additional resources

```terraform
# Generate SSH key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save private key to local file
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "./id_rsa"
  file_permission = "0600"
}
```

> note: in the interest to keep this guide as short as possible, I will not cover this provider in great details, nor the parameters involved - please read the documentation on the link

we then conveniently use this newly generated SSH key in the VM-s confi; all we need is to change:

 from:

```terraform

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
```

to:

```terraform
  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }
```

- after the changes in the code, since we have added a new provider, we need to do a `terraform init` to get that downloaded by Terraform; then a `terraform plan` should work!

![alt text](image-21.png)

...imiting a few lines here ...

![alt text](image-22.png)

the important part is, plan does not fail and shows us the creation of resources

at this point our `main.tf` should look something like this:

![alt text](image-23.png)

> note: I highlighted the parts that changed compared to the example

### Deploy code

At this point in this particular subscription we have no resources

![alt text](image-24.png)

(you can check this on `Azure Portal` --> `All resources` --> filter it to your subscription)

> note: we ignore the network watcher; that is something created by Azure whenever a network interface is created; this subscription had some, and therefore it is present; in a fresh new tenant/sub this should be absent!

to change this:

- run `terraform apply`
- **carefully review** the output to be sure all those are in line with what we want to create

![alt text](image-25.png)

(1) a few resoruces pictured; actual output is longer; advised to go through all of it, or at least glance over it
(2) this is very important; if there are changes, and even more crucially destroys - be cautious before saying `yes` ! 

> note: neither the author or Terraform will be responsible, if you deployed a resource with Terraform, and then did some code change resoulting in unintended changes or destruction!

- after this type `yes` and the deployment will start

![alt text](image-27.png)

deployment can take a few minutes (*depending on a number of factors, i.e. conection to Azure API, load, and the current air humidity at that time in Kiwirrkurra (:D)*)

- check on Azure what is deployed

![alt text](image-28.png)

> note: while at this time the machine has been deployed, you won't be able to connect to it; that is because if you look at the code, there is not public IP on the network interface; we also did not specify a network security group and NAT gateway - or a bastion service - which would be higly recommended to use in Real World, to provide a secure access to the VM; adding these would make things a lot more complex so we skip this; if you really curious, you can go to the VM on the portal, select "Connect" and Azure will automatically provision a free bastion instance for you, however this is not in the scope of Terraform, nor I am going to explain how to use SSH keys...

- once we done with observing our great work, run `terraform destroy` to de-provision all the resources

## Move to multiple VM-s

Now we are getting to the fun-part. 
Building one VM in a subnet, and one subnet in a vnet, and one vnet in a resource group is hardly what we need, often times we need multiple instances. With individually changing parameters. And that means  we need reusable pieces of code, also called [Terraform modules](https://developer.hashicorp.com/terraform/language/modules).
Now there are modules around the Internet - on the HashiCorp repository and Github mostly - which other people wrote, but we can also create our own.

At this point our folder looks something like this:

![alt text](image-29.png)

The only file we actually created ourselves is the `main.tf` - the rest is all generated by Terraform; I also hid other folders in the repo, in order to not to distract us.

we will create another folder at the same level as `linuxvm`, very creatively named `linuxvms`

```powershell
PS D:\FS_Workspace\terraform\demo\simple-azure\linuxvm> mkdir ..\linuxvms


    Directory: D:\FS_Workspace\terraform\demo\simple-azure


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       09/05/2025     12:13                linuxvms


PS D:\FS_Workspace\terraform\demo\simple-azure\linuxvm> Get-ChildItem .. -Filter "linux*"


    Directory: D:\FS_Workspace\terraform\demo\simple-azure


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       09/05/2025     11:58                linuxvm
d-----       09/05/2025     12:13                linuxvms


PS D:\FS_Workspace\terraform\demo\simple-azure\linuxvm>
```

The `linuxvm` folder will contain our module definition, and the `linuxvms` ("S" !!! note it!) will be calling this to create multiple VM-s.

we create a - for now, blank - `main.tf` in that one too

![alt text](image-30.png)

### 