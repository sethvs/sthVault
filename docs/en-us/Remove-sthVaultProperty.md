---
external help file: sthVault-help.xml
Module Name: sthVault
online version:
schema: 2.0.0
---

# Remove-sthVaultProperty

## SYNOPSIS
Removes the vault property.

## SYNTAX

### VaultName
```
Remove-sthVaultProperty [-VaultName] <String> [-PropertyName <String[]>] [<CommonParameters>]
```

### VaultFilePath
```
Remove-sthVaultProperty [-VaultFilePath <String>] [-PropertyName <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Remove-sthVaultProperty function removes the properties specified from the vault.

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

### -PropertyName
Specifies property names to remove fron the vault.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

**SecureString** and **PSCredential** objects use DPAPI, which means that the vault, containing **SecureStrings** or **PSCredentials** can only be used on the computer it was created on, and under the user account, that created it.

## EXAMPLES

### Example 1
```powershell
Remove-sthVaultProperty -VaultName TheVault -PropertyName PropertyOne, PropertyTwo
```

This command removes the **PropertyOne** and **PropertyTwo** properties from the vault **TheVault** located under the **Vaults** folder in the module's directory.

### Example 2
```powershell
Remove-sthVaultProperty -VaultFilePath C:\Vaults\SomeVault.xml -PropertyName PropertyOne, PropertyTwo
```

This command removes the **PropertyOne** and **PropertyTwo** properties from the vault file with the name **SomeVault.xml** in the **C:\Vaults** directory.

## RELATED LINKS
