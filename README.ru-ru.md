# sthVault

**sthVault** - это модуль, содержащий пять функций, предназначенных для работы с хранилищами.

В модуль входят следующие функции:

[**Get-sthVault**](#get-sthvault) - Функция отображает список существующих хранилищ или содержимое указанного хранилища.

[**New-sthVault**](#new-sthvault) - Функция создает хранилище с указанными свойствами.

[**Set-sthVaultProperty**](#set-sthvaultproperty) - Функция добавляет новые свойства в указанное хранилище и изменяет значения существующих свойств.

[**Remove-sthVaultProperty**](#remove-sthvaultproperty) - Функция удаляет указанные свойства из хранилища.

[**Remove-sthVault**](#remove-sthvault) - Функция удаляет указанное хранилище.

## Что такое хранилище?

Хранилище (Vault) представляет из себя .xml файл, содержащий пары Имя-Значение.

Хранилища могут быть полезны если вам нужно сохранить некие значения, будь то обычный текст, объекты SecureString или PSCredential, с целью их использования в скриптах автоматизации или рабочих процессах.

Вы можете создать хранилище при помощи команды `New-sthVault` с параметром **-VaultName** или **-VaultFilePath**.

Параметр **-VaultName** создает .xml файл с указанным именем в папке **Vaults**, расположенной в каталоге модуля.

Параметр **-VaultFilePath** принимает в качестве значения путь и имя файла, например C:\Folder\file.xml, и создает его в указанном расположении.

Значения свойств хранилища могут быть трех типов: **PlainText**, **SecureString**, и **Credential**.

Вы можете использовать параметры **-PlainText**, **-SecureString**, и **-Credential** для создания требуемых свойств.
Каждый из этих параметров принимает в качестве значения хеш-таблицу (hashtable), содержащую пары Имя-Значение.

Например: 

```powershell
$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two', 'TwoPassword'}

New-sthVault -VaultName TheVault -PlainText $PlainText -SecureString $SecureString -Credential $Credential
```

Вы можете получить содержимое хранилица при помощи команды `Get-sthVault`.

Например:

```powershell
$Settings = Get-sthVault -VaultName TheVault
```

Затем, вы можете использовать его в скриптах автоматизации и рабочих процессах.

Например:

```powershell
Get-SomeInfo -UserName $Settings.PlainTextOne -PasswordAsSecureString $Settings.SecureStringOne
ConnectTo-Something -Credential $Settings.CredentialOne
Get-SomeData -Credential $Settings.CredentialTwo
```

Объекты **SecureString** и **PSCredential** используют DPAPI, таким образом хранилище, содержащее эти объекты, может быть использовано только на том компьютере, где оно было создано и только под той пользовательской учетной записью, под которой оно было создано.

## Как его установить?

Вы можете установить модуль sthVault из PowerShell Gallery:

```powershell
Install-Module sthVault
```

## Как с этим работать?

### Get-sthVault

#### Пример 1: Получение списка хранилищ

Команда отображает список созданных ранее хранилищ, находящихся в папке **Vaults**, расположенной в каталоге модуля.

```
Get-sthVault

SomeVault
AnotherVault
```

---

#### Пример 2: Получение содержимого хранилища

Команда отображает содержимое хранилища с именем **TheVault**, состоящее из двух свойств, сохраненных открытым текстом - **PlainTextOne** и **PlainTextTwo**, двух объектов SecureString -  **SecureStringOne** и **SecureStringTwo** и двух объектов PSCredential - **CredentialOne** and **CredentialTwo**.

```
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

---

#### Пример 3: Получение содержимого хранилища и представление зашифрованных элементов в расшифрованном виде

Команда отображает содержимое хранилища с именем **TheVault**, представляя зашифрованные значения, такие как объекты **SecureString** и **PSCredential**, в расшифрованном виде.

```
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

---

#### Пример 4: Получение содержимого файла хранилища, расположенного в указанном местоположении

Команда отображает содержимое файла хранилища с именем **SomeVault.xml**, расположенного в папке **C:\Vaults**.

```
Get-sthVault -VaultFilePath C:\Vaults\SomeVault.xml

Name                           Value
----                           -----
PlainText                      SomeValue
SecureString                   System.Security.SecureString
Credential                     System.Management.Automation.PSCredential
```

---

#### Пример 5: Получение свойств определенного типа

Команда получает содержимое хранилища с именем **TheVault**, возвращая только свойства со значениями типа **PlainText** и **SecureString**.

```
Get-sthVault -VaultName TheVault -PropertyType PlainText, SecureString

Name                           Value
----                           -----
PlainTextOne                   One
PlainTextTwo                   Two
SecureStringOne                System.Security.SecureString
SecureStringTwo                System.Security.SecureString
```

#### Пример 6: Получение свойств с определенными именами

Команда получает содержимое хранилища с именем **TheVault**, возвращая только свойства с именами **PlainTextOne** и **SecureStringTwo**.

```
Get-sthVault -VaultName TheVault -PropertyName PlainTextOne, SecureStringTwo

Name                           Value
----                           -----
PlainTextOne                   One
SecureStringTwo                System.Security.SecureString
```

---

#### Пример 7: Получение свойств с определенными именами с использованием символов подстановки

Команда получает содержимое хранилища с именем **TheVault**, возвращая только свойства, имена которых оканчиваются на **One**.

```
Get-sthVault -VaultName $VaultName -PropertyName *One

Name                           Value
----                           -----
PlainTextOne                   One
SecureStringOne                System.Security.SecureString
CredentialOne                  System.Management.Automation.PSCredential
```

### New-sthVault

#### Пример 1: Создание хранилища

Команда создает хранилища с именем **TheVault**, состоящее из двух свойств, сохраненных открытым текстом - **PlainTextOne** и **PlainTextTwo**, двух объектов SecureString -  **SecureStringOne** и **SecureStringTwo** и двух объектов PSCredential - **CredentialOne** and **CredentialTwo**.

Хранилище будет создано в папке **Vaults**, расположенной в каталоге модуля.

```
$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two','TwoPassword'}

New-sthVault -VaultName TheVault -PlainText $PlainText -SecureString $Securestring -Credential $Credential
```

---

#### Пример 2: Создание хранилища с указанием пути и имени файла

Команда создает файл хранилища с именем **SomeVault.xml**, расположенный в каталоге **C:\Vaults**.

```
$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two','TwoPassword'}

New-sthVault -VaultFilePath C:\Vaults\SomeVault.xml -PlainText $PlainText -SecureString $Securestring -Credential $Credential
```

### Set-sthVaultProperty

#### Пример 1: Изменение нескольких свойств и добавление новых

Команда изменяет значения свойств **PlainTextOne**, **SecureStringOne** и **CredentialOne**, и добавляет свойства **PlainTextThree**, **SecureStringThree** и **CredentialThree** в хранилище.

```
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

---

#### Пример 2: Изменение нескольких свойств и добавление новых в хранилище, расположенное по указанному пути

Команда изменяет значения свойств **PlainTextOne**, **SecureStringOne** и **CredentialOne**, и добавляет свойства **PlainTextThree**, **SecureStringThree** и **CredentialThree** в файл хранилища с именем **SomeVault.xml**, расположенный в каталоге **C:\Vaults**.

```
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

### Remove-sthVaultProperty

#### Пример 1: Удаление свойств из хранилища

Команда удаляет свойства **PropertyOne** и **PropertyTwo** из хранилища с именем **TheVault**, находящегося в папке **Vaults**, расположенной в каталоге модуля.

```
Remove-sthVaultProperty -VaultName TheVault -PropertyName PropertyOne, PropertyTwo
```

---

#### Пример 2: Удаление свойств из файла хранилища, расположенного по указанному пути

Команда удаляет свойства **PropertyOne** и **PropertyTwo** из файла хранилища с именем **SomeVault.xml**, расположенного в каталоге **C:\Vaults**.

```
Remove-sthVaultProperty -VaultFilePath C:\Vaults\SomeVault.xml -PropertyName PropertyOne, PropertyTwo
```

### Remove-sthVault

#### Пример 1: Удаление хранилища

Команда удаляет хранилище с указанным именем из папки **Vaults**, расположенной в каталоге модуля.

```
Remove-sthVault -VaultName TheVault
```

#### Пример 2: Удаление файла хранилища, расположенного по указанному пути

Команда удаляет файл хранилища с именем **SomeVault.xml**, расположенный в каталоге **C:\Vaults**.

```powershell
Remove-sthVault -VaultFilePath C:\Vaults\SomeVault.xml
```
