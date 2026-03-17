#Requires -Version 5.0
<#
.SYNOPSIS
    FF7 Remake Mods & Performance Configuration Installer for Windows

.DESCRIPTION
    Automates installation of FFVIIHook, Luma upscaling mod, and Engine.ini configuration
    for Final Fantasy VII Remake on Windows with Steam.

.PARAMETER GamePath
    Path to FF7 Remake installation (e.g., "C:\Program Files (x86)\Steam\steamapps\common\FINAL FANTASY VII REMAKE")
    Auto-detects if not provided.

.PARAMETER EngineLni
    Path to Engine.ini file to deploy (default: ./Engine.ini in script directory)

.PARAMETER LumaOnly
    Install only Luma mod, skip FFVIIHook and Engine.ini deployment

.PARAMETER SkipPackages
    Skip all installations (used for testing/dry-run)

.PARAMETER SkipHook
    Skip FFVIIHook (xinput1_3.dll) installation

.PARAMETER SkipLuma
    Skip Luma mod installation

.PARAMETER SkipConfig
    Skip Engine.ini deployment

.PARAMETER DryRun
    Preview what would be done without making changes

.PARAMETER Help
    Display this help information

.EXAMPLE
    .\setup-windows.ps1
    Uses auto-detected game path and ./Engine.ini

.EXAMPLE
    .\setup-windows.ps1 -GamePath "C:\Games\FF7R" -EngineLni ".\Engine-full-res.ini"
    Custom game path and ultra-graphics config

.EXAMPLE
    .\setup-windows.ps1 -DryRun
    Preview all planned installations
#>

param(
    [string]$GamePath,
    [string]$EngineLni,
    [switch]$LumaOnly,
    [switch]$SkipPackages,
    [switch]$SkipHook,
    [switch]$SkipLuma,
    [switch]$SkipConfig,
    [switch]$DryRun,
    [switch]$Help
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommandPath

# ============================================================================
# Logging Functions
# ============================================================================

function Write-Log {
    param([string]$Message, [string]$Type = "INFO")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $prefix = "[$timestamp] [$Type]"
    
    switch ($Type) {
        "INFO" { Write-Host "$prefix $Message" -ForegroundColor Cyan }
        "SUCCESS" { Write-Host "$prefix $Message" -ForegroundColor Green }
        "ERROR" { Write-Host "$prefix $Message" -ForegroundColor Red }
        "WARNING" { Write-Host "$prefix $Message" -ForegroundColor Yellow }
        "DRY-RUN" { Write-Host "$prefix $Message" -ForegroundColor Magenta }
    }
}

function Fail {
    param([string]$Message)
    Write-Log $Message "ERROR"
    exit 1
}

# ============================================================================
# Help Display
# ============================================================================

function Show-Help {
    Get-Help $PSCommandPath -Full
    exit 0
}

if ($Help) { Show-Help }

# ============================================================================
# Auto-Detection Functions
# ============================================================================

function Find-GamePath {
    Write-Log "Auto-detecting FF7 Remake installation..."
    
    # Common Steam installation paths
    $steamPaths = @(
        "C:\Program Files (x86)\Steam\steamapps\common\FINAL FANTASY VII REMAKE",
        "C:\Program Files\Steam\steamapps\common\FINAL FANTASY VII REMAKE"
    )
    
    # Check environment variable for custom Steam library
    $steamRoot = $env:STEAMROOT
    if ($steamRoot) {
        $steamPaths += "$steamRoot\steamapps\common\FINAL FANTASY VII REMAKE"
    }
    
    # Check registry for Steam installation path
    try {
        $steamKey = Get-ItemProperty "HKCU:\Software\Valve\Steam" -ErrorAction SilentlyContinue
        if ($steamKey.SteamPath) {
            $baseSteam = $steamKey.SteamPath -replace '/', '\'
            $steamPaths += "$baseSteam\steamapps\common\FINAL FANTASY VII REMAKE"
        }
    } catch {}
    
    foreach ($path in $steamPaths) {
        if (Test-Path "$path\End\Binaries\Win64") {
            Write-Log "Found game at: $path" "SUCCESS"
            return $path
        }
    }
    
    Fail "Could not auto-detect game path. Please provide --GamePath parameter."
}

# ============================================================================
# File Validation
# ============================================================================

function Validate-Files {
    Write-Log "Validating source files..."
    
    # Validate Engine.ini
    if (!(Test-Path $EngineLni)) {
        Fail "Engine.ini not found at: $EngineLni"
    }
    
    # Validate FFVIIHook DLL
    if (!(Test-Path "$ScriptDir\FFVIIHook\xinput1_3.dll") -and !$SkipHook -and !$LumaOnly) {
        Fail "FFVIIHook DLL not found at: $ScriptDir\FFVIIHook\xinput1_3.dll"
    }
    
    # Validate Luma zip
    if (!(Test-Path "$ScriptDir\Luma-Final_Fantasy_VII_Remake-1974-2-6-1770058756.zip") -and !$SkipLuma -and !$SkipPackages) {
        Fail "Luma mod zip not found at: $ScriptDir\Luma-Final_Fantasy_VII_Remake-1974-2-6-1770058756.zip"
    }
    
    Write-Log "All source files validated" "SUCCESS"
}

# ============================================================================
# Installation Functions
# ============================================================================

function Install-Hook {
    param([string]$TargetPath)
    
    if ($SkipHook -or $SkipPackages) {
        Write-Log "Skipping FFVIIHook installation" "WARNING"
        return
    }
    
    $dllSource = "$ScriptDir\FFVIIHook\xinput1_3.dll"
    $dllDest = "$TargetPath\End\Binaries\Win64\xinput1_3.dll"
    
    if ($DryRun) {
        Write-Log "Would copy DLL: $dllSource -> $dllDest" "DRY-RUN"
        return
    }
    
    Write-Log "Installing FFVIIHook (xinput1_3.dll)..."
    Copy-Item -Path $dllSource -Destination $dllDest -Force
    Write-Log "FFVIIHook installed successfully" "SUCCESS"
}

function Install-Luma {
    param([string]$TargetPath)
    
    if ($SkipLuma -or $SkipPackages) {
        Write-Log "Skipping Luma installation" "WARNING"
        return
    }
    
    $lumaZip = "$ScriptDir\Luma-Final_Fantasy_VII_Remake-1974-2-6-1770058756.zip"
    $win64Path = "$TargetPath\End\Binaries\Win64"
    $tempExtract = "$env:TEMP\Luma-Extract-$(Get-Random)"
    
    if ($DryRun) {
        Write-Log "Would extract Luma: $lumaZip -> $win64Path" "DRY-RUN"
        return
    }
    
    try {
        Write-Log "Extracting Luma mod..."
        
        # Create temp directory for extraction
        New-Item -ItemType Directory -Path $tempExtract -Force | Out-Null
        
        # Extract zip
        Expand-Archive -Path $lumaZip -DestinationPath $tempExtract -Force
        
        # Copy all files from extracted archive to Win64 folder
        $extractedFiles = Get-ChildItem -Path $tempExtract -Recurse -File
        foreach ($file in $extractedFiles) {
            $relativePath = $file.FullName.Substring($tempExtract.Length + 1)
            $destFile = Join-Path $win64Path $relativePath
            $destDir = Split-Path -Parent $destFile
            
            if (!(Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            
            Copy-Item -Path $file.FullName -Destination $destFile -Force
        }
        
        Write-Log "Luma installed successfully" "SUCCESS"
    } finally {
        if (Test-Path $tempExtract) {
            Remove-Item -Path $tempExtract -Recurse -Force
        }
    }
}

function Deploy-EngineConfig {
    param([string]$TargetPath)
    
    if ($SkipConfig -or $SkipPackages) {
        Write-Log "Skipping Engine.ini deployment" "WARNING"
        return
    }
    
    # Windows config path
    $configDir = "$env:USERPROFILE\Documents\My Games\FINAL FANTASY VII REMAKE\Saved\Config\WindowsNoEditor"
    $configDest = "$configDir\Engine.ini"
    
    if ($DryRun) {
        Write-Log "Would copy Engine.ini: $EngineLni -> $configDest" "DRY-RUN"
        return
    }
    
    Write-Log "Deploying Engine.ini configuration..."
    
    # Create config directory if it doesn't exist
    if (!(Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    
    Copy-Item -Path $EngineLni -Destination $configDest -Force
    Write-Log "Engine.ini deployed to: $configDest" "SUCCESS"
}

function Show-SteamLaunchOptions {
    Write-Log ""
    Write-Log "========================================" "INFO"
    Write-Log "IMPORTANT: Steam Launch Options" "WARNING"
    Write-Log "========================================" "INFO"
    Write-Log ""
    Write-Log "1. Open Steam and right-click FINAL FANTASY VII REMAKE"
    Write-Log "2. Click 'Properties' > 'General' > 'Launch Options'"
    Write-Log "3. Paste this option:"
    Write-Log ""
    Write-Log "   -dx11" "SUCCESS"
    Write-Log ""
    Write-Log "Note: Luma is DX11-only. Do NOT use -dx12." "WARNING"
    Write-Log ""
    Write-Log "4. Once in-game, press Home or Insert to open Luma"
    Write-Log "   overlay and select your preferred upscaler."
    Write-Log ""
}

# ============================================================================
# Main Execution
# ============================================================================

# Set defaults
if (!$EngineLni) {
    $EngineLni = "$ScriptDir\Engine.ini"
}

# Handle LumaOnly flag
if ($LumaOnly) {
    $SkipHook = $true
    $SkipConfig = $true
}

# Resolve game path
if (!$GamePath) {
    $GamePath = Find-GamePath
}

if (!(Test-Path $GamePath)) {
    Fail "Game path does not exist: $GamePath"
}

if (!(Test-Path "$GamePath\End\Binaries\Win64")) {
    Fail "Invalid game installation: Win64 directory not found at $GamePath\End\Binaries\Win64"
}

# Validate source files
Validate-Files

# Display dry-run header
if ($DryRun) {
    Write-Log ""
    Write-Log "========================================" "DRY-RUN"
    Write-Log "DRY-RUN MODE (no changes will be made)" "DRY-RUN"
    Write-Log "========================================" "DRY-RUN"
    Write-Log ""
}

# Display configuration
Write-Log ""
Write-Log "Configuration:"
Write-Log "  Game Path: $GamePath"
Write-Log "  Engine.ini: $EngineLni"
Write-Log "  Install Hook: $(if ($SkipHook) { 'No' } else { 'Yes' })"
Write-Log "  Install Luma: $(if ($SkipLuma) { 'No' } else { 'Yes' })"
Write-Log "  Deploy Config: $(if ($SkipConfig) { 'No' } else { 'Yes' })"
Write-Log ""

# Execute installations
Install-Hook $GamePath
Install-Luma $GamePath
Deploy-EngineConfig $GamePath

# Show Steam launch options instructions
if (!$DryRun) {
    Show-SteamLaunchOptions
    Write-Log "Installation complete!" "SUCCESS"
} else {
    Write-Log ""
    Write-Log "Dry-run preview complete. No changes were made." "DRY-RUN"
}
