# Terraform with Microsoft Azure
This repository contains hands-on Infrastructure as Code (IaC) scripts written in **Terraform** to provision, configure, and manage core Microsoft Azure Services. The lab is structured around the **Microsoft Azure Administrator (AZ-104)** Learning Path, demonstrating real-world cloud administration practices, identity management, network management, compute management, and storage management.

---

## Repository Content

The repository is organized into modular Terraform configuration files, each covering a specific domain of Azure administration:

### 1. `main.tf` - Providers Foundation
* **Multi-Provider Configuration:** Manages both `azurerm` and `azuread` providers with strict version constraints.
* **Resource Group Management:** Creates central resource groups acting as logical containers for all lab components.

### 2. `identity_management.tf` - Azure Active Directory (Entra ID) Management
* **Identity Provisioning:** Creates Azure AD security groups (e.g., DevOps Team) and user accounts with enforced security policies (e.g., mandatory password changes).
* **RBAC & Subscriptions:** Utilizes data sources to fetch subscription details and assigns Role-Based Access Control (RBAC) roles like **Contributor** scoped at the subscription level.

### 3. `azure_policy.tf` - Governance & Compliance
* **Custom Azure Policies:** Defines and assigns custom policies to enforce resource location restrictions (`Deny` effect for non-compliant regions) ensuring cost control and compliance.

### 4. `azure_vnet.tf` - Network Management
* **Virtual Networks (VNets):** Provisions multi-tier VNets for Production (`10.0.0.0/16`) and Development (`10.1.0.0/16`) with custom DNS server configurations.
* **Subnetting:** Implements segmented subnets (`frontend`, `backend`, and `dev-subnet`) with non-overlapping address spaces.
* **Network Security Groups (NSGs):** Configures security rules (e.g., allowing inbound SSH traffic) and associates them with subnets.
* **VNet Peering:** Establishes a bidirectional, fully peered connection (`prod-to-dev` and `dev-to-prod`) allowing secure internal communication across networks.

### 5. `compute.tf` - Compute & High Availability
* **Virtual Machines:** Provisions standalone Windows Server VMs (`Standard_E2s_v7` / `2022-datacenter-azure-edition`).
* **High Availability (Availability Sets):** Configures Availability Sets with customized fault domain (`2`) and update domain (`5`) counts to ensure high availability and protect against hardware and planned maintenance failures.
* **Network Interfaces (NICs):** Manages private IP allocations and dynamic bindings between VMs and specific subnets.

### 6. `storage.tf` - Storage Accounts & Data Services
* **Storage Accounts:** Provisions Standard LRS storage accounts with production tags.
* **Blob Storage:** Creates private containers and automates the upload of configuration/text files (`test_blob.txt`) as block blobs.
* **Azure Files:** Implements cloud file shares with custom quotas (`50 GB`) and uploads shared file assets (`test_storage.txt`) utilizing SMB-based sharing principles.

---

## Getting Started
### Prerequisites
* [Terraform](https://www.hashicorp.com/_downloads/terraform) installed.
* An active Azure Subscription.
* Azure CLI installed and authenticated (`az login`).

### Deployment Steps
1. Clone the repository:
```bash
   
   git clone [https://github.com/MariamAliYousef/devops-hands-on-projects/terraform-az104-labs](https://github.com/MariamAliYousef/devops-hands-on-projects/terraform-az104-labs)
   
   cd terraform-az104-labs
```
2. Initialize Terraform providers:
```bash
terraform init
```
3. Preview the execution plan:
```bash
terraform plan
```
4. Apply the configuration:
```bash
terraform apply --auto-approve
```








