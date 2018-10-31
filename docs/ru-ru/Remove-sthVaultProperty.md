---
external help file: sthVault-help.xml
Module Name: sthVault
online version:
schema: 2.0.0
---

# Remove-sthVaultProperty

## SYNOPSIS
Команда удаляет свойства из хранилища.

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
Функция Remove-sthVaultProperty удаляет указанные свойства из хранилища.

## PARAMETERS

### -VaultName

Указывает имя хранилища.

Это имя хранилища, созданного при помощи команды `New-sthVault` с параметром **-VaultName**, находящегося в папке **Vaults**, расположенной в каталоге модуля.

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

Этот параметр позволяет вам использовать файл хранилища, расположенный в произвольной локации.

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

### -PropertyName
Указывает имена свойств, которые требуется удалить из хранилища.

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
Remove-sthVaultProperty -VaultName TheVault -PropertyName PropertyOne, PropertyTwo
```

Команда удаляет свойства **PropertyOne** и **PropertyTwo** из хранилища с именем **TheVault**, находящегося в папке **Vaults**, расположенной в каталоге модуля.

### Example 2
```powershell
Remove-sthVaultProperty -VaultFilePath C:\Vaults\SomeVault.xml -PropertyName PropertyOne, PropertyTwo
```

Команда удаляет свойства **PropertyOne** и **PropertyTwo** из файла хранилища с именем **SomeVault.xml**, расположенного в каталоге **C:\Vaults**.

## RELATED LINKS
