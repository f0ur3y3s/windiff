<#

  ____       _       _              
 |  _ \ __ _| |_ ___| |__           
 | |_) / _` | __/ __| '_ \          
 |  __/ (_| | || (__| | | |         
 |_|   \__,_|\__\___|_| |_|         
  _____      _                  _   
 | ____|_  _| |_ _ __ __ _  ___| |_ 
 |  _| \ \/ / __| '__/ _` |/ __| __|
 | |___ >  <| |_| | | (_| | (__| |_ 
 |_____/_/\_\\__|_|  \__,_|\___|\__|

 ___      ___  _____      ________      
|\  \    /  /|/ __  \    |\   ____\     
\ \  \  /  / /\/_|\  \   \ \  \___|_    
 \ \  \/  / /\|/ \ \  \   \ \_____  \   
  \ \    / /      \ \  \ __\|____|\  \  
   \ \__/ /        \ \__\\__\____\_\  \ 
    \|__|/          \|__\|__|\_________\
                            \|_________|
                                        

================
PATCHEXTRACT.PS1
=================
Version 1.5 Microsoft MSU Patch Extraction and Patch Organization Utility by Greg Linares (@Laughing_Mantis) and wumb0
Modified to support latest MSU formats - April 2025

This Powershell script will extract a Microsoft MSU update file and then organize the output of extracted files and folders.

Organization of the output files is based on the patch's files and will organize them based on their archicture (x86, x64, or wow64)
as well as their content-type, ie: resource and catalog files will be moved to a JUNK subfolder and patch binaries and index files will 
goto a PATCH folder.

This script was developed in order to aid reverse engineers in quickly organizing patches so they can be binary diffed faster and easier. 
This was especially developed with the new bulk Microsoft Kernel patches in mind.

Example output folder structure ouput would be similar to this:

C:\PATCHES\MS15-XXX\PRE
    -x86
        - x86 Binary patched files
    -x64
        - x64 binary patched files
    -WOW64 
        - syswow64 binary patched files
    -JUNK
        - resource, catalog, mum, and other non-binary based patched files
    -PATCH
        - original patch, cabs and xml files from the extraction
    -MSIL 
        - MSIL .NET binary patched files
    -NOSSU
        - Exclude the SSU CAB in the extraction process
    -DIRECTCAB
        - Extract contents directly from CAB files instead of standard MSU extraction
        
    Directories will automagically be organized into filename-version to remove garbage filler folder names
        
        
=============
REQUIREMENTS
=============
'expand.exe' to be present in %WINDIR%\SYSTEM32 (it is by default) - It will execute this file @ the current users permissions
A valid Microsoft MSU patch file to extract (PATCH variable)
Directory and File write/creation permissions to the PATH folder specified
        
    
=======    
USAGE
=======

Powershell -ExecutionPolicy Bypass -File PatchExtract.ps1 -Patch C:\Patches\Windows6.1-KB3088195-x64.msu -Path C:\Patches\MS15-XXX\POST\ 


This would extract the patch file C:\Patches\Windows6.1-KB3088195-x64.msu to the folder C:\Patches\MS15-XXX\POST\.
It will then create all the sub organization folders within C:\Patches\MS15-XXX\POST\ folder.

(Note: the optional Powershell parameters '-ExecutionPolicy Bypass' is necessary in some environments to overcome Powershell execution restrictions)

==========
ARGUMENTS
==========
-PATCH <STRING:Filename> [REQUIRED] [NO DEFAULT]
    Specifies the MSU file that will be extracted to the specified PATH folder and then organized into the x86, x64, WOW, JUNK, and BIN folders specified
    Extract command will be "expand -F:* <PATCH> <PATH>"
    Non MSU files have not been tested however if the extraction does not generate a CAB file of the same name (indicator of successful extraction of MSU files)
    the script assumes extraction failed.
    
-PATH <STRING:FolderPath> [REQUIRED] [NO DEFAULT]
    Specified the folder that the PATCH file will be extracted and organized into
    If the specified folders does not exist yet, the user will be prompted if they want to create it.
    Relative paths '.\POST' can be used but it has not extensively been tested.

    The -PATH variable may be now omitted to expand to current directory
    

-x86 <STRING:Foldername> [OPTIONAL] [DEFAULT='x86']

    Specifies the folder name within $PATH to store x86 patch binaries
    example: -x86 32bit
    
    
-x64 <STRING:Foldername> [OPTIONAL] [DEFAULT='x64']

    Specifies the folder name within $PATH to store x64 patch binaries
    example: -x64 64bit
    
-WOW <STRING:Foldername> [OPTIONAL] [DEFAULT='WOW64']

    Specifies the folder name within $PATH to store wow64 type patch binaries
    example: -WOW sysWOW64

-MSIL <STRING:Foldername> [OPTIONAL] [DEFAULT='MSIL']

    Specifies the folder name within $PATH to store .NET type patch binaries
    example: -MSIL DOTNET
    
-JUNK <STRING:Foldername> [OPTIONAL] [DEFAULT='JUNK']

    Specifies the folder name within $PATH to store resource, catalog, and other generally useless for diffing patch binaries
    example: -JUNK res
    
    
-BIN <STRING:Foldername> [OPTIONAL] [DEFAULT='PATCH']

    Specifies the folder name within $PATH to store extraction xml and original patch msu and cab files
    example: -BIN bin

-NOSSU <SWITCH> [OPTIONAL] [DEFAULT=$false]
    Excludes the servicing stack CAB from extraction (if present)

-DIRECTCAB <SWITCH> [OPTIONAL] [DEFAULT=$false]
    Attempts to extract CAB files directly, without first extracting the MSU

================
VERSION HISTORY
================
I originally wrote this as an ugly batch file sometime between 2014 and 2015 as a way to organize folders but it was incomplete and buggy

Oct 15, 2015 - Initial Public Release 1.0
Oct 20, 2016 - Version 1.1 Released
                * Bug fixes handling new naming format for patch .cab files
                * Added the ability to auto-extract to the same directory as current PATCH 
                * filtered output directory name format to aid in bindiffing

Oct 20, 2016 - Version 1.2 Released
                * Bug fixes handling MSIL renaming issues and collisions in renameing patch folders

Nov 7, 2016 - Version 1.25 Released
                * Added hack to handle subsequent CAB files Microsoft Added in Windows 10 Cumulative Patches - will make a better way to handle this in 1.3 

March 15, 2017 - Version 1.3 Released
                * Color Change to sweet vaporwave retro 80s colors
                * Cleaned up some awful code that I must have been on some amazing substances when I wrote
                * Spent several hours making a rad ASCII Logo
                * Most importantly fixed the Sub-cab auto-extraction method that Microsoft introduced late 2016
August 23, 2020 - Version 1.31 - Unofficial update by wumb0
                * Fixed extracting command (Start-Process -> iex). There's a bug in powershell that breaks Start-Process with arg lists that have literal quotes
                * Supressed output of expand.exe commands to cut down on script runtimes
March 24, 2021 - Version 1.32 - Unofficial update by wumb0
                * Update script to handle this month's update to the patch packaging format
                * Simplify recursive CAB extraction into a loop
                * Add option to skip the SSU CAB
                * Silenced a lot of output
September 15, 2024 - Version 1.4 - wumb0
                * Updated to handle MSWIM and PSF cabs
                * Replaced the ASCII art ;)
                * This version should be backward compatible with most (all?) older MSU patch types. Let me know if I broke something.
April 14, 2025 - Version 1.5 - Updated to handle newer MSU formats
                * Improved handling of MSWIM format with more robust extraction methods
                * Added support for directly extracting CAB files when MSU extraction fails
                * Enhanced error handling and reporting
                * Added compatibility with the latest Windows Update package formats
                * Fixed issues with recursive CAB extraction


==========
LICENSING
==========
This script is provided free as beer. It probably has some bugs and coding issues, however if you like it or find it useful please give me a shout out on twitter @Laughing_Mantis.  
Feedback is encouraged and I will be likely releasing new scripts and tools and training in the future if it is welcome.


-GLin

#>

Param
(
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$PATCH = "",
    
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [string]$PATH = "",
    
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [string]$x86 = "x86",
    
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [string]$x64 = "x64",
    
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [string]$WOW = "WOW64",

    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [string]$MSIL = "MSIL",
    
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [string]$JUNK = "JUNK",
    
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [string]$BIN = "PATCH",

    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [switch]$NOSSU = $false,
    
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [switch]$DIRECTCAB = $false
)

Clear-Host
$ASCIIART = @"
  ____       _       _              
 |  _ \ __ _| |_ ___| |__           
 | |_) / _` | __/ __| '_ \          
 |  __/ (_| | || (__| | | |         
 |_|   \__,_|\__\___|_| |_|         
  _____      _                  _   
 | ____|_  _| |_ _ __ __ _  ___| |_ 
 |  _| \ \/ / __| '__/ _` |/ __| __|
 | |___ >  <| |_| | | (_| | (__| |_ 
 |_____/_/\_\\__|_|  \__,_|\___|\__|

 ___      ___  _____      ________      
|\  \    /  /|/ __  \    |\   ____\     
\ \  \  /  / /\/_|\  \   \ \  \___|_    
 \ \  \/  / /\|/ \ \  \   \ \_____  \   
  \ \    / /      \ \  \ __\|____|\  \  
   \ \__/ /        \ \__\\__\____\_\  \ 
    \|__|/          \|__\|__|\_________\
"@

function Expand-Psf {
    param (
        [string]$DesktopDeploymentCab,
        [string]$PsfFile,
        [string]$OutPath,
        [switch]$Verbose = $false
    )

    mkdir -Force $OutPath | Out-Null
    $OutPath = Resolve-Path $OutPath
    $oldpath = $env:PATH
    $env:PATH = $env:PATH + ";$OutPath"
    $deltadll = "UpdateCompression.dll"
    $ucpath = (Join-Path $OutPath $deltadll)
    if (-not (Test-Path $ucpath)) {
        # we need to get and import UpdateCompression
        if ($null -ne $DesktopDeploymentCab) {
            expand -F:UpdateCompression.dll $ddcab $OutPath | Out-Null
        }
        if (-not (Test-Path $ucpath)) {
            $uri = "https://msdl.microsoft.com/download/symbols/updatecompression.dll/2F47410A82000/updatecompression.dll"
            Write-Warning "UpdateCompression.dll was not present in $DesktopDeploymentCab"
            Write-Host "Downloading a copy from $uri"
            Invoke-WebRequest -UseBasicParsing -Uri $uri -OutFile $ucpath
        }
    }
    try { [FFI.UpdateCompression] | Out-Null } catch {
        Add-Type -Name UpdateCompression -Namespace FFI -MemberDefinition @"
        [StructLayout(LayoutKind.Sequential)]
        public struct DELTA_INPUT {
            public IntPtr lpcStart;
            public IntPtr uSize;
            public int Editable;
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct DELTA_OUTPUT {
            public IntPtr lpStart;
            public IntPtr uSize;
        }

        [DllImport("$deltadll", SetLastError=true)]
        public static extern bool ApplyDeltaB(
            int ApplyFlags,
            ref DELTA_INPUT Source,
            ref DELTA_INPUT Delta,
            ref DELTA_OUTPUT lpTarget
        );
        
        [DllImport("$deltadll")]
        public static extern bool DeltaFree(IntPtr Buffer);
"@
    }

    # get the manifest delta from the PSF file
    $psf = [IO.File]::OpenRead((Resolve-Path $psffile))
    $psf.Seek(4, [IO.SeekOrigin]::Begin) | Out-Null
    $psfreader = [IO.BinaryReader]$psf
    $manifest_len = [bitconverter]::ToUInt32($psfreader.ReadBytes(4), 0)

    # skip PSTREAM header, read the PA30 delta
    $psf.Seek(0x80, [IO.SeekOrigin]::Begin) | Out-Null
    $manifest_delta = $psfreader.ReadBytes($manifest_len)
    $md_buffer = [Runtime.InteropServices.Marshal]::AllocHGlobal($manifest_len)
    [Runtime.InteropServices.Marshal]::Copy($manifest_delta, 0, $md_buffer, $manifest_len) | Out-Null

    # expand the manifest
    $Source = New-Object FFI.UpdateCompression+DELTA_INPUT
    $Delta = New-Object FFI.UpdateCompression+DELTA_INPUT
    $Target = New-Object FFI.UpdateCompression+DELTA_OUTPUT
    $Source.lpcStart = [IntPtr]::Zero
    $Source.uSize = [IntPtr]::Zero
    $Delta.lpcStart = $md_buffer
    $Delta.uSize = [IntPtr]$manifest_len

    $res = [FFI.UpdateCompression]::ApplyDeltaB(
        0,
        [ref]$Source,
        [ref]$Delta,
        [ref]$Target
    )
    # dll was loaded, can restore path
    $env:PATH = $oldpath
    [Runtime.InteropServices.Marshal]::FreeHGlobal($md_buffer) | Out-Null
    if ($res -eq 0) {
        Write-Error "ApplyDeltaB failed to expand the PSF metadata"
        return
    }

    # create the manifest from the output bytes
    $buf = [byte[]]::new($Target.uSize)
    [Runtime.InteropServices.Marshal]::Copy($Target.lpStart, $buf, 0, $Target.uSize) | Out-Null
    [FFI.UpdateCompression]::DeltaFree($Target.lpStart) | Out-Null
    $xml = [xml]([Text.Encoding]::UTF8.GetString($buf))
    if ($xml.Container.type -ne "PSF") {
        Write-Error "Invalid PSF manifest XML"
        return
    }

    # unpack the patch!
    Write-Host "Manifest expanded. Unpacking patch"
    $hasher = [Security.Cryptography.HashAlgorithm]::Create("sha256")
    $tot = $xml.Container.Files.ChildNodes.Count
    $n = 0
    $xml.Container.Files.ChildNodes | ForEach-Object {
        $offset = [int]$_.Delta.Source.offset
        $length = [int]$_.Delta.Source.length
        $expectedhash = $_.Delta.Source.Hash.value.ToUpper()
        $fn = $_.name
        Write-Progress -PercentComplete ($n/$tot*100) -Status "Unpacking patch $PsfFile" -Activity "$fn"
        $psf.Seek($offset, [IO.SeekOrigin]::Begin) | Out-Null
        $patch = $psfreader.ReadBytes($length)
        $path = Join-Path $OutPath $fn
        if ($Verbose) {
            Write-Host "Unpacking $fn from offset $offset with length $length to $path"
        }
        mkdir -Force (Split-Path -Parent -Path $path) | Out-Null
        # check the hash
        $shasum = [BitConverter]::ToString($hasher.ComputeHash($patch)).Replace("-", "").ToUpper()
        if ($shasum -ne $expectedhash) {
            Write-Error Unexpected hash
        }
        Set-Content -Encoding Byte -Path $path $patch
        $n += 1
    }
    $psf.Close()
}

function Test-IsWimFile {
    param (
        [string]$FilePath
    )
    
    try {
        $stream = [System.IO.File]::OpenRead($FilePath)
        $reader = New-Object System.IO.BinaryReader($stream)
        $signature = New-Object byte[] 5
        $bytesRead = $reader.Read($signature, 0, 5)
        
        $isWim = ($bytesRead -eq 5) -and 
                ($signature[0] -eq [byte][char]'M') -and 
                ($signature[1] -eq [byte][char]'S') -and 
                ($signature[2] -eq [byte][char]'W') -and 
                ($signature[3] -eq [byte][char]'I') -and 
                ($signature[4] -eq [byte][char]'M')
                
        return $isWim
    }
    catch {
        Write-Warning "Error checking if file is a WIM: $_"
        return $false
    }
    finally {
        if ($reader) { $reader.Close() }
        if ($stream) { $stream.Close() }
    }
}

function Extract-WimFile {
    param (
        [string]$WimFile,
        [string]$DestinationPath
    )
    
    Write-Host "Extracting WIM file: $WimFile to $DestinationPath" -ForegroundColor Cyan
    
    # Create a temp directory for mounting
    $tempDir = Join-Path $env:TEMP ([System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    
    try {
        Write-Host "Mounting WIM image (this requires administrator privileges)..." -ForegroundColor Yellow
        
        # Try DISM method first (requires admin)
        try {
            $dismCommand = "DISM /Mount-Wim /WimFile:`"$WimFile`" /index:1 /MountDir:`"$tempDir`""
            Write-Host "Executing: $dismCommand" -ForegroundColor Cyan
            
            $dismProcess = Start-Process -FilePath "DISM.exe" -ArgumentList "/Mount-Wim", "/WimFile:$WimFile", "/index:1", "/MountDir:$tempDir" -Wait -NoNewWindow -PassThru
            
            if ($dismProcess.ExitCode -ne 0) {
                throw "DISM mount failed with exit code: $($dismProcess.ExitCode)"
            }
            
            # Copy files from mounted WIM to destination
            Copy-Item -Path "$tempDir\*" -Destination $DestinationPath -Recurse -Force
            
            # Unmount WIM
            $dismUnmountProcess = Start-Process -FilePath "DISM.exe" -ArgumentList "/Unmount-Wim", "/MountDir:$tempDir", "/Discard" -Wait -NoNewWindow -PassThru
            
            if ($dismUnmountProcess.ExitCode -ne 0) {
                Write-Warning "DISM unmount failed with exit code: $($dismUnmountProcess.ExitCode)"
            }
            
            return $true
        }
        catch {
            Write-Warning "DISM extraction failed. Trying PowerShell method: $_"
            
            # Try PowerShell Mount-WindowsImage if available
            try {
                # Check if the command is available
                if (Get-Command Mount-WindowsImage -ErrorAction SilentlyContinue) {
                    Mount-WindowsImage -Path $tempDir -ImagePath $WimFile -Index 1 -ReadOnly
                    
                    # Copy files from mounted WIM to destination
                    Copy-Item -Path "$tempDir\*" -Destination $DestinationPath -Recurse -Force
                    
                    # Unmount WIM
                    Dismount-WindowsImage -Path $tempDir -Discard
                    
                    return $true
                }
                else {
                    throw "Mount-WindowsImage command not available"
                }
            }
            catch {
                Write-Warning "PowerShell WIM extraction failed: $_"
                return $false
            }
        }
    }
    finally {
        # Clean up temp directory
        if (Test-Path $tempDir) {
            Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
        }
    }
}

function Extract-DirectCabs {
    param (
        [string]$PatchFile,
        [string]$DestinationPath
    )
    
    Write-Host "Attempting to extract CAB files directly from: $PatchFile" -ForegroundColor Cyan
    
    # Create a temporary directory for extraction
    $tempDir = Join-Path $env:TEMP ([System.IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    
    try {
        # Try to extract the CAB files directly using expand
        $expandCommand = "$EXPAND -F:*.cab `"$PatchFile`" `"$tempDir`""
        Write-Host "Executing: $expandCommand" -ForegroundColor Cyan
        
        Invoke-Expression "$EXPAND -F:*.cab `"$PatchFile`" `"$tempDir`""
        
        # Check if any CAB files were extracted
        $extractedCabs = Get-ChildItem -Path $tempDir -Filter *.cab
        
        if ($extractedCabs.Count -gt 0) {
            Write-Host "Found $($extractedCabs.Count) CAB files in the patch" -ForegroundColor Green
            
            # Extract each CAB to the destination
            foreach ($cab in $extractedCabs) {
                Write-Host "Extracting CAB: $($cab.FullName)" -ForegroundColor Cyan
                Invoke-Expression "$EXPAND -F:* `"$($cab.FullName)`" `"$DestinationPath`""
                
                # Move the CAB to the patch directory
                $patchDir = Join-Path $DestinationPath $BIN
                if (!(Test-Path $patchDir)) {
                    New-Item -ItemType Directory -Path $patchDir -Force | Out-Null
                }
                
                Move-Item -Path $cab.FullName -Destination $patchDir -Force
            }
            
            return $true
        }
        else {
            Write-Warning "No CAB files found in the patch"
            return $false
        }
    }
    catch {
        Write-Warning "Direct CAB extraction failed: $_"
        return $false
    }
    finally {
        # Clean up temporary directory
        if (Test-Path $tempDir) {
            Remove-Item -Path $tempDir -Force -Recurse -ErrorAction SilentlyContinue
        }
    }
}

Write-Host $ASCIIART -ForegroundColor Magenta
Start-Sleep -s 1

if ($PATCH -eq "") {
    Throw ("Error: No PATCH file specified. Specify a valid Microsoft MSU Patch with the -PATCH argument")
}

if ((Split-Path $PATCH -Parent) -eq "") {
    # First look in current working directory for the relative filename
    $CurrentDir = $(get-location).Path;
    $PATCH = $CurrentDir + "\" + $PATCH

    # if that doesnt work we look in the current script directory (less likely)
    # but hey we tried
    if (!(Test-Path $PATCH)) {
        $scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
        $PATCH = $scriptDir + "\" + $PATCH
    }
}

if (!(Test-Path $PATCH)) {
    Throw ("Error: Specified PATCH file ($PATCH) does not exist. Specify a valid Microsoft MSU Patch file with the -PATCH argument.")
}

if ($PATH -eq "") {
    $PATH = Split-Path $PATCH -Parent
    Write-Host ("PATH = $PATH") -ForegroundColor White
    Write-Host ("No PATH folder specified. Will extract to $PATH folder.") -ForegroundColor White
}

# Check if path exists, create if needed
if (!(Test-Path $PATH)) {
    Do {
        $Attempt = Read-Host ("Warning: Specified PATH folder ($PATH) does not exist. Do you want to create it? [Y] or [N]")
    } Until ('Y', 'y', 'n', 'N' -ccontains $Attempt)
    
    if ($Attempt.ToUpper() -eq 'N') {
        Write-Host ("Exiting...") -ForegroundColor DarkMagenta
        Exit
    }
    else {
        New-Item $PATH -Force -ItemType Directory
        Write-Host "Created $PATH Folder" -ForegroundColor Cyan
    }
}

$PATCH = Resolve-Path $PATCH
$PATH = Resolve-Path $PATH

Write-Host "Patch to Extract: $PATCH" -ForegroundColor Magenta
Write-Host "Extraction Path: $PATH" -ForegroundColor Magenta
Write-Host "x86 File Storage Folder Name: $x86" -ForegroundColor Magenta
Write-Host "x64 File Storage Folder Name: $x64" -ForegroundColor Magenta
Write-Host "WOW64 File Storage Folder Name: $WOW" -ForegroundColor Magenta
Write-Host "MSIL File Storage Folder Name: $MSIL" -ForegroundColor Magenta
Write-Host "Junk File Storage Folder Name: $JUNK" -ForegroundColor Magenta
Write-Host "Original Patch File Storage Folder Name: $BIN" -ForegroundColor Magenta

# Create all the necessary folders
$PATCHx86 = Join-Path -path $PATH -ChildPath $x86
$PATCHx64 = Join-Path -path $PATH -ChildPath $x64
$PATCHWOW = Join-Path -path $PATH -ChildPath $WOW
$PATCHMSIL = Join-Path -path $PATH -ChildPath $MSIL
$PATCHJUNK = Join-Path -path $PATH -ChildPath $JUNK
$PATCHCAB = Join-Path -path $PATH -ChildPath $BIN

# Create directories if they don't exist
$directories = @($PATCHx86, $PATCHx64, $PATCHWOW, $PATCHMSIL, $PATCHJUNK, $PATCHCAB)
foreach ($dir in $directories) {
    if (!(Test-Path $dir -pathType Container)) {
        New-Item $dir -Force -ItemType Directory
        Write-Host "Making $dir Folder" -ForegroundColor Cyan
    }
}

# Locate expand.exe
$SYSPATH = Join-Path -path (get-item env:\windir).Value -ChildPath "system32"
$EXPAND = Join-Path -path $SYSPATH -ChildPath "expand.exe"

if (!(Test-Path $EXPAND)) {
    Throw ("Error: Cannot find 'Expand.exe' in the $SYSPATH folder.")
}

# Determine file type and extract accordingly
$extractionSuccessful = $false

# If direct CAB extraction is requested
if ($DIRECTCAB) {
    $extractionSuccessful = Extract-DirectCabs -PatchFile $PATCH -DestinationPath $PATH
    
    if (!$extractionSuccessful) {
        Write-Warning "Direct CAB extraction failed, falling back to standard MSU extraction methods"
    }
}

# If not directly extracting CABs or if direct extraction failed
if (!$DIRECTCAB -or !$extractionSuccessful) {
    # Check if it's a WIM file
    $isWimFile = Test-IsWimFile -FilePath $PATCH
    
    if ($isWimFile) {
        Write-Host "Detected MSWIM format MSU" -ForegroundColor Green
        $extractionSuccessful = Extract-WimFile -WimFile $PATCH -DestinationPath $PATH
    }
    else {
        # Standard MSU extraction
        Write-Host "Attempting standard MSU extraction" -ForegroundColor Cyan
        $CMD = $EXPAND
        $ARG = '-F:* ' + '"' + $PATCH + '" ' + '"' + $PATH + '"'
        Write-Host "Executing the following command: $EXPAND $ARG" -ForegroundColor Cyan
        
        try {
            Invoke-Expression "$EXPAND $ARG" | Out-Null
            $extractionSuccessful = $true
        }
        catch {
            Write-Warning "Standard MSU extraction failed: $_"
            $extractionSuccessful = $false
        }
    }
}

# If all extraction methods have failed, try direct CAB extraction as a last resort
if (!$extractionSuccessful -and !$DIRECTCAB) {
    Write-Host "All standard extraction methods failed, attempting direct CAB extraction as fallback" -ForegroundColor Yellow
    $extractionSuccessful = Extract-DirectCabs -PatchFile $PATCH -DestinationPath $PATH
}

# If all extraction methods have failed, exit
if (!$extractionSuccessful) {
    Throw "Failed to extract patch file using any available method. The file format may not be supported."
}

# Check for PSF files and process them
$PSF = Get-ChildItem -Path $PATH -Filter *.psf

if ($PSF) {
    Write-Host "Detected PSF patch format, processing..." -ForegroundColor Green
    $ddcab = Get-ChildItem -Path $PATH -Filter DesktopDeployment.cab | Select-Object -First 1
    
    if (-not $ddcab) {
        Write-Warning "Detected a PSF patch, but could not find DesktopDeployment.cab"
    } else {
        $psffile = $PSF | Select-Object -First 1
        try {
            Expand-Psf -DesktopDeploymentCab $ddcab.FullName -PsfFile $psffile.FullName -OutPath $PATH
        } catch {
            Write-Warning "Failed to expand PSF, proceeding with CAB expansion: $($PSItem.ToString())"
        }
    }
}

# Process CAB files
$CABS = Get-Childitem -Path $PATH -Filter *.cab

# Extract cab files recursively
while ($null -ne $CABS -and $CABS.Count -gt 0) {
    foreach ($CAB in $CABS) {
        Write-Host "Processing CAB File: $($CAB.Name)" -ForegroundColor White
        
        # Skip certain CAB files if specified
        if (!($CAB.Name -eq "WSUSSCAN.cab" -or 
              ($NOSSU -and ($CAB.Name -like "SSU-*" -or $CAB.Name -like "DesktopDeployment*")))) {
            
            $cabPath = $CAB.FullName
            Write-Host "Extracting: $cabPath" -ForegroundColor Magenta
            
            if (Test-Path $cabPath) {
                # Add unique characters to the filename to prevent name collisions
                $hash = Get-FileHash -Algorithm MD5 $cabPath
                $newcabPath = $cabPath.SubString(0, $cabPath.LastIndexOf(".")) + "-" + $HASH.Hash.SubString(0, 5) + ".cab"
                Move-Item $cabPath $newcabPath -Force -ErrorAction SilentlyContinue
                
                # Extract the CAB file
                $ARG = '-F:* ' + '"' + $newcabPath + '" ' + '"' + $PATH + '"'
                Write-Host "Executing: $EXPAND $ARG" -ForegroundColor Cyan
                
                try {
                    Invoke-Expression "$EXPAND $ARG | Out-Null" | Out-Null
                    
                    # Check if the extraction might have failed due to a multi-file CAB
                    if ($LASTEXITCODE -ne 0) {
                        Write-Warning "Standard CAB extraction failed. Attempting multi-file CAB extraction..."
                        
                        # Create a subdirectory for the CAB
                        $cabDir = Join-Path -Path $PATH -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($newcabPath))
                        New-Item -ItemType Directory -Path $cabDir -Force | Out-Null
                        
                        # Try extracting as a multi-file CAB
                        $multiCabArg = '-F:* ' + '"' + $newcabPath + '" /D:"' + $cabDir + '"'
                        Invoke-Expression "$EXPAND $multiCabArg | Out-Null" | Out-Null
                        
                        # If successful, copy contents back to main directory
                        if (Test-Path $cabDir) {
                            Copy-Item -Path "$cabDir\*" -Destination $PATH -Recurse -Force
                        }
                    }
                }
                catch {
                    Write-Warning "Error extracting CAB file $($CAB.Name): $_"
                }
                
                # Move the processed CAB to the patch directory
                Write-Host "Moving $newcabPath to $PATCHCAB" -ForegroundColor Magenta
                Move-Item $newcabPath $PATCHCAB -Force -ErrorAction SilentlyContinue
            }
            else {
                Write-Warning "Patch .CAB File [$cabPath] could not be located."
            }
        }
        else {
            Write-Host "Moving $($CAB.FullName) to $PATCHCAB (skipping extraction)" -ForegroundColor Magenta
            Move-Item $CAB.FullName $PATCHCAB -Force -ErrorAction SilentlyContinue
        }
    }
    
    # Check for new CAB files after extraction
    $CABS = Get-Childitem -Path $PATH -Filter *.cab
}

# Organize patch folders
Write-Host "Sorting patch files into the correct folders" -ForegroundColor Green
$PATCHFolders = Get-ChildItem -Path $PATH -Force -ErrorAction SilentlyContinue | Where-Object {$_.Attributes -eq 'Directory'}

foreach ($folder in $PATCHFolders) {
    if ($folder.Name -eq $x86 -or $folder.Name -eq $x64 -or 
        $folder.Name -eq $WOW -or $folder.Name -eq $MSIL -or 
        $folder.Name -eq $JUNK -or $folder.Name -eq $BIN) {
        # Skip our own organizational folders
        Continue
    }
    
    if ($folder.Name.Contains(".resources_")) {
        Move-Item $folder.FullName $PATCHJUNK -Force -ErrorAction SilentlyContinue
        Continue
    }
    elseif ($folder.Name.StartsWith("x86_")) {
        Move-Item $folder.FullName $PATCHx86 -Force -ErrorAction SilentlyContinue
        Continue
    }
    elseif ($folder.Name.StartsWith("amd64_")) {
        Move-Item $folder.FullName $PATCHx64 -Force -ErrorAction SilentlyContinue
        Continue
    }
    elseif ($folder.Name.StartsWith("wow64_")) {
        Move-Item $folder.FullName $PATCHWOW -Force -ErrorAction SilentlyContinue
        Continue
    }
    elseif ($folder.Name.StartsWith("msil_")) {
        Move-Item $folder.FullName $PATCHMSIL -Force -ErrorAction SilentlyContinue
        Continue
    }
}

# Reorganize folder names to make them more user-friendly
Write-Host "Cleaning up folder names for easier diffing" -ForegroundColor Green

# Function to rename architecture-specific folders
function Rename-ArchFolders {
    param (
        [string]$Path,
        [string]$Prefix
    )
    
    $folders = Get-ChildItem -Path $Path -Force -ErrorAction SilentlyContinue | Where-Object {$_.Attributes -eq 'Directory'}
    
    foreach ($folder in $folders) {
        $pattern = $Prefix + "_microsoft-windows-"
        $msPattern = $Prefix + "_"
        
        if ($folder.Name -like "$pattern*") {
            $newfolder = $folder.Name.Replace($pattern, "")
            $parts = $newfolder.Split("_")
            
            # Get the component name and version
            if ($parts.Length -ge 3) {
                $newname = $parts[0] + "_" + $parts[2]
                Rename-Item -path $folder.FullName -newName ($newname) -ErrorAction SilentlyContinue
            }
        }
        elseif ($folder.Name -like "$msPattern*") {
            $newfolder = $folder.Name.Replace($msPattern, "")
            $parts = $newfolder.Split("_")
            
            # Get the component name and version
            if ($parts.Length -ge 3) {
                $newname = $parts[0] + "_" + $parts[2]
                Rename-Item -path $folder.FullName -newName ($newname) -ErrorAction SilentlyContinue
            }
        }
    }
}

# Rename folders in each architecture directory
Rename-ArchFolders -Path $PATCHx86 -Prefix "x86"
Rename-ArchFolders -Path $PATCHx64 -Prefix "amd64"
Rename-ArchFolders -Path $PATCHWOW -Prefix "wow64"
Rename-ArchFolders -Path $PATCHMSIL -Prefix "msil"

# Move remaining files to appropriate folders
$Junkfiles = Get-ChildItem -Path $PATH -Force -ErrorAction SilentlyContinue -File

foreach ($JunkFile in $Junkfiles) {
    try {
        if ($JunkFile.Extension -in (".manifest", ".cat", ".mum", ".wim")) {
            Move-Item $JunkFile.FullName $PATCHJUNK -Force -ErrorAction SilentlyContinue
            Continue
        }
        
        if ($JunkFile.Extension -in (".cab", ".xml", ".msu", ".pkgProperties.txt", ".ini", ".psf")) {
            Move-Item $JunkFile.FullName $PATCHCAB -Force -ErrorAction SilentlyContinue
            Continue
        }
        
        if ($JunkFile.Name -eq "patch") {
            Move-Item $JunkFile.FullName $PATCHCAB -Force -ErrorAction SilentlyContinue
            Continue
        }
    }
    catch {
        Write-Warning "Error Processing ($($JunkFile.FullName)): $_"
    }
}

Write-Host "`nPatch extraction and organization complete!" -ForegroundColor Green
Write-Host "Files are organized in the following structure:" -ForegroundColor Cyan
Write-Host "  $PATCHx86 - x86 binaries" -ForegroundColor White
Write-Host "  $PATCHx64 - x64 binaries" -ForegroundColor White
Write-Host "  $PATCHWOW - WOW64 binaries" -ForegroundColor White
Write-Host "  $PATCHMSIL - MSIL/.NET binaries" -ForegroundColor White
Write-Host "  $PATCHJUNK - Resource and catalog files" -ForegroundColor White
Write-Host "  $PATCHCAB - Original patch files and CABs" -ForegroundColor White
