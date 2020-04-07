# AAD B2C Custom Behavior

Azure Active Directory B2C Customizing Behavior

## Setup

Unfortunately, at this time a lot of the steps are a manual process, once it can be automated I will update the steps to run a script to provision this.

### B2C App Registration

Create an app registration: [Register an application in Azure Active Directory B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/tutorial-register-applications?tabs=app-reg-preview#register-a-web-application)

Create user flows: [Create user flows in Azure Active Directory B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/tutorial-create-user-flows). NOTE: these are only to get started and will be replaced with the custom flows to be built in this example.

Make note of the following:

* Application (client) ID
* Tenant name
* User Flows names

### Secrets

The following configuration is required for `Login` to work in the `DemoClaimsApp`. Update the following information with your B2C app details noted in the previous section. Then, open a command prompt in the same directory as the `DemoClaimsApp` and run the following commands applying your information.

```powershell
dotnet user-secrets set "AzureAdB2C:Instance" "https://<your_tenant>.b2clogin.com/tfp/";
dotnet user-secrets set "AzureAdB2C:ClientId" "<your_client_id>";
dotnet user-secrets set "AzureAdB2C:CallbackPath" "/signin-oidc";
dotnet user-secrets set "AzureAdB2C:Domain" "<your_tenant>.onmicrosoft.com";
dotnet user-secrets set "AzureAdB2C:SignUpSignInPolicyId" "B2C_1_signup_signin";
dotnet user-secrets set "AzureAdB2C:ResetPasswordPolicyId" "B2C_1_reset_password";
dotnet user-secrets set "AzureAdB2C:EditProfilePolicyId" "B2C_1_edit_profile";
```

### Custom Policies

Follow the steps at [Get started with custom policies in Azure Active Directory B2C](https://docs.microsoft.com/en-us/azure/active-directory-b2c/custom-policy-get-started?tabs=app-reg-preview)