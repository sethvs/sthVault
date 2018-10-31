---
external help file: sthVault-help.xml
Module Name: sthVault
online version:
schema: 2.0.0
---

# New-sthVault

## SYNOPSIS
Creates the vault.

## SYNTAX

### VaultName (Default)
```
New-sthVault [-VaultName] <String> [-PlainText <Hashtable>] [-SecureString <Hashtable>] [-Credential <Hashtable>]
 [<CommonParameters>]
```

### VaultFilePath
```
New-sthVault [-VaultFilePath <String>] [-PlainText <Hashtable>] [-SecureString <Hashtable>]
 [-Credential <Hashtable>] [<CommonParameters>]
```

## DESCRIPTION
New-sthVault function creates the vault with the properties specified.

Vault is an .xml file, containing Name-Vaule pairs.

The vaults can be useful when you need to store some values, be it in the plain text form, SecureStrings or PSCredential object and then use them in automation scripts and workflows.

You can create the vault by using the **-VaultName** or **-VaultFilePath** parameter. 

**-VaultName** parameter creates an .xml file with the specified name under the **Vaults** folder in the module's directory.

**-VaultFilePath** parameters accepts path and name of the file, i.e. C:\Folder\file.xml, and creates it in the specified location.

Values can be of three types: **PlainText**, **SecureString**, and **Credential**.

You can use the **-PlainText**, **-SecureString**, and **-Credential** parameters to specify needed vaules.
Each of these parameters accepts **HashTable** as an argument, which contains the Name-Vaule pairs.

For example:

$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two', 'TwoPassword'}

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
Specifies the vault name.

Function creates the vault with the name specified under the **Vaults** folder in the module's directory.

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
Specifies the vault file path.

This parameter allows you to create vault file in an alternate location.

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

New-sthVault SomeVault -PlainText @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

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

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
New-sthVault SomeVault -SecureString @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

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

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)

New-sthVault SomeVault -Credential @{CredentialOne = $CredentialOne; CredentialTwo = 'Two', 'TwoPassword'}

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
$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two','TwoPassword'}

New-sthVault -VaultName TheVault -PlainText $PlainText -SecureString $Securestring -Credential $Credential
```

This command creates the vault with the name **TheVault**, which contains two plaintext values - **PlainTextOne** and **PlainTextTwo**, two SecureString values - **SecureStringOne** and **SecureStringTwo**, and two Credential values - **CredentialOne** and **CredentialTwo**.

The vault is created under the **Vaults** folder in the module's directory.

### Example 2
```powershell
$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two','TwoPassword'}

New-sthVault -VaultFilePath C:\Vaults\SomeVault.xml -PlainText $PlainText -SecureString $Securestring -Credential $Credential
```

This command creates the vault file with the name **SomeVault.xml** in the **C:\Vaults** directory.

## RELATED LINKS
