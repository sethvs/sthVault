---
external help file: sthVault-help.xml
Module Name: sthVault
online version:
schema: 2.0.0
---

# Get-sthVault

## SYNOPSIS
Gets vault.

## SYNTAX

### VaultName (Default)
```
Get-sthVault [[-VaultName] <String>] [-ShowSecureData] [-PropertyType <String[]>] [-PropertyName <String[]>]
 [<CommonParameters>]
```

### VaultFilePath
```
Get-sthVault [-VaultFilePath <String>] [-ShowSecureData] [-PropertyType <String[]>] [-PropertyName <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Get-sthVault function gets existing vaults or specified vault and displays its content.

Vault is an .xml file, containing Name-Vaule pairs.

The vaults can be useful when you need to store some values, be it in the plain text form, SecureStrings or PSCredential object and then use them in automation scripts and workflows.

You can create the vault by using the `New-sthVault` function with the **-VaultName** or **-VaultFilePath** parameter. 

**-VaultName** parameter creates an .xml file with the specified name under the **Vaults** folder in the module's directory.

**-VaultFilePath** parameters accepts path and name of the file, i.e. C:\Folder\file.xml, and creates it in the specified location.

Values can be of three types: **PlainText**, **SecureString**, and **Credential**.

You can use the **-PlainText**, **-SecureString**, and **-Credential** parameters to specify needed vaules.
Each of these parameters accepts **HashTable** as an argument, which contains the Name-Vaule pairs.

For example:

$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringTwo = ConvertTo-SecureString -String 'Two' -AsPlainText -Force
$SecureString = @{SecureStringOne = 'One'; SecureStringTwo = $SecureStringTwo}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$CredentialTwo = New-Object System.Management.Automation.PSCredential -ArgumentList 'Two', $(ConvertTo-SecureString -String 'TwoPassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = $CredentialTwo}

New-sthVault -VaultName TheVault -PlainText $PlainText -SecureString $SecureString -Credential $Credential

You can get the vault's content by using the `Get-sthVault` cmdlet.

For example:

$Settings = Get-sthVault -VaultName TheVault

Then you can use it in automation scripts and workflows.

For example:

Get-SomeInfo -UserName $Settings.PlainTextOne -PasswordAsSecureString $Settings.SecureStringOne
ConnectTo-Something -Credential $Settings.CredentialOne
Get-SomeData -Credential $Settings.CredentialTwo

**SecureStrings** and **PSCredential** objects use DPAPI, which means that the vault, containing **SecureStrings** or **PSCredentials** can only be used on the computer it was created on, and under the user account, that created it.

## PARAMETERS

### -VaultName
Specifies vault name.

This is the vault, created by the `New-sthVault` cmdlet with the **-VaultName** parameter.

If omitted, returns all the vault names from the **Vaults** folder in the module's directory.

```yaml
Type: String
Parameter Sets: VaultName
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VaultFilePath
Specifies vault file path.

It is the path to .xml file, created by the `New-sthVault` cmdlet with the **-VaultFilePath** parameter.

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

### -PropertyType
Specifies property types to get from vault.

Accepted values are:

- PlainText
- SecureString
- Credential

**SecureStrings** and **PSCredential** objects use DPAPI, which means that the vault, containing **SecureStrings** or **PSCredentials** can only be used on the computer it was created on, and under the user account, that created it.


```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: PlainText, SecureString, Credential

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyName
Specifies the property names to get from vault.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowSecureData
Specifies that encrypted data, like the **SecureString** or **Credential** values should be returned in plain text.

**SecureStrings** and **PSCredential** objects use DPAPI, which means that the vault, containing **SecureStrings** or **PSCredentials** can only be used on the computer it was created on, and under the user account, that created it.


```yaml
Type: SwitchParameter
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
PS> Get-sthVault

SomeVault
AnotherVault
```

Command returns previously created vault's names from the **Vaults** folder in the module's directory.

### Example 2
```powershell
PS> Get-sthVault -VaultName TheVault

Name                           Value
----                           -----
PlainTextOne                   One
PlainTextTwo                   Two
SecureStringOne                System.Security.SecureString
SecureStringTwo                System.Security.SecureString
CredentialOne                  System.Management.Automation.PSCredential
CredentialTwo                  System.Management.Automation.PSCredential
```

Command returns data from the previously created vault named **TheVault**, which contains two plaintext values - **PlainTextOne** and **PlainTextTwo**, two SecureString values - **SecureStringOne** and **SecureStringTwo**, and two Credential values - **CredentialOne** and **CredentialTwo**.

### Example 3
```powershell
PS> Get-sthVault -VaultName TheVault -ShowSecureData 

Name                           Value
----                           -----
PlainTextOne                   One
PlainTextTwo                   Two
SecureStringOne                One
SecureStringTwo                Two
CredentialOne                  {One, OnePassword}
CredentialTwo                  {Two, TwoPassword}
```

Command returns data from the previously created vault named **TheVault**, showing encrypted values like **SecureStrings** and **Credentials** in plain text.

### Example 4
```powershell
PS> Get-sthVault -VaultFilePath C:\Vaults\SomeVault.xml

Name                           Value
----                           -----
PlainText                      SomeValue
SecureString                   System.Security.SecureString
Credential                     System.Management.Automation.PSCredential
```

Command returns data from the previously created vault file **C:\Vaults\SomeVault.xml**.

### Example 5
```powershell
PS> Get-sthVault -VaultName TheVault -PropertyType PlainText, SecureString

Name                           Value
----                           -----
PlainTextOne                   One
PlainTextTwo                   Two
SecureStringOne                System.Security.SecureString
SecureStringTwo                System.Security.SecureString
```

Command returns data from the previously created vault named **TheVault**, showing only properties with **PlainText** and **SecureString** values.

### Example 5
```powershell
PS> Get-sthVault -VaultName TheVault -PropertyName PlainTextOne, SecureStringTwo

Name                           Value
----                           -----
PlainTextOne                   One
SecureStringTwo                System.Security.SecureString
```

Command returns data from the previously created vault named **TheVault**, showing only **PlainTextOne** and **SecureStringTwo** properties.

### Example 6
```powershell
Get-sthVault -VaultName $VaultName -PropertyName *One

Name                           Value
----                           -----
PlainTextOne                   One
SecureStringOne                System.Security.SecureString
CredentialOne                  System.Management.Automation.PSCredential
```

Command returns data from the previously created vault named **TheVault**, showing only properties which names end with **One**.

## RELATED LINKS
