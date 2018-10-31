---
external help file: sthVault-help.xml
Module Name: sthVault
online version:
schema: 2.0.0
---

# Remove-sthVault

## SYNOPSIS
Команда удаляет хранилище.

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
Функция Remove-sthVault удаляет указанное хранилище.

Параметр **-VaultName** удаляет хранилище с указанным именем из папки **Vaults**, расположенной в каталоге модуля.

Параметр **-VaultFilePath** удаляет файл хранилища, расположенный по указанному пути.

## PARAMETERS

### -VaultName
Указывает имя хранилища.

Функция удаляет хранилище с указанным именем из папки **Vaults**, расположенной в каталоге модуля.

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
Указывает путь и имя файла хранилища.

Этот параметр позволяет вам удалить файл хранилища, расположенный в произвольной локации.

Значение должно содержать путь и имя файла с расширением .xml.

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
Эта команда поддерживает общие параметры: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, и -WarningVariable.
Дополнительная информация: about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

Объекты **SecureString** и **PSCredential** используют DPAPI, таким образом хранилище, содержащее эти объекты, может быть использовано только на том компьютере, где оно было создано и только под той пользовательской учетной записью, под которой оно было создано.

## EXAMPLES

### Example 1
```powershell
Remove-sthVault -VaultName TheVault
```

Команда удаляет хранилище с указанным именем из папки **Vaults**, расположенной в каталоге модуля.

### Example 2
```powershell
Remove-sthVault -VaultFilePath C:\Vaults\SomeVault.xml
```

Команда удаляет файл хранилища с именем **SomeVault.xml**, расположенный в каталоге **C:\Vaults**.

## RELATED LINKS
