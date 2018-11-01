# sthVault
[![Build Status](https://dev.azure.com/sethv/seth/_apis/build/status/sthVault)](https://dev.azure.com/sethv/seth/_build/latest?definitionId=5)

**sthVault** - is a module, containing five functions for working with vaults.

It contains following functions:

[**Get-sthVault**](#get-sthvault) - Function gets existing vaults or displays content of the specified vault.

[**New-sthVault**](#new-sthvault) - Function creates the vault with the properties specified.

[**Set-sthVaultProperty**](#set-sthvaultproperty) - Function adds new properties or changes values of the existing properties in the vault.

[**Remove-sthVaultProperty**](#remove-sthvaultproperty) - Function removes specified properties from the vault.

[**Remove-sthVault**](#remove-sthvault) - Function removes the vault specified.

## What is the vault?

Vault is an .xml file, containing Name-Value pairs.

The vaults can be useful when you need to store some values, be it in the plain text form, SecureStrings or PSCredential object and then use them in automation scripts and workflows.

You can create the vault by using the `New-sthVault` function with the **-VaultName** or **-VaultFilePath** parameter. 

**-VaultName** parameter creates an .xml file with the specified name under the **Vaults** folder in the module's directory.

**-VaultFilePath** parameters accepts path and name of the file, i.e. C:\Folder\file.xml, and creates it in the specified location.

Values can be of three types: **PlainText**, **SecureString**, and **Credential**.

You can use the **-PlainText**, **-SecureString**, and **-Credential** parameters to specify needed vaules.
Each of these parameters accepts **HashTable** as an argument, which contains the Name-Value pairs.

For example:
```powershell
$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two', 'TwoPassword'}

New-sthVault -VaultName TheVault -PlainText $PlainText -SecureString $SecureString -Credential $Credential
```

You can get the vault's content by using the `Get-sthVault` function.

For example:

```powershell
$Settings = Get-sthVault -VaultName TheVault
```

Then you can use it in automation scripts and workflows.

For example:

```powershell
Get-SomeInfo -UserName $Settings.PlainTextOne -PasswordAsSecureString $Settings.SecureStringOne
ConnectTo-Something -Credential $Settings.CredentialOne
Get-SomeData -Credential $Settings.CredentialTwo
```

**SecureString** and **PSCredential** objects use DPAPI, which means that the vault, containing **SecureStrings** or **PSCredentials** can only be used on the computer it was created on, and under the user account, that created it.

## How to install it?

You can install sthVault module from PowerShell Gallery:

```powershell
Install-Module sthVault
```

## How to use it?

### Get-sthVault

#### Example 1: Get vault list

This command returns previously created vault's names from the **Vaults** folder in the module's directory.

```
Get-sthVault

SomeVault
AnotherVault
```

---

#### Example 2: Get vault content

This command returns data from the previously created vault named **TheVault**, which contains two plaintext values - **PlainTextOne** and **PlainTextTwo**, two SecureString values - **SecureStringOne** and **SecureStringTwo**, and two Credential values - **CredentialOne** and **CredentialTwo**.

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

#### Example 3: Get vault content and show encrypted data

This command returns data from the previously created vault named **TheVault**, showing encrypted values like **SecureStrings** and **Credentials** in plain text.

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

#### Example 4: Get vault content from the vault file in alternate location

This command returns data from the previously created vault file **C:\Vaults\SomeVault.xml**.

```
Get-sthVault -VaultFilePath C:\Vaults\SomeVault.xml

Name                           Value
----                           -----
PlainText                      SomeValue
SecureString                   System.Security.SecureString
Credential                     System.Management.Automation.PSCredential
```

---

#### Example 5: Get vault properties of specified type only

This command returns data from the previously created vault named **TheVault**, showing only properties with **PlainText** and **SecureString** values.

```
Get-sthVault -VaultName TheVault -PropertyType PlainText, SecureString

Name                           Value
----                           -----
PlainTextOne                   One
PlainTextTwo                   Two
SecureStringOne                System.Security.SecureString
SecureStringTwo                System.Security.SecureString
```

---

#### Example 6: Get vault properties with specified names only

This command returns data from the previously created vault named **TheVault**, showing only **PlainTextOne** and **SecureStringTwo** properties.

```
Get-sthVault -VaultName TheVault -PropertyName PlainTextOne, SecureStringTwo

Name                           Value
----                           -----
PlainTextOne                   One
SecureStringTwo                System.Security.SecureString
```

---

#### Example 7: Get vault properties with specified names using wildcards

This command returns data from the previously created vault named **TheVault**, showing only properties which names end with **One**.

```
Get-sthVault -VaultName $VaultName -PropertyName *One

Name                           Value
----                           -----
PlainTextOne                   One
SecureStringOne                System.Security.SecureString
CredentialOne                  System.Management.Automation.PSCredential
```

### New-sthVault

#### Example 1: Create the vault

This command creates the vault with the name **TheVault**, which contains two plaintext values - **PlainTextOne** and **PlainTextTwo**, two SecureString values - **SecureStringOne** and **SecureStringTwo**, and two Credential values - **CredentialOne** and **CredentialTwo**.

The vault is created under the **Vaults** folder in the module's directory.

```
$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two','TwoPassword'}

New-sthVault -VaultName TheVault -PlainText $PlainText -SecureString $Securestring -Credential $Credential
```

---

#### Example 2: Create the vault file at the specified path

This command creates the vault file with the name **SomeVault.xml** in the **C:\Vaults** directory.

```
$PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'}

$SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
$SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'}

$CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
$Credential = @{CredentialOne = $CredentialOne; CredentialTwo = 'Two','TwoPassword'}

New-sthVault -VaultFilePath C:\Vaults\SomeVault.xml -PlainText $PlainText -SecureString $Securestring -Credential $Credential
```

### Set-sthVaultProperty

#### Example 1: Change several properties and add new ones to the vault

This command changes **PlainTextOne**, **SecureStringOne**, and **CredentialOne** properties and adds **PlainTextThree**, **SecureStringThree**, and **CredentialThree** properties to the vault.

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

#### Example 2: Change several properties and add new ones to the vault file at the path specified

This command changes **PlainTextOne**, **SecureStringOne**, and **CredentialOne** properties and adds **PlainTextThree**, **SecureStringThree**, and **CredentialThree** properties to the vault file with the name **SomeVault.xml** in the **C:\Vaults** directory.

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

#### Example 1: Remove properties from the vault

This command removes the **PropertyOne** and **PropertyTwo** properties from the vault **TheVault** located under the **Vaults** folder in the module's directory.

```
Remove-sthVaultProperty -VaultName TheVault -PropertyName PropertyOne, PropertyTwo
```

---

#### Example 2: Remove properties from the vault file at the path specified

This command removes the **PropertyOne** and **PropertyTwo** properties from the vault file with the name **SomeVault.xml** in the **C:\Vaults** directory.

```
Remove-sthVaultProperty -VaultFilePath C:\Vaults\SomeVault.xml -PropertyName PropertyOne, PropertyTwo
```

### Remove-sthVault

#### Example 1: Remove the vault

This command removes the vault with the specified name from the **Vaults** folder in the module's directory.

```
Remove-sthVault -VaultName TheVault
```

---

#### Example 2: Remove the vault file at the specified path

This command removes the vault file with the name **SomeVault.xml** in the **C:\Vaults** directory.

```
Remove-sthVault -VaultFilePath C:\Vaults\SomeVault.xml
```
