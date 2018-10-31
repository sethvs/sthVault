---
external help file: sthVault-help.xml
Module Name: sthVault
online version:
schema: 2.0.0
---

# Remove-sthVault

## SYNOPSIS
Removes the vault.

## SYNTAX

### VaultName
```
Remove-sthVault [-VaultName] <String> [<CommonParameters>]
```

### VaultFilePath
```
Remove-sthVault [-VaultFilePath <String>] [<CommonParameters>]
```

## DESCRIPTION
Remove-sthVault function removes the vault specified.

The **-VaultName** parameter removes the vault located under the **Vaults** folder in the module's directory.

The **-VaultFilePath** parameter allows you to remove the vault file in the location other then the  **Vaults** folder in the module's directory.

## PARAMETERS

### -VaultName
Specifies vault name.

Function removes the vault with the name specified under the **Vaults** folder in the module's directory.

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

This parameter allows you to remove vault file, created in an alternate location.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## EXAMPLES

### Example 1
```powershell
Remove-sthVault -VaultName TheVault
```

This command removes the vault with the name specified from the **Vaults** folder in the module's directory.

### Example 2
```powershell
Remove-sthVault -VaultFilePath C:\Vaults\SomeVault.xml
```

This command removes the vault file with the name **SomeVault.xml** in the **C:\Vaults** directory.

## RELATED LINKS
