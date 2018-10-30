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


<!-- Since SecureString uses DPAPI, if you create the vault containing SecureStrings or Credentials, it can only be used on the computer it was created on and by the user account that created it. -->

<!-- By default password is encrypted by using DPAPI, which means that the profile can be used only on the computer it was created on, and under user account, that created it. -->


## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Credential
{{Fill Credential Description}}

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

### -PlainText
{{Fill PlainText Description}}

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
{{Fill SecureString Description}}

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

### -VaultFilePath
{{Fill VaultFilePath Description}}

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

### -VaultName
{{Fill VaultName Description}}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
