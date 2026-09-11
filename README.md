# strykeapps hosting

Azure App Service **plan only**. No web app or application source is deployed from this repo. Individual apps will be created on this plan later.

## Resources

| Resource | Name | Notes |
|---|---|---|
| Resource group | `strykerg` | Created by the GitHub Actions workflow in West US 3 if missing |
| Location | West US 3 (`westus3`) | All resources |
| App Service Plan | `strykeapps-plan` | Linux, SKU **B1** (Basic) |

Bicep: `infra/main.bicep`  
Parameters: `infra/main.bicepparam`

## GitHub Actions

`.github/workflows/deploy-infra.yml` runs on **push to `main`** (infra/workflow changes) and **workflow_dispatch**.

It:

1. Logs in to Azure with OIDC (`azure/login`)
2. Creates resource group `strykerg` in `westus3` if needed
3. Runs `az deployment group create` against `strykerg`

### Required GitHub secrets

| Secret | Value |
|---|---|
| `AZURE_CLIENT_ID` | App registration (client) ID |
| `AZURE_TENANT_ID` | Microsoft Entra tenant ID |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID |

### Configure GitHub OIDC (federated credential)

1. In Azure, create an **App registration** (or use an existing one) and assign it a role on the subscription or on resource group `strykerg` (for example **Contributor**).
2. On the app registration, open **Certificates & secrets** → **Federated credentials** → **Add credential**.
3. Choose **GitHub Actions deploying Azure resources**.
4. Set:
   - Organization: `rfeltis`
   - Repository: `strykeapps`
   - Entity: **Branch** `main`
   - If login fails with `AADSTS700213`, set the credential **subject** to the value GitHub presented (this org currently uses `repo:rfeltis@2825162/strykeapps@1366365648:ref:refs/heads/main`). You can keep a second credential with the classic `repo:rfeltis/strykeapps:ref:refs/heads/main` subject.
5. Copy the app (client) ID, tenant ID, and subscription ID into the GitHub secrets listed above.

The workflow uses `permissions: id-token: write` so GitHub can mint the OIDC token for `azure/login`.
