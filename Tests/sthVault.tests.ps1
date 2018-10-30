Remove-Module -Name sthVault -Force -ErrorAction 'SilentlyContinue'
Import-Module "$PSScriptRoot\..\sthVault.psd1"

Describe "sthVaultTests" {
    BeforeAll {
        [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments","")]
        $PlainText = @{PlainTextOne = 'One'; PlainTextTwo = 'Two'; PlainTextThree = 3}
        
        $SecureStringOne = ConvertTo-SecureString -String 'One' -AsPlainText -Force
        $SecureString = @{SecureStringOne = $SecureStringOne; SecureStringTwo = 'Two'; SecureStringThree = 3}

        $CredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList 'One', $(ConvertTo-SecureString -String 'OnePassword' -AsPlainText -Force)
        $CredentialTwo = New-Object System.Management.Automation.PSCredential -ArgumentList 'Two', $(ConvertTo-SecureString -String 'TwoPassword' -AsPlainText -Force)
        $CredentialThree = New-Object System.Management.Automation.PSCredential -ArgumentList 'Three', $(ConvertTo-SecureString -String 'ThreePassword' -AsPlainText -Force)
        $Credential = @{CredentialOne = $CredentialOne; CredentialTwo = $CredentialTwo; CredentialThree = $CredentialThree}
        
        $VaultName = '_Vault'
        $VaultFilePath = 'TestDrive:\_Vault.xml'

        $VaultDirectory = InModuleScope -ModuleName sthVault -ScriptBlock {$VaultDirectory}

        if (Test-Path -Path "$PSScriptRoot\..\$VaultDirectory" -PathType Container)
        {
            Rename-Item -Path "$PSScriptRoot\..\$VaultDirectory" -NewName _OriginalVaultsFolder
        }
    }

    AfterAll {
        Remove-Item -Path "$PSScriptRoot\..\$VaultDirectory"
        if (Test-Path -Path "$PSScriptRoot\..\_OriginalVaultsFolder")
        {
            Rename-Item -Path "$PSScriptRoot\..\_OriginalVaultsFolder" -NewName $VaultDirectory
        }
    }

    function TestVault
    {
        TestPlainText
        TestSecureString
        TestCredential
    }
    
    function TestVaultShowSecureData
    {
        TestPlainText
        TestSecureStringShowSecureData
        TestCredentialShowSecureData
    }

    function TestPlainText
    {
        It "Should contain PlainText property '<Name>' with a value '<Value>'" -TestCases @(
            @{Name = 'PlainTextOne'; Value = 'One'},
            @{Name = 'PlainTextTwo'; Value = 'Two'},
            @{Name = 'PlainTextThree'; Value = '3'}
        )   {
            Param ($Name, $Value)
            $Vault.$Name | Should -BeExactly $Value
        }
    }

    function TestSecureString
    {
        It "Should contain SecureString property '<Name>' with a value '<Value>'" -TestCases @(
            @{Name = 'SecureStringOne'; Value = 'One'},
            @{Name = 'SecureStringTwo'; Value = 'Two'},
            @{Name = 'SecureStringThree'; Value = '3'}
        )   {
            Param ($Name, $Value)
            [System.Net.NetworkCredential]::new('something', $Vault.$Name).Password | Should -BeExactly $Value
        }
    }

    function TestCredential
    {
        It "Should contain Credential property '<Name>' with a UserName value '<UserName>' and password '<Password>'" -TestCases @(
            @{Name = 'CredentialOne'; UserName = 'One'; Password = 'OnePassword'},
            @{Name = 'CredentialTwo'; UserName = 'Two'; Password = 'TwoPassword'},
            @{Name = 'CredentialThree'; UserName = 'Three'; Password = 'ThreePassword'}
        )   {
            [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword","")]
            Param ($Name, $UserName, $Password)
            $Vault.$Name.UserName | Should -BeExactly $UserName
            $Vault.$Name.GetNetworkCredential().Password | Should -BeExactly $Password
        }
    }

    function TestSecureStringShowSecureData
    {
        It "Should contain SecureString property '<Name>' with a value '<Value>'" -TestCases @(
            @{Name = 'SecureStringOne'; Value = 'One'},
            @{Name = 'SecureStringTwo'; Value = 'Two'},
            @{Name = 'SecureStringThree'; Value = '3'}
        )   {
            Param ($Name, $Value)
            $Vault.$Name | Should -BeExactly $Value
        }
    }

    function TestCredentialShowSecureData
    {
        It "Should contain Credential property '<Name>' with a UserName value '<UserName>' and password '<Password>'" -TestCases @(
            @{Name = 'CredentialOne'; UserName = 'One'; Password = 'OnePassword'},
            @{Name = 'CredentialTwo'; UserName = 'Two'; Password = 'TwoPassword'},
            @{Name = 'CredentialThree'; UserName = 'Three'; Password = 'ThreePassword'}
        )   {
            [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword","")]
            Param ($Name, $UserName, $Password)
            $Vault.$Name | Should -HaveCount 2
            $Vault.$Name[0] | Should -BeExactly $UserName
            $Vault.$Name[1] | Should -BeExactly $Password
        }
    }
    
    Context "New-sthVault -VaultName" {

        BeforeAll {
            New-sthVault -VaultName $VaultName -PlainText $PlainText -SecureString $Securestring -Credential $Credential

            It "Should create the vault" {
                Get-sthVault | Should -Contain $VaultName
            }
        }
        
        AfterAll {
            Remove-sthVault -VaultName $VaultName

            It "Should remove the vault" {
                Get-sthVault | Should -Not -Contain $VaultName
            }
        }
        

        Context "Vault content" {

            BeforeAll {
                $Vault = Get-sthVault -VaultName $VaultName
            }
            TestVault
        }

        Context "Vault content -ShowSecureData" {
            BeforeAll {
                $Vault = Get-sthVault -VaultName $VaultName -ShowSecureData
            }
            TestVaultShowSecureData
        }

        Context "Vault content -PropertyType and -PropertyName" {

            Context "PropertyType" {

                Context "PlainText" {

                    $Vault = Get-sthVault -VaultName $VaultName -PropertyType 'PlainText'

                    It "Should return PlainText properties" {
                        $Vault.Count | Should -BeExactly 3
                    }

                    TestPlainText
                }
                
                Context "SecureString" {
                    
                    $Vault = Get-sthVault -VaultName $VaultName -PropertyType 'SecureString'
    
                    It "Should return SecureString properties" {
                        $Vault.Count | Should -BeExactly 3
                    }
    
                    TestSecureString
                }

                Context "Credential" {

                    $Vault = Get-sthVault -VaultName $VaultName -PropertyType 'Credential'
    
                    It "Should return SecureString properties" {
                        $Vault.Count | Should -BeExactly 3
                    }

                    TestCredential
                }
            }

            Context "PropertyName" {

                Context "Properties 'PlainTextOne', 'PlainTextTwo' and 'PlainTextThree'" {

                    $Vault = Get-sthVault -VaultName $VaultName -PropertyName 'PlainTextOne', 'PlainTextTwo', 'PlainTextThree'

                    It "Should return 'PlainTextOne', 'PlainTextTwo' and 'PlainTextThree' properties" {
                        $Vault.Count | Should -BeExactly 3
                    }
                    TestPlainText
                }

                Context "Properties 'SecureStringOne', 'SecureStringTwo', 'SecureStringThree'" {
                    
                    $Vault = Get-sthVault -VaultName $VaultName -PropertyName 'SecureStringOne', 'SecureStringTwo', 'SecureStringThree'
                    
                    It "Should return 'SecureStringOne', 'SecureStringTwo', 'SecureStringThree' properties" {
                        $Vault.Count | Should -BeExactly 3
                    }
                    TestSecureString
                }

                Context "Properties 'CredentialOne', 'CredentialTwo' and 'CredentialThree'" {
                    
                    $Vault = Get-sthVault -VaultName $VaultName -PropertyName 'CredentialOne', 'CredentialTwo', 'CredentialThree'
                    
                    It "Should return 'CredentialOne', 'CredentialTwo' and 'CredentialThree' properties" {
                        $Vault.Count | Should -BeExactly 3
                    }
                    TestCredential
                }

                Context "Property 'PlainText*'" {

                    $Vault = Get-sthVault -VaultName $VaultName -PropertyName 'PlainText*'

                    It "Should return 'PlainTextOne', 'PlainTextTwo' and 'PlainTextThree' properties" {
                        $Vault.Count | Should -BeExactly 3
                    }
                    TestPlainText
                }
            }
        }

        Context "Set-sthVaultProperty" {

            It "Should change 'PlainTextOne' property" {
                Set-sthVaultProperty -VaultName $VaultName -PlainText @{PlainTextOne = 1}
                $property = Get-sthVault -VaultName $VaultName -PropertyName PlainTextOne
                $property.PlainTextOne | Should -BeExactly 1
            }

            It "Should add 'PlainTextFour' property" {
                Set-sthVaultProperty -VaultName $VaultName -PlainText @{PlainTextFour = 'Four'}
                $property = Get-sthVault -VaultName $VaultName -PropertyName PlainTextFour
                $property.PlainTextFour | Should -BeExactly 'Four'
            }

            It "Should change 'SecureStringOne' property" {
                Set-sthVaultProperty -VaultName $VaultName -SecureString @{SecureStringOne = 1}
                $property = Get-sthVault -VaultName $VaultName -PropertyName SecureStringOne
                [System.Net.NetworkCredential]::new('something', $property.SecureStringOne).Password | Should -BeExactly 1
            }

            It "Should change 'SecureStringTwo' property" {
                $SecureStringTwo = ConvertTo-SecureString -String '2' -AsPlainText -Force
                Set-sthVaultProperty -VaultName $VaultName -SecureString @{SecureStringTwo = $SecureStringTwo}
                $property = Get-sthVault -VaultName $VaultName -PropertyName SecureStringTwo
                [System.Net.NetworkCredential]::new('something', $property.SecureStringTwo).Password | Should -BeExactly 2
            }

            It "Should add 'SecureStringFour' property" {
                Set-sthVaultProperty -VaultName $VaultName -SecureString @{SecureStringFour = 'Four'}
                $property = Get-sthVault -VaultName $VaultName -PropertyName SecureStringFour
                [System.Net.NetworkCredential]::new('something', $property.SecureStringFour).Password | Should -BeExactly 'Four'
            }

            It "Should add 'SecureStringFive' property" {
                $SecureStringFive = ConvertTo-SecureString -String 'Five' -AsPlainText -Force
                Set-sthVaultProperty -VaultName $VaultName -SecureString @{SecureStringFive = $SecureStringFive}
                $property = Get-sthVault -VaultName $VaultName -PropertyName SecureStringFive
                [System.Net.NetworkCredential]::new('something', $property.SecureStringFive).Password | Should -BeExactly 'Five'
            }

            It "Should change 'CredentialOne' property" {
                $ChangeCredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList '1', $(ConvertTo-SecureString -String '1' -AsPlainText -Force)
                Set-sthVaultProperty -VaultName $VaultName -Credential @{CredentialOne = $ChangeCredentialOne}
                $property = Get-sthVault -VaultName $VaultName -PropertyName CredentialOne
                $property.CredentialOne.UserName | Should -BeExactly 1
                $property.CredentialOne.GetNetworkCredential().Password | Should -BeExactly 1
            }
            
            It "Should add 'CredentialFour' property" {
                $AddCredentialFour = New-Object System.Management.Automation.PSCredential -ArgumentList 'Four', $(ConvertTo-SecureString -String 'FourPassword' -AsPlainText -Force)
                Set-sthVaultProperty -VaultName $VaultName -Credential @{CredentialFour = $AddCredentialFour}
                $property = Get-sthVault -VaultName $VaultName -PropertyName CredentialFour
                $property.CredentialFour.UserName | Should -BeExactly 'Four'
                $property.CredentialFour.GetNetworkCredential().Password | Should -BeExactly 'FourPassword'
            }

            It "Non-Credential object as Credential parameter agrument in Set-sthVaultParameter" {
                { Set-sthVaultProperty -VaultName $VaultName -Credential @{NonCredential = 'nonCredential'} -ErrorAction Stop } | Should -Throw -ExceptionType System.ArgumentException
            }
        }

        Context "Remove-sthVaultProperty" {

            It "Should remove 'PlainTextFour' property" {
                Remove-sthVaultProperty -VaultName $VaultName -PropertyName PlainTextFour
                Get-sthVault -VaultName $VaultName -PropertyName PlainTextFour | Should -BeNullOrEmpty
            }
            
            It "Should remove 'SecureStringFour' property" {
                Remove-sthVaultProperty -VaultName $VaultName -PropertyName SecureStringFour
                Get-sthVault -VaultName $VaultName -PropertyName SecureStringFour | Should -BeNullOrEmpty
            }
            
            It "Should remove 'CredentialFour' property" {
                Remove-sthVaultProperty -VaultName $VaultName -PropertyName CredentialFour
                Get-sthVault -VaultName $VaultName -PropertyName CredentialFour | Should -BeNullOrEmpty
            }
        }
    }

    Context "New-sthVault -VaultFilePath" {

        BeforeAll {
            New-sthVault -VaultFilePath $VaultFilePath -PlainText $PlainText -SecureString $Securestring -Credential $Credential

            It "Should create the vault" {
                $VaultFilePath | Should -Exist
            }
        }
        
        AfterAll {
            Remove-sthVault -VaultFilePath $VaultFilePath

            It "Should remove the vault" {
                $VaultFilePath | Should -Not -Exist
            }
        }

        Context "Vault content" {

            BeforeAll {
                $Vault = Get-sthVault -VaultFilePath $VaultFilePath
            }
            TestVault
        }

        Context "Vault content -ShowSecureData" {
            BeforeAll {
                $Vault = Get-sthVault -VaultFilePath $VaultFilePath -ShowSecureData
            }
            TestVaultShowSecureData
        }

        Context "Vault content -PropertyType and -PropertyName" {

            Context "PropertyType" {

                Context "PlainText" {

                    $Vault = Get-sthVault -VaultFilePath $VaultFilePath -ShowSecureData -PropertyType 'PlainText'

                    It "Should return PlainText properties" {
                        $Vault.Count | Should -BeExactly 3
                    }

                    TestPlainText
                }
                
                Context "SecureString" {
                    
                    $Vault = Get-sthVault -VaultFilePath $VaultFilePath -ShowSecureData -PropertyType 'SecureString'
    
                    It "Should return SecureString properties" {
                        $Vault.Count | Should -BeExactly 3
                    }
    
                    TestSecureStringShowSecureData
                }

                Context "Credential" {

                    $Vault = Get-sthVault -VaultFilePath $VaultFilePath -ShowSecureData -PropertyType 'Credential'
    
                    It "Should return SecureString properties" {
                        $Vault.Count | Should -BeExactly 3
                    }
    
                    TestCredentialShowSecureData
                }
            }

            Context "PropertyName" {

                Context "Properties 'PlainTextOne', 'PlainTextTwo' and 'PlainTextThree'" {

                    $Vault = Get-sthVault -VaultFilePath $VaultFilePath -ShowSecureData -PropertyName 'PlainTextOne', 'PlainTextTwo', 'PlainTextThree'

                    It "Should return 'PlainTextOne', 'PlainTextTwo' and 'PlainTextThree' properties" {
                        $Vault.Count | Should -BeExactly 3
                    }
                    TestPlainText
                }
                
                Context "Properties 'SecureStringOne', 'SecureStringTwo', 'SecureStringThree'" {
                    
                    $Vault = Get-sthVault -VaultFilePath $VaultFilePath -ShowSecureData -PropertyName 'SecureStringOne', 'SecureStringTwo', 'SecureStringThree'

                    It "Should return 'SecureStringOne', 'SecureStringTwo', 'SecureStringThree' properties" {
                        $Vault.Count | Should -BeExactly 3
                    }
                    TestSecureStringShowSecureData
                }

                Context "Properties 'CredentialOne', 'CredentialTwo' and 'CredentialThree'" {

                    $Vault = Get-sthVault -VaultFilePath $VaultFilePath -ShowSecureData -PropertyName 'CredentialOne', 'CredentialTwo', 'CredentialThree'

                    It "Should return 'CredentialOne', 'CredentialTwo' and 'CredentialThree' properties" {
                        $Vault.Count | Should -BeExactly 3
                    }
                    TestCredentialShowSecureData
                }

                Context "Property 'PlainText*'" {

                    $Vault = Get-sthVault -VaultFilePath $VaultFilePath -PropertyName 'PlainText*'

                    It "Should return 'PlainTextOne', 'PlainTextTwo' and 'PlainTextThree' properties" {
                        $Vault.Count | Should -BeExactly 3
                    }
                    TestPlainText
                }
            }
        }

        Context "Set-sthVaultProperty" {

            It "Should change 'PlainTextOne' property" {
                Set-sthVaultProperty -VaultFilePath $VaultFilePath -PlainText @{PlainTextOne = 1}
                $property = Get-sthVault -VaultFilePath $VaultFilePath -PropertyName PlainTextOne
                $property.PlainTextOne | Should -BeExactly 1
            }

            It "Should add 'PlainTextFour' property" {
                Set-sthVaultProperty -VaultFilePath $VaultFilePath -PlainText @{PlainTextFour = 'Four'}
                $property = Get-sthVault -VaultFilePath $VaultFilePath -PropertyName PlainTextFour
                $property.PlainTextFour | Should -BeExactly 'Four'
            }

            It "Should change 'SecureString' property" {
                Set-sthVaultProperty -VaultFilePath $VaultFilePath -SecureString @{SecureStringOne = 1}
                $property = Get-sthVault -VaultFilePath $VaultFilePath -PropertyName SecureStringOne
                [System.Net.NetworkCredential]::new('something', $property.SecureStringOne).Password | Should -BeExactly 1
            }

            It "Should add 'PlainTextFour' property" {
                Set-sthVaultProperty -VaultFilePath $VaultFilePath -PlainText @{PlainTextFour = 'Four'}
                $property = Get-sthVault -VaultFilePath $VaultFilePath -PropertyName PlainTextFour
                $property.PlainTextFour | Should -BeExactly 'Four'
            }

            It "Should change 'Credential' property" {
                $ChangeCredentialOne = New-Object System.Management.Automation.PSCredential -ArgumentList '1', $(ConvertTo-SecureString -String '1' -AsPlainText -Force)
                Set-sthVaultProperty -VaultFilePath $VaultFilePath -Credential @{CredentialOne = $ChangeCredentialOne}
                $property = Get-sthVault -VaultFilePath $VaultFilePath -PropertyName CredentialOne
                $property.CredentialOne.UserName | Should -BeExactly 1
                $property.CredentialOne.GetNetworkCredential().Password | Should -BeExactly 1
            }

            It "Should add 'CredentialFour' property" {
                $AddCredentialFour = New-Object System.Management.Automation.PSCredential -ArgumentList 'Four', $(ConvertTo-SecureString -String 'FourPassword' -AsPlainText -Force)
                Set-sthVaultProperty -VaultFilePath $VaultFilePath -Credential @{CredentialFour = $AddCredentialFour}
                $property = Get-sthVault -VaultFilePath $VaultFilePath -PropertyName CredentialFour
                $property.CredentialFour.UserName | Should -BeExactly 'Four'
                $property.CredentialFour.GetNetworkCredential().Password | Should -BeExactly 'FourPassword'
            }

            It "Non-Credential object as Credential parameter agrument in Set-sthVaultParameter" {
                { Set-sthVaultProperty -VaultFilePath $VaultFilePath -Credential @{NonCredential = 'nonCredential'} -ErrorAction Stop } | Should -Throw -ExceptionType System.ArgumentException
            }

        }

        Context "Remove-sthVaultProperty" {

            It "Should remove 'PlainTextFour' property" {
                Remove-sthVaultProperty -VaultFilePath $VaultFilePath -PropertyName PlainTextFour
                Get-sthVault -VaultFilePath $VaultFilePath -PropertyName PlainTextFour | Should -BeNullOrEmpty
            }
            
            It "Should remove 'SecureStringFour' property" {
                Remove-sthVaultProperty -VaultFilePath $VaultFilePath -PropertyName SecureStringFour
                Get-sthVault -VaultFilePath $VaultFilePath -PropertyName SecureStringFour | Should -BeNullOrEmpty
            }
            
            It "Should remove 'CredentialFour' property" {
                Remove-sthVaultProperty -VaultFilePath $VaultFilePath -PropertyName CredentialFour
                Get-sthVault -VaultFilePath $VaultFilePath -PropertyName CredentialFour | Should -BeNullOrEmpty
            }
        }
    }

    It "Non-Credential object as Credential parameter agrument - New-sthVault" {
        { New-sthVault -VaultName 'er' -Credential @{NonCredential = 'nonCredential'} -ErrorAction Stop } | Should -Throw -ExceptionType System.ArgumentException
    }
}
