<#
.SYNOPSIS
Generates random files with specified size and extension.

.DESCRIPTION
This script generates random files with specified size and extension. The number of files to generate, path to generate files, size of the file, and extension of the file are provided as parameters.

.PARAMETER loopCount
Number of files to generate.

.PARAMETER Path
Path to generate files.

.PARAMETER FileSize
Size of the file.

.PARAMETER Extension
Extension of the file.

.EXAMPLE
.\generatedata.ps1 -loopCount 10 -Path "C:\temp" -FileSize 1024 -Extension "txt"
This example generates 10 random text files with a size of 1024 bytes each in the C:\temp directory.

.NOTES
Author: Ramu Venkitaramanan
Date: 18 October 2023
Version: 1.0
#>

param (
    [Parameter(Mandatory = $true)]
    [string] $loopCount,        #Number of files to generate
    [Parameter(Mandatory = $true)]
    [string] $Path,             # Path to generate files.
    [Parameter(Mandatory = $true)]
    [string] $FileSize,        # Size of the file
    [Parameter(Mandatory = $true)]
    [string] $Extension       # Extension of the file
)

Function New-RandomFile {
    Param(
        $Path = $Path, 
        $FileSize = $FileSize, 
        $Extension = $Extension,
        $FileName = [guid]::NewGuid().Guid + ".$Extension"
        ) 
    (1..($FileSize/128)).foreach({-join ([guid]::NewGuid().Guid + [guid]::NewGuid().Guid + [guid]::NewGuid().Guid + [guid]::NewGuid().Guid -Replace "-").SubString(1, 126) }) | set-content "$Path\$FileName"
}

$loopCount = $loopCount
1..$loopCount | ForEach-Object { New-RandomFile }