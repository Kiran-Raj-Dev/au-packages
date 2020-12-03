﻿$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$InstallLocation = Get-ToolsLocation
$version = '0.1.1'
Install-ChocolateyZipPackage `
  -PackageName "Pango Binaries" `
  -Url "https://github.com/ManimCommunity/pango-windows-binaries/releases/download/v0.1.0/pango-windows-binaires-x86.zip" `
  -UnzipLocation $InstallLocation `
  -Url64bit "https://github.com/ManimCommunity/pango-windows-binaries/releases/download/v0.1.0/pango-windows-binaires-x64.zip" `
  -Checksum "A12F6C6502346462C1C3FC5AA7B1D6DA33DAB4C904E0F9EB5889CB79ACB36871" `
  -ChecksumType "SHA256" `
  -Checksum64 "599E10248B90C408C95AA3429A4DBC4137702242BDDE919A417471E38B100802" `
  -ChecksumType64 "SHA256"
Install-ChocolateyPath "$InstallLocation\pango" 'Machine'
$python = (Get-Command python).source #to lock over specific python version
if ($python -eq $null){
	$python = (Get-Command python).Definition #support powershell 4 as it has different syntax for above one
}
Write-Host "Found python at '$python' using it."
Write-Host "Using python version $(python --version --version)" -ForegroundColor Red
$sitePackageFolder = cmd.exe /C "`"$python`" -m site --user-site"
New-Item -ItemType Directory -Force -Path "$sitePackageFolder"
$install = @{
  "python"            = $python
  "sitePackageFolder" = $sitePackageFolder
}  | ConvertTo-Json
New-Item -ItemType Directory -Force -Path "$InstallLocation\Manim"
New-Item "$InstallLocation\Manim\installInfo.json" -ItemType file -Value $install #save install info

Write-Host "Upgrading pip and install Wheel" -ForegroundColor Yellow
& "$python" -m pip install --upgrade pip wheel
Write-Host "Preparing Install" -ForegroundColor Yellow
& "$python" "$toolsDir\loadfiles.py" "$InstallLocation\pango"

$env:PATH = "$InstallLocation\pango;$env:PATH"
Write-Host "Installing Manim to $InstallLocation\Manim"
& "$python" -m pip install cffi --no-cache
& "$python" -m pip install pangocffi<0.7.0 --no-cache --no-binary :all:
& "$python" -m pip install pangocairocffi<0.4.0 --no-cache --no-binary :all:
& "$python" -m pip install "manimce==$version" --no-cache --compile --prefix="$InstallLocation\Manim" --no-warn-script-location --log="pip.log"

Write-Host "Making $python detect the Manim"
New-Item -ItemType Directory -Force -Path "$sitePackageFolder"
$pthFilePath = "$sitePackageFolder\manimce.pth"
$pthFileContent = "$InstallLocation\Manim\Lib\site-packages"
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines($pthFilePath, $pthFileContent, $Utf8NoBomEncoding)

Write-Host "Create a Batch File for Running Manim"
New-Item "$toolsDir\manim.bat" -ItemType file -Value "`@echo off
`"$python`" `"$toolsDir\loadfiles.py`" `"$InstallLocation\pango`"
`"$InstallLocation\Manim\Scripts\manim.exe`" %*"

New-Item "$toolsDir\manimce.bat" -ItemType file -Value "`@echo off
`"$python`" `"$toolsDir\loadfiles.py`" `"$InstallLocation\pango`"
`"$InstallLocation\Manim\Scripts\manimce.exe`" %*"

Install-BinFile `
  -Name "manim" `
  -Path "$toolsDir\manim.bat"

Install-BinFile `
  -Name "manimce" `
  -Path "$toolsDir\manimce.bat"

$files = get-childitem $InstallLocation -include *.exe -recurse
foreach ($file in $files) {
  #Remove unwanted files from been added to path.
  New-Item "$file.ignore" -type file -force | Out-Null
}
