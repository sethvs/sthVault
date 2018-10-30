Describe "Docs test" {
    BeforeAll {
        New-Item -Path "$PSScriptRoot\..\testDocs" -ItemType Directory
        New-Item -Path "$PSScriptRoot\..\testDocs\en-us" -ItemType Directory
        New-Item -Path "$PSScriptRoot\..\testDocs\ru-ru" -ItemType Directory
    }

    AfterAll {
        Remove-Item -Path "$PSScriptRoot\..\testDocs" -Recurse
    }

    It "Should create en-us .xml help files from .md" {
        { New-ExternalHelp -Path "$PSScriptRoot\..\docs\en-us" -OutputPath "$PSScriptRoot\..\testDocs\en-us" } | Should -Not -Throw
        "$PSScriptRoot\..\testDocs\en-us\sthVault-help.xml" | Should -Exist
    }

    It "Should create ru-ru .xml help files from .md" {
        { New-ExternalHelp -Path "$PSScriptRoot\..\docs\ru-ru" -OutputPath "$PSScriptRoot\..\testDocs\ru-ru" } | Should -Not -Throw
        "$PSScriptRoot\..\testDocs\ru-ru\sthVault-help.xml" | Should -Exist
    }
}