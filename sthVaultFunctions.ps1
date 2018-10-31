$VaultDirectory = 'Vaults'

# .externalhelp sthVault.help.xml
function New-sthVault
{
    [CmdletBinding(DefaultParameterSetName='VaultName')]
    Param(
        [Parameter(Mandatory,Position=0,ParameterSetName='VaultName')]
        [string]$VaultName,
        [Parameter(ParameterSetName='VaultFilePath')]
        [string]$VaultFilePath,
        [HashTable]$PlainText,
        [HashTable]$SecureString,
        [HashTable]$Credential
    )

    $Settings = [ordered]@{}

    foreach ($Setting in $PlainText.Keys)
    {
        $Settings.Add($Setting, $PlainText.$Setting)
    }

    foreach ($Setting in $SecureString.Keys)
    {
        if ($SecureString.$Setting.GetType().FullName -eq 'System.Security.SecureString')
        {
            $Settings.Add($Setting, $SecureString.$Setting)
        }
        else
        {
            $Settings.Add($Setting, $(ConvertTo-SecureString -String $($SecureString.$Setting) -AsPlainText -Force))
        }
    }

    foreach ($Setting in $Credential.Keys)
    {
        if ($Credential.$Setting.GetType().FullName -eq 'System.Management.Automation.PSCredential')
        {
            $Settings.Add($Setting, $Credential.$Setting)
        }
        elseif ($Credential.$Setting.GetType().BaseType.FullName -eq 'System.Array' -and $Credential.$Setting.Count -eq 2)
        {
            $PSCredentialObject = New-Object System.Management.Automation.PSCredential -ArgumentList $Credential.$Setting[0], $(ConvertTo-SecureString -String $Credential.$Setting[1] -AsPlainText -Force)
            $Settings.Add($Setting, $PSCredentialObject)
        }
        else
        {
            inPSCredentialError -Value $Credential.$Setting
        }
    }

    if ($Settings.Count)
    {
        if ($PSCmdlet.ParameterSetName -eq 'VaultName')
        {
            inWriteVault -VaultName $VaultName -Vault $Settings
        }
        if ($PSCmdlet.ParameterSetName -eq 'VaultFilePath')
        {
            inWriteVault -VaultFilePath $VaultFilePath -Vault $Settings
        }
    }
}

# .externalhelp sthVault.help.xml
function Get-sthVault
{
    [CmdletBinding(DefaultParameterSetName='VaultName')]
    Param(
        [Parameter(Position=0,ParameterSetName='VaultName')]
        [string]$VaultName,
        [Parameter(ParameterSetName='VaultFilePath')]
        [string]$VaultFilePath,
        [switch]$ShowSecureData,
        [ValidateSet('PlainText','SecureString','Credential')]
        [string[]]$PropertyType,
        [string[]]$PropertyName
    )

    if ($PSCmdlet.ParameterSetName -eq 'VaultName')
    {
        $FolderPath = Join-Path -Path $PSScriptRoot -ChildPath $VaultDirectory

        if (Test-Path -Path $FolderPath)
        {
            if ($VaultName)
            {
                $vault = Import-Clixml -Path "$FolderPath\$VaultName.xml"
            }
            else
            {
                foreach ($VaultPath in (Get-ChildItem -Path $("$FolderPath\*.xml") -File))
                {
                    $VaultPath.BaseName
                }
            }
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'VaultFilePath')
    {
        if (Test-Path $VaultFilePath)
        {
            $vault = Import-Clixml -Path $VaultFilePath
        }
    }

    if ($vault)
    {
        if ($PropertyType)
        {
            $vault = inSelectPropertyType -vault $vault -PropertyType $PropertyType
        }

        if ($PropertyName)
        {
            $vault = inSelectPropertyName -vault $vault -PropertyName $PropertyName
        }

        inComposeVault -Vault $vault -ShowSecureData:$ShowSecureData
    }
}

# .externalhelp sthVault.help.xml
function Remove-sthVault
{
    Param(
        [Parameter(Mandatory,Position=0,ParameterSetName='VaultName')]
        [string]$VaultName,
        [Parameter(ParameterSetName='VaultFilePath')]
        [string]$VaultFilePath
    )

    if ($PSCmdlet.ParameterSetName -eq 'VaultName')
    {
        $Path = Join-Path -Path $PSScriptRoot -ChildPath $VaultDirectory
        $Path = Join-Path -Path $Path -ChildPath $($VaultName + '.xml')
    }
    
    if ($PSCmdlet.ParameterSetName -eq 'VaultFilePath')
    {
        $Path = $VaultFilePath
    }

    Remove-Item -Path $Path
}

# .externalhelp sthVault.help.xml
function Set-sthVaultProperty
{
    [CmdletBinding(DefaultParameterSetName='VaultName')]
    Param(
        [Parameter(Mandatory,Position=0,ParameterSetName='VaultName')]
        [string]$VaultName,
        [Parameter(ParameterSetName='VaultFilePath')]
        [string]$VaultFilePath,
        [HashTable]$PlainText,
        [HashTable]$SecureString,
        [HashTable]$Credential
    )

    if ($PSCmdlet.ParameterSetName -eq 'VaultName')
    {
        $Settings = Get-sthVault -VaultName $VaultName
    }
    if ($PSCmdlet.ParameterSetName -eq 'VaultFilePath')
    {
        $Settings = Get-sthVault -VaultFilePath $VaultFilePath
    }

    foreach ($Setting in $PlainText.Keys)
    {
        if ($Settings.Contains($Setting))
        {
            $Settings.$Setting = $PlainText.$Setting
        }
        else
        {
            $Settings.Add($Setting, $PlainText.$Setting)
        }
    }

    foreach ($Setting in $SecureString.Keys)
    {
        if ($Settings.Contains($Setting))
        {
            if ($SecureString.$Setting.GetType().FullName -eq 'System.Security.SecureString')
            {
                $Settings.$Setting = $SecureString.$Setting
            }
            else
            {
                $Settings.$Setting = ConvertTo-SecureString -String $($SecureString.$Setting) -AsPlainText -Force
            }
        }
        else
        {
            if ($SecureString.$Setting.GetType().FullName -eq 'System.Security.SecureString')
            {
                $Settings.Add($Setting, $SecureString.$Setting)
            }
            else
            {
                $Settings.Add($Setting, $(ConvertTo-SecureString -String $($SecureString.$Setting) -AsPlainText -Force))
            }
        }
    }

    foreach ($Setting in $Credential.Keys)
    {
        if ($Credential.$Setting.GetType().FullName -eq 'System.Management.Automation.PSCredential')
        {
            if ($Settings.Contains($Setting))
            {
                $Settings.$Setting = $Credential.$Setting
            }
            else
            {
                $Settings.Add($Setting, $Credential.$Setting)
            }
        }
        elseif ($Credential.$Setting.GetType().BaseType.FullName -eq 'System.Array' -and $Credential.$Setting.Count -eq 2)
        {
            $PSCredentialObject = New-Object System.Management.Automation.PSCredential -ArgumentList $Credential.$Setting[0], $(ConvertTo-SecureString -String $Credential.$Setting[1] -AsPlainText -Force)

            if ($Settings.Contains($Setting))
            {
                $Settings.$Setting = $PSCredentialObject
            }
            else
            {
                $Settings.Add($Setting, $PSCredentialObject)
            }
        }
        else
        {
            inPSCredentialError -Value $Credential.$Setting
        }
    }

    $Settings = inComposeVault -Vault $Settings

    if ($PSCmdlet.ParameterSetName -eq 'VaultName')
    {
        inWriteVault -VaultName $VaultName -Vault $Settings
    }

    if ($PSCmdlet.ParameterSetName -eq 'VaultFilePath')
    {
        inWriteVault -VaultFilePath $VaultFilePath -Vault $Settings
    }
}

# .externalhelp sthVault.help.xml
function Remove-sthVaultProperty
{
    Param(
        [Parameter(Mandatory,Position=0,ParameterSetName='VaultName')]
        [string]$VaultName,
        [Parameter(ParameterSetName='VaultFilePath')]
        [string]$VaultFilePath,
        [string[]]$PropertyName
    )

    if ($PSCmdlet.ParameterSetName -eq 'VaultName')
    {
        $Settings = Get-sthVault -VaultName $VaultName
    }

    if ($PSCmdlet.ParameterSetName -eq 'VaultFilePath')
    {
        $Settings = Get-sthVault -VaultFilePath $VaultFilePath
    }

    foreach ($property in $PropertyName)
    {
        if ($Settings.Contains($property))
        {
            $Settings.Remove($property)
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'VaultName')
    {
        inWriteVault -VaultName $VaultName -Vault $Settings
    }

    if ($PSCmdlet.ParameterSetName -eq 'VaultFilePath')
    {
        inWriteVault -VaultFilePath $VaultFilePath -Vault $Settings
    }
}

function inComposeVault
{
    Param(
        $Vault,
        [switch]$ShowSecureData
    )

    $vaultSorted = @()
    $vaultSorted += $vault.GetEnumerator() | Where-Object -FilterScript {$_.Value.GetType().FullName -notin @('System.Management.Automation.PSCredential', 'System.Security.SecureString')} | Sort-Object -Property Name
    $vaultSorted += $vault.GetEnumerator() | Where-Object -FilterScript {$_.Value.GetType().FullName -eq 'System.Security.SecureString'} | Sort-Object -Property Name
    $vaultSorted += $vault.GetEnumerator() | Where-Object -FilterScript {$_.Value.GetType().FullName -eq 'System.Management.Automation.PSCredential'} | Sort-Object -Property Name

    $Settings = [ordered]@{}

    foreach ($v in $vaultSorted)
    {
        if ($ShowSecureData)
        {
            switch ($v.Value.GetType().FullName)
            {
                'System.Management.Automation.PSCredential'
                {
                    $value = @($v.value.UserName, [System.Net.NetworkCredential]::new('something', $v.Value.Password).Password)
                    $Settings.Add($v.Name, $value)
                }
                'System.Security.SecureString'
                {
                    $value = [System.Net.NetworkCredential]::new('something', $v.Value).Password
                    $Settings.Add($v.Name, $value)
                }
                default
                {
                    $Settings.Add($v.Name, $v.Value)
                }
            }
        }
        else
        {
            $Settings.Add($v.Name, $v.Value)
        }
    }

    if ($Settings.Count)
    {
        return $Settings
    }
}

function inWriteVault
{
    Param(
        [Parameter(ParameterSetName='VaultName')]
        [string]$VaultName,
        [Parameter(ParameterSetName='VaultFilePath')]
        [string]$VaultFilePath,
        $Vault
    )

    if ($PSCmdlet.ParameterSetName -eq 'VaultName')
    {
        $Path = Join-Path -Path $PSScriptRoot -ChildPath $VaultDirectory
        
        if (-not (Test-Path -Path $Path))
        {
            New-Item -Path $Path -ItemType Directory | Out-Null
        }
        
        $FilePath = Join-Path -Path $Path -ChildPath $($VaultName + '.xml')
    }

    if ($PSCmdlet.ParameterSetName -eq 'VaultFilePath')
    {
        $FilePath = $VaultFilePath
    }

    Export-Clixml -Path $FilePath -InputObject $Settings
}

function inPSCredentialError
{
    Param(
        [string]$Value
    )

    $Exception = [System.ArgumentException]::new("Value (`"$Value`") is wrong. The value should be a PSCredential object or an array of two elements.")
    $ErrorId = 'ArgumentTypeError'
    $ErrorCategory = [System.Management.Automation.ErrorCategory]::InvalidArgument

    $ErrorRecord = [System.Management.Automation.ErrorRecord]::new($Exception, $ErrorId, $ErrorCategory, $null)

    $PSCmdlet.WriteError($ErrorRecord)
}

function inSelectPropertyType
{
    Param (
        $vault,
        [string[]]$PropertyType
    )

    $PropertyType = $PropertyType | Sort-Object | Get-Unique
    $vlt = @{}
    
    foreach ($type in $PropertyType)
    {
        foreach ($key in $Vault.Keys)
        {
            switch ($type)
            {
                'PlainText'
                {
                    if ($vault.$key.GetType().FullName -notin @('System.Management.Automation.PSCredential','System.Security.SecureString'))
                    {
                        $vlt.Add($key, $vault.$key)
                    }
                }
                
                'SecureString'
                {
                    if ($vault.$key.GetType().FullName -eq 'System.Security.SecureString')
                    {
                        $vlt.Add($key, $vault.$key)
                    }
                }
                
                'Credential'
                {
                    if ($vault.$key.GetType().FullName -eq 'System.Management.Automation.PSCredential')
                    {
                        $vlt.Add($key, $vault.$key)
                    }
                }
            }
        }
    }

    return $vlt
}

function inSelectPropertyName
{
    Param (
        $vault,
        [string[]]$PropertyName
    )

    $vlt = @{}
    foreach ($key in $vault.Keys)
    {
        if ($PropertyName | Where-Object {$key -like $_})
        {
            $vlt.Add($key, $vault.$key)
        }
    }

    return $vlt
}
