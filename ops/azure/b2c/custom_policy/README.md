# Custom Policies

Files in this folder originated from the [Custom policy starter pack](https://docs.microsoft.com/en-us/azure/active-directory-b2c/custom-policy-get-started?tabs=app-reg-preview#custom-policy-starter-pack). The `SocialAndLocalAccountsWithMfa` scenario was used as the starting point for this scenario.

The original starter pack can be found if you [Download the .zip file](https://github.com/Azure-Samples/active-directory-b2c-custom-policy-starterpack/archive/master.zip) or clone the repository:

```console
git clone https://github.com/Azure-Samples/active-directory-b2c-custom-policy-starterpack
```

Changes have been made to these files to accomodate this project. Do not edit any of the templates directly. Running the `GenerateFiles.ps1` script mentioned below will create a new copy of the templates with all appropriate settings applied.

In order to generate the files run the following command `GenerateFiles.ps1` in `PowerShell`. You may need to `Run as Administrator` since this command creates files. Be sure to replace the values in the arguments below with your values.

```powershell
& .\GenerateFiles.ps1 `
-TenantName {{TenantName}} `
-TenantLocation {{TenantLocation}} `
-IdentityExperienceFrameworkAppId yourclientid `
-ProxyIdentityExperienceFrameworkAppId yourclientid `
-RestApiSignInUrl uriToRestService`
-AzureAdTenant youradtenant `
-AzureAdAppClientId yourclientid `
-AzureAdAppSecretName yourpolicykeyname `
-AccountDisplayName youraccountname `
-FacebookClientId yourfacebookclientid
```
