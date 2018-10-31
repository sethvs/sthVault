---
external help file: sthVault-help.xml
Module Name: sthVault
online version:
schema: 2.0.0
---

# Get-sthVault

## SYNOPSIS
Команда отображает содержимое хранилища.

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
Функция Get-sthVault отображает список существующих хранилищ или содержимое указанного хранилища.

Хранилище (Vault) представляет из себя .xml файл, содержащий пары Имя-Значение.

Хранилища могут быть полезны если вам нужно сохранить некие значения, будь то обычный текст, объекты SecureString или PSCredential, с целью их использования в скриптах автоматизации или рабочих процессах.

Вы можете создать хранилище при помощи команды `New-sthVault` с параметром **-VaultName** или **-VaultFilePath**.

Параметр **-VaultName** создает .xml файл с указанным именем в папке **Vaults**, расположенной в каталоге модуля.

Параметр **-VaultFilePath** принимает в качестве значения путь и имя файла, например C:\Folder\file.xml, и создает его в указанном расположении.

Значения свойств хранилища могут быть трех типов: **PlainText**, **SecureString**, и **Credential**.

Вы можете использовать параметры **-PlainText**, **-SecureString**, и **-Credential** для создания требуемых свойств.
Каждый из этих параметров принимает в качестве значения хеш-таблицу (hashtable), содержащую пары Имя-Значение.

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

Объекты **SecureString** и **PSCredential** используют DPAPI, таким образом хранилище, содержащее эти объекты, может быть использовано только на том компьютере, где оно было создано и только под той пользовательской учетной записью, под которой оно было создано.

## PARAMETERS

### -VaultName
Указывает имя хранилища.

Это имя хранилища, созданного при помощи команды `New-sthVault` с параметром **-VaultName**, находящегося в папке **Vaults**, расположенной в каталоге модуля.

Если параметр отсутствует, команда выводит имена всех хранилищ, находящихся в папке **Vaults**, расположенной в каталоге модуля.

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
Указывает путь и имя файла хранилища.

Это путь и имя файла .xml, созданного при помощи команды `New-sthVault` с параметром **-VaultFilePath**.

Этот параметр позволяет вам использовать файл хранилища, расположенный в произвольной локации.

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
Указывает типы свойств, которые требуется получить из хранилища.

Параметр принимает следующие значения:

- PlainText
- SecureString
- Credential

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
Указывает имена свойств, которые требуется получить из хранилища.

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
Указывает, что зашифрованные данные, такие как значения **SecureString** или **Credential**, должны быть представлены в расшифрованном виде.

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
Get-sthVault

SomeVault
AnotherVault
```

Команда отображает список созданных ранее хранилищ, находящихся в папке **Vaults**, расположенной в каталоге модуля.

### Example 2
```powershell
Get-sthVault -VaultName TheVault

Name                           Value
----                           -----
PlainTextOne                   One
PlainTextTwo                   Two
SecureStringOne                System.Security.SecureString
SecureStringTwo                System.Security.SecureString
CredentialOne                  System.Management.Automation.PSCredential
CredentialTwo                  System.Management.Automation.PSCredential
```

Команда отображает содержимое хранилища с именем **TheVault**, состоящее из двух свойств, сохраненных открытым текстом - **PlainTextOne** и **PlainTextTwo**, двух объектов SecureString -  **SecureStringOne** и **SecureStringTwo** и двух объектов PSCredential - **CredentialOne** and **CredentialTwo**.

### Example 3
```powershell
Get-sthVault -VaultName TheVault -ShowSecureData 

Name                           Value
----                           -----
PlainTextOne                   One
PlainTextTwo                   Two
SecureStringOne                One
SecureStringTwo                Two
CredentialOne                  {One, OnePassword}
CredentialTwo                  {Two, TwoPassword}
```

Команда отображает содержимое хранилища с именем **TheVault**, представляя зашифрованные значения, такие как объекты **SecureString** и **PSCredential**, в расшифрованном виде.

### Example 4
```powershell
Get-sthVault -VaultFilePath C:\Vaults\SomeVault.xml

Name                           Value
----                           -----
PlainText                      SomeValue
SecureString                   System.Security.SecureString
Credential                     System.Management.Automation.PSCredential
```

Команда отображает содержимое файла хранилища с именем **SomeVault.xml**, расположенного в папке **C:\Vaults**.

### Example 5
```powershell
Get-sthVault -VaultName TheVault -PropertyType PlainText, SecureString

Name                           Value
----                           -----
PlainTextOne                   One
PlainTextTwo                   Two
SecureStringOne                System.Security.SecureString
SecureStringTwo                System.Security.SecureString
```

Команда получает содержимое хранилища с именем **TheVault**, возвращая только свойства со значениями типа **PlainText** и **SecureString**.

### Example 6
```powershell
Get-sthVault -VaultName TheVault -PropertyName PlainTextOne, SecureStringTwo

Name                           Value
----                           -----
PlainTextOne                   One
SecureStringTwo                System.Security.SecureString
```

Команда получает содержимое хранилища с именем **TheVault**, возвращая только свойства с именами **PlainTextOne** и **SecureStringTwo**.

### Example 7
```powershell
Get-sthVault -VaultName $VaultName -PropertyName *One

Name                           Value
----                           -----
PlainTextOne                   One
SecureStringOne                System.Security.SecureString
CredentialOne                  System.Management.Automation.PSCredential
```

Команда получает содержимое хранилища с именем **TheVault**, возвращая только свойства, имена которых оканчиваются на **One**.

## RELATED LINKS
