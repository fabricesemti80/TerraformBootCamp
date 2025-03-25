[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [ValidateSet("init", "plan", "apply")]
    [string]$Action = "apply"  # Default action
    ,
    [Parameter(HelpMessage = "BCMG Test SubscriptionA")]
    [string]
    $DefaultSubscriptionId = 'a72d9cb6-67bc-4f13-a042-e7e6b93558a7',
    
    [Parameter(HelpMessage = "BCMG Tenant")]
    [string]
    $DefaultTenantId = '754a96ff-c5a0-47e8-86f8-c5093906e318',
    
    [Parameter(HelpMessage = "terraform-sp service principal")]
    $TerraformServicePrincipalId = '11e9321a-4b7d-4f88-8b47-764c5ff19a09',
 
    [Parameter(HelpMessage = "Path to the file containing the client secret matching the service principal")]
    [string]
    $ClientSecretFilePath = '..\clientsecret'
)

function Init-Stack {

    Write-Host -ForegroundColor Magenta "Setting up Terraform environment..."
    $env:ARM_SUBSCRIPTION_ID = $DefaultSubscriptionId
    $env:ARM_TENANT_ID = $DefaultTenantId
    $env:ARM_CLIENT_ID = $TerraformServicePrincipalId
    try {
        if (-not (Test-Path -Path $ClientSecretFilePath)) {
            throw "Client secret file not found at path: $ClientSecretFilePath"
        }
        $env:ARM_CLIENT_SECRET = (Get-Content -Path $ClientSecretFilePath -ErrorAction Stop)
        if ([string]::IsNullOrWhiteSpace($env:ARM_CLIENT_SECRET)) {
            throw "Client secret file exists but appears to be empty"
        }
    }
    catch {
        Write-Host -ForegroundColor Red "ERROR: Failed to read client secret file: $_"
        Write-Host -ForegroundColor Yellow "Please ensure the client secret file exists at: $ClientSecretFilePath"
        Write-Host -ForegroundColor Yellow "You can specify a different path using the -ClientSecretFilePath parameter"
        exit 1
    }
    $env:TF_LOG = "INFO"
    $env:TF_LOG_PATH = "terraform.log"

    Write-Host -ForegroundColor Magenta "Initializing Terraform..."
    terraform init --upgrade
}

function Plan-Stack {
    param (
        [string]$PlanFile = 'terraform.tfplan'
    )
    Init-Stack
    Write-Host -ForegroundColor Magenta "Planning Terraform stack..."    
    terraform plan -out $PlanFile
}

function Apply-Stack {
    param (
        [string]$PlanFile = 'terraform.tfplan'
    )
    Init-Stack
    Write-Host -ForegroundColor Magenta "Applying Terraform stack..."    
    terraform plan -out $PlanFile
    terraform apply $PlanFile
}

switch ($Action) {
    "init" { Init-Stack }
    "plan" { Plan-Stack }
    "apply" { Apply-Stack }
    default { Write-Host -ForegroundColor Magenta "Invalid action. Please use init, plan, or apply." }
}