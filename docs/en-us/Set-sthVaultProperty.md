---
external help file: sthVault-help.xml
Module Name: sthVault
online version:
schema: 2.0.0
---

# Set-sthVaultProperty

## SYNOPSIS
Adds the new properties or changes values of the existing properties in the vault.

## SYNTAX

### VaultName (Default)
```
Set-sthVaultProperty [-VaultName] <String> [-PlainText <Hashtable>] [-SecureString <Hashtable>]
 [-Credential <Hashtable>] [<CommonParameters>]
```

### VaultFilePath
```
Set-sthVaultProperty [-VaultFilePath <String>] [-PlainText <Hashtable>] [-SecureString <Hashtable>]
 [-Credential <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
Set-sthVaultProperty function add the new properties or changes values of the existing properties in the vault.

Properties can be of three types: **PlainText**, **SecureString**, and **Credential**.

You can use the **-PlainText**, **-SecureString**, and **-Credential** parameters to specify needed vaules.
Each of these parameters accepts **HashTable** as an argument, which contains the Name-Value pairs.

## PARAMETERS

### -VaultName
Specifies the vault name.

This is the vault, created by the `New-sthVault` cmdlet with the **-VaultName** parameter and located under the **Vaults** folder in the module's directory.

```yaml
Type: String
Parameter Sets: VaultName
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VaultFilePath
Specifies vault file path.

This parameter allows you to use vault file, created in an alternate location.

Value should contain path and file name with .xml extension.

```yaml
Type: String
Parameter Sets: VaultFilePath
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlainText
Specifies plain text values.

Parameter value should be in the form of hashtable, that contains Name-Value pairs.

For example:

Set-sthVaultProperty SomeVault -PlainText @{PlainTextOne = 'NewValue'; NewPlainTextProperty = 'NewPropertyValue'}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SecureString
Specifies SecureString values.

Parameter value should be in the form of hashtable, that contains Name-Value pairs.

Hashtable values can be SecureStrings objects, or plain text.

If value is in plain text, it will be converted to SecureString.

For example:

$SecureStringOne = ConvertTo-SecureString -String 'NewValue' -AsPlainText -Force
Set-sthVaultProperty SomeVault -SecureString @{SecureStringOne = $SecureStringOne; NewSecureStringProperty = 'NewPropertyValue'}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specifies PSCredential values.

Parameter value should be in the form of hashtable, that contains Name-Value pairs.

Hashtable values can be PSCredential objects, or arrays of two elements, i.e. @{Credential = 'Name', 'Password'}

If value is in the form of array, it will be converted to PSCredential.

For example:

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'NewUsername', $(ConvertTo-SecureString -String 'NewPassword' -AsPlainText -Force)

Set-sthVaultProperty SomeVault -Credential @{CredentialOne = $CredentialOne; NewCredential = 'NewCredentialUsername', 'NewCredentialPassword'}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

**SecureStrings** and **PSCredential** objects use DPAPI, which means that the vault, containing **SecureStrings** or **PSCredentials** can only be used on the computer it was created on, and under the user account, that created it.

## EXAMPLES

### Example 1
```powershell
$PlainText = @{PlainTextOne = '1'; PlainTextThree = 'Three'}

$SecureStringOne = ConvertTo-SecureString -String '1' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringThree = 'Three'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList '1', $(ConvertTo-SecureString -String '1' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialThree = 'Three', 'ThreePassword'}

Set-sthVaultProperty -VaultName TheVault -PlainText $PlainText -SecureString $Securestring -Credential $Credential

Get-sthVault -VaultName TheVault -ShowSecureData

Name                           Value
----                           -----
PlainTextOne                   1
PlainTextThree                 Three
PlainTextTwo                   Two
SecureStringOne                1
SecureStringThree              Three
SecureStringTwo                Two
CredentialOne                  {1, 1}
CredentialThree                {Three, ThreePassword}
CredentialTwo                  {Two, TwoPassword}
```

This command changes **PlainTextOne**, **SecureStringOne**, and **CredentialOne** properties and adds **PlainTextThree**, **SecureStringThree**, and **CredentialThree** properties to the vault.

### Example 2
```powershell
$PlainText = @{PlainTextOne = '1'; PlainTextThree = 'Three'}

$SecureStringOne = ConvertTo-SecureString -String '1' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringThree = 'Three'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList '1', $(ConvertTo-SecureString -String '1' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialThree = 'Three', 'ThreePassword'}

Set-sthVaultProperty -VaultFilePath C:\Vaults\SomeVault.xml -PlainText $PlainText -SecureString $Securestring -Credential $Credential

Get-sthVault -VaultFilePath C:\Vaults\SomeVault.xml -ShowSecureData

Name                           Value
----                           -----
PlainTextOne                   1
PlainTextThree                 Three
PlainTextTwo                   Two
SecureStringOne                1
SecureStringThree              Three
SecureStringTwo                Two
CredentialOne                  {1, 1}
CredentialThree                {Three, ThreePassword}
CredentialTwo                  {Two, TwoPassword}
```

This command changes **PlainTextOne**, **SecureStringOne**, and **CredentialOne** properties and adds **PlainTextThree**, **SecureStringThree**, and **CredentialThree** properties to the vault file with the name **SomeVault.xml** in the **C:\Vaults** directory.

## RELATED LINKS
