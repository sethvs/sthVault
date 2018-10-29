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

It can be created by the New-sthVault cmdlet.

You can use the New-sthVault with -VaultName or -VaultFilePath parameter.
-VaultName parameter creates an .xml file with the specified name under the Vaults folder in the module's directory.
-VaultFilePath parameters accepts path and name of the file, i.e. C:\Folder\file.xml, and creates it in the specified location.

Values can be of three types: PlainText, SecureString, and Credential.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -VaultName
Sepcifies vault name.

This is the vault, created by the New-sthVault cmdlet with the -VaultName parameter.

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

It is the path to .xml file, created by New-sthVault cmdlet with the -VaultFilePath parameter.

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

### -PropertyName
{{Fill PropertyName Description}}

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

### -PropertyType
{{Fill PropertyType Description}}

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

### -ShowSecureData
{{Fill ShowSecureData Description}}

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

## RELATED LINKS
