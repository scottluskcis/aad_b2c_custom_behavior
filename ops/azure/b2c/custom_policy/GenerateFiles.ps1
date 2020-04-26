Param(
    [Parameter(Mandatory = $true)][string] $TenantName,
    [Parameter(Mandatory = $false)][string] $TenantLocation = ".onmicrosoft.com",
    [Parameter(Mandatory = $true)][string] $IdentityExperienceFrameworkAppId,
    [Parameter(Mandatory = $true)][string] $ProxyIdentityExperienceFrameworkAppId,
    [Parameter(Mandatory = $true)][string] $RestApiSignInUrl,
    [Parameter(Mandatory = $true)][string] $AzureAdTenant,
    [Parameter(Mandatory = $true)][string] $AzureAdAppClientId,
    [Parameter(Mandatory = $true)][string] $AzureAdAppSecretName,
    [Parameter(Mandatory = $false)][string] $AccountDisplayName,
    [Parameter(Mandatory = $false)][string] $FacebookClientId
)

$infoPrefix = "   INFO:";
$errorPrefix = "  ERROR:";
$sectionSeparator = "============================================="
$separator = "---------------------------------------------";

Function Get-Settings {
    # hash of settings to replace in files
    # settings name match the token in file to replace
    return @{
        TenantName = $TenantName;
        TenantLocation = $TenantLocation;
        IdentityExperienceFrameworkAppId = $IdentityExperienceFrameworkAppId;
        ProxyIdentityExperienceFrameworkAppId = $ProxyIdentityExperienceFrameworkAppId;
        RestApiSignInUrl = $RestApiSignInUrl;
        AzureAdTenant = $AzureAdTenant;
        AzureAdAppClientId = $AzureAdAppClientId;
        AzureAdAppSecretName = $AzureAdAppSecretName;
        AccountDisplayName = $AccountDisplayName;
        FacebookClientId = $FacebookClientId
    };
}

Function Set-Tokens {
    Param (
        $File,
        $Settings,
        $OutputFolder
    )
    Write-Verbose $separator;

    $baseFileName = $File.BaseName;
    $fileExtension = $File.Extension;
    $outputFile = "${OutputFolder}/${baseFileName}${fileExtension}";
    Write-Verbose "${baseFileName} - Set-Tokens for File - Start";

    if(Test-Path -Path $outputFile) {
        Write-Verbose "Removing existing file ${outputFile}";
        Remove-Item -Path $outputFile;
    }

    Write-Verbose "${baseFileName} - Get-Content for File";
    $content = Get-Content -Path $File.FullName;

    $newContent = $content;
    foreach($settingKey in $Settings.Keys) {
        $token = "{{${settingKey}}}";
        $settingValue = $Settings[$settingKey];

        Write-Verbose "${baseFileName} - replacing content in file for setting '${settingKey}' using token '${token}'";

        $newContent = $newContent -replace $token, $settingValue;
    }
    Write-Verbose "${baseFileName} - writing new content to file";
    $newContent | Set-Content -Path $outputFile;

    $created = Test-Path -Path $outputFile;
    if ($created) {
        Write-Host "${infoPrefix} File created '${outputFile}'" -ForegroundColor Green;
    } else {
        Write-Host "${errorPrefix} ${outputFile} - file failed to be created" -ForegroundColor Red;
    }

    Write-Verbose "${baseFileName} - Set-Tokens for File - End";

    return $created;
}
 
Function Set-AllFileSettings {
    Param (
        $TemplateFolder,
        $FileExtension,
        $Settings,
        $OutputFolder
    )
    Write-Verbose $sectionSeparator;
    Write-Verbose "Set-AllFileSettings - Start";

    if (!(Test-Path $OutputFolder)) {
        New-Item -ItemType Directory -Path $OutputFolder;
        Write-Host "${infoPrefix} Created Directory '${OutputFolder}'" -ForegroundColor Green;
    } else {
        Write-Verbose "Directory already exists ${OutputFolder}";
    }
    
    $count = 0;
    $filter = "*.${FileExtension}"
    foreach($file in Get-ChildItem -Path $TemplateFolder -Filter $filter) {
        if (Set-Tokens -File $file -Settings $Settings -OutputFolder $OutputFolder) {
            $count += 1;
        }
    }

    Write-Host "${infoPrefix} ${count} files were successfully created" -ForegroundColor Green;
    
    Write-Verbose "Set-AllFileSettings - End";
}

# load the settings
$settings = Get-Settings;

# process all xml files in the templates folder
Set-AllFileSettings `
  -TemplateFolder "templates" `
  -FileExtension "xml" `
  -OutputFolder "output" `
  -Settings $settings;