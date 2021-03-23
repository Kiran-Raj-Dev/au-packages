$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$InstallLocation = "$(Get-ToolsLocation)\Nim"

. $toolsDir\helper.ps1

$pp = Get-PackageParameters

if (!$pp['AddToPath']) {
    $pp['AddToPath'] = 'true'
}

if (!$pp['InstallGCC']) {
    $pp['InstallGCC'] = 'true'
}

$packageArgs = @{
    Destination    = $InstallLocation
    FileFullPath   = "$(Get-Item $toolsDir\nim-*_x32.zip)"
    FileFullPath64 = "$(Get-Item $toolsDir\nim-*_x64.zip)"
}
Get-ChocolateyUnzip @packageArgs

$AddToPath = StrToBool $pp['AddToPath']
if ($AddToPath) {
    # REF: https://nim-lang.org/install_windows.html#configuring-the-path-environment-variable
    Install-ChocolateyPath -PathToInstall "$(Get-Item $InstallLocation\*)\bin"
    Install-ChocolateyPath -PathToInstall "$($env:USERPROFILE)\.nimble\bin"
}

$InstallGCC = StrToBool $pp['InstallGCC']
if ($InstallGCC) {
    mkdir "$(Get-Item $InstallLocation\*)\dist"
    $processArgs = @{
        ExeToRun         = "$(Get-Item $InstallLocation\*\finish.exe)"
        Statements       = "-y"
        WorkingDirectory = "$(Get-Item $InstallLocation\*)"
    }
    Start-ChocolateyProcessAsAdmin @processArgs
}

# silent chocolatey from shiming things.
$files = Get-Childitem $InstallLocation -include *.exe -recurse
foreach ($file in $files) {
    New-Item "$file.ignore" -type file -force | Out-Null
}
