---
external help file: sthVault-help.xml
Module Name: sthVault
online version:
schema: 2.0.0
---

# New-sthVault

## SYNOPSIS
Команда создает хранилище.
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
Функция New-sthVault создает хранилище с указанными свойствами.

Хранилище (Vault) представляет из себя .xml файл, содержащие пары Имя-Значение.

Хранилища могут быть полезными если вам нужно сохранить некие значения, будь то обычный текст, объекты SecureString или PSCredential, с целью их использования в скриптах автоматизации или рабочих процессах.

Вы можете создать хранилище при помощи параметров **-VaultName** или **-VaultFilePath**.

Параметр **-VaultName** создает .xml файл с указанным именем в папке **Vaults**, расположенной в каталоге модуля.

Параметр **-VaultFilePath** принимает в качестве значения путь и имя файла, например C:\Folder\file.xml, и создает его в указанном расположении.

Значения свойств хранилища могут быть трех типов: **PlainText**, **SecureString**, и **Credential**.

Вы можете использовать параметры **-PlainText**, **-SecureString**, и **-Credential** для создания требуемых свойств.
Каждый из этих параметров принимает в качестве значания хеш-таблицу (hashtable), содержащую пары Имя-Значение.

Например: 

$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two', 'TwoPassword'}

New-sthVault -VaultName TheVault -PlainText $PlainText -SecureString $SecureString -Credential $Credential

Вы можете получить содержимое хранилица при помощи команды `Get-sthVault`.

Например:

$Settings = Get-sthVault -VaultName TheVault

Затем, вы можете использовать его в скриптах автоматизации и рабочих процессах.

Например:

Get-SomeInfo -UserName $Settings.PlainTextOne -PasswordAsSecureString $Settings.SecureStringOne
ConnectTo-Something -Credential $Settings.CredentialOne
Get-SomeData -Credential $Settings.CredentialTwo

Объекты **SecureStrings** и **PSCredential** используют DPAPI, таким образом хранилище, содержащее эти объекты, может быть использовано только на том компьютере, где оно было создано, и только под той пользовательской учетной записью, под которой оно было создано.

## PARAMETERS

### -VaultName
Указывает имя хранилища.

Функция создает хранилище с указанным именем в папке **Vaults**, расположенной в каталоге модуля.

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

Этот параметр позволяет вам создать файл хранилища, расположенный в произвольной локации.

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
Указывает свойства, значения которых должны быть сохранены в виде объекта SecureString.

Параметр принимает в качестве значения хеш-таблицу (hashtable), содержащую пары Имя-Значение.

Значения хэш-таблицы могут быть как объектами SecureString, так и открытым текстом.

Если значение представлено открытым текстом, оно будет преобразовано в объект SecureString.

Например:

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
Указывает свойства, значения которых должны быть сохранены в виде объекта PSCredential.

Параметр принимает в качестве значения хеш-таблицу (hashtable), содержащую пары Имя-Значение.

Значения хэш-таблицы могут быть как объектами PSCredential, так и массивом, состоящим из двух элементов, к примеру - @{Credential = 'Name', 'Password'}

Если значение представлено в виде массива, оно будет преобразовано в объект PSCredential.

Например:

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
$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two','TwoPassword'}

New-sthVault -VaultName TheVault -PlainText $PlainText -SecureString $Securestring -Credential $Credential
```

Команда создает хранилища с именем **TheVault**, состоящее из двух свойств, сохраненных открытым текстом - **PlainTextOne** и **PlainTextTwo**, двух объектов SecureString -  **SecureStringOne** и **SecureStringTwo**, и двух объектов PSCredential - **CredentialOne** and **CredentialTwo**.

Хранилище будет создано в папке **Vaults**, расположенной в каталоге модуля.

### Example 2
```powershell
$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two','TwoPassword'}

New-sthVault -VaultFilePath C:\Vaults\SomeVault.xml -PlainText $PlainText -SecureString $Securestring -Credential $Credential
```

Команда создает файл хранилища с именем **SomeVault.xml**, расположенный в каталоге **C:\Vaults**.

## RELATED LINKS
