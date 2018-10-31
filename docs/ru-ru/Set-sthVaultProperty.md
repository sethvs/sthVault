---
external help file: sthVault-help.xml
Module Name: sthVault
online version:
schema: 2.0.0
---

# Set-sthVaultProperty

## SYNOPSIS
Команда добавляет новые свойства в хранилище и изменияет значения существующих.

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
Функция Set-sthVaultProperty добавляет новые свойства в указанное хранилище и изменияет значения существующих.

Значения свойств хранилища могут быть трех типов: **PlainText**, **SecureString**, и **Credential**.

Вы можете использовать параметры **-PlainText**, **-SecureString**, и **-Credential** для задания требуемых свойств.
Каждый из этих параметров принимает в качестве значания хеш-таблицу (hashtable), содержащую пары Имя-Значение.

## PARAMETERS

### -VaultName
Указывает имя хранилища.

Это имя хранилища, созданного при помощи команды `New-sthVault` с параметром **-VaultName**, находящего в папке **Vaults**, расположенной в каталоге модуля.

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

### -PlainText
Указывает свойства, значения которых должны быть сохранены открытым текстом.

Параметр принимает в качестве значения хеш-таблицу (hashtable), содержащую пары Имя-Значение.

Например:

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
Указывает свойства, значения которых должны быть сохранены в виде объекта SecureString.

Параметр принимает в качестве значения хеш-таблицу (hashtable), содержащую пары Имя-Значение.

Значения хэш-таблицы могут быть как объектами SecureString, так и открытым текстом.

Если значение представлено открытым текстом, оно будет преобразовано в объект SecureString.

Например:

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
Указывает свойства, значения которых должны быть сохранены в виде объекта PSCredential.

Параметр принимает в качестве значения хеш-таблицу (hashtable), содержащую пары Имя-Значение.

Значения хэш-таблицы могут быть как объектами PSCredential, так и массивом, состоящим из двух элементов, к примеру - @{Credential = 'Name', 'Password'}

Если значение представлено в виде массива, оно будет преобразовано в объект PSCredential.

Например:

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
Эта команда поддерживает общие параметры: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, и -WarningVariable.
Дополнительная информация: about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

Объекты **SecureStrings** и **PSCredential** используют DPAPI, таким образом хранилище, содержащее эти объекты, может быть использовано только на том компьютере, где оно было создано, и только под той пользовательской учетной записью, под которой оно было создано.

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

Команда изменяет значения свойств **PlainTextOne**, **SecureStringOne** и **CredentialOne**, и добавляет свойства **PlainTextThree**, **SecureStringThree** и **CredentialThree** в хранилище.

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

Команда изменяет значения свойств **PlainTextOne**, **SecureStringOne** и **CredentialOne**, и добавляет свойства **PlainTextThree**, **SecureStringThree** и **CredentialThree** в файл хранилища с именем **SomeVault.xml**, расположенный в каталоге **C:\Vaults**.

## RELATED LINKS
