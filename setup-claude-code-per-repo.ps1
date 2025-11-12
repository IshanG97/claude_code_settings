# Claude Code Per-Repo Configuration Setup (PowerShell)
# Sets up repo-specific CLAUDE.md and settings.json based on language
# Note: Run setup-windows.ps1 first to install Claude Code CLI and global config

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectDirectory,

    [Parameter(Mandatory=$true)]
    [ValidateSet('javascript', 'python', 'csharp')]
    [string]$Language
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SettingsDir = $ScriptDir

# Validate language
if ($Language -notin @('javascript', 'python', 'csharp')) {
    Write-Host "❌ Invalid language: $Language" -ForegroundColor Red
    Write-Host "Valid languages: javascript, python, csharp" -ForegroundColor Yellow
    exit 1
}

# Resolve absolute path
$TargetDir = Resolve-Path $ProjectDirectory -ErrorAction SilentlyContinue
if (-not $TargetDir) {
    $TargetDir = $ProjectDirectory
}

# Validate target directory exists
if (-not (Test-Path $TargetDir -PathType Container)) {
    Write-Host "❌ Directory does not exist: $TargetDir" -ForegroundColor Red
    exit 1
}

Write-Host "🎯 Setting up Claude Code configuration..." -ForegroundColor Cyan
Write-Host "📁 Target: $TargetDir" -ForegroundColor White
Write-Host "🔤 Language: $Language" -ForegroundColor White
Write-Host ""

# Create .claude directory in target repo
$RepoClaudeDir = Join-Path $TargetDir ".claude"
if (-not (Test-Path $RepoClaudeDir)) {
    Write-Host "📁 Creating .claude directory..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $RepoClaudeDir -Force | Out-Null
}

# Backup existing repo CLAUDE.md if it exists
$TargetClaudeMd = Join-Path $TargetDir "CLAUDE.md"
if (Test-Path $TargetClaudeMd) {
    $BackupName = "CLAUDE.md.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Write-Host "💾 Backing up existing CLAUDE.md..." -ForegroundColor Yellow
    Copy-Item -Path $TargetClaudeMd -Destination (Join-Path $TargetDir $BackupName) -Force
}

# Copy language-specific CLAUDE.md template
Write-Host "📝 Installing $Language-specific CLAUDE.md..." -ForegroundColor Cyan
$SourceClaudeMd = Join-Path $SettingsDir "claude_templates\$Language\CLAUDE.md"
Copy-Item -Path $SourceClaudeMd -Destination $TargetClaudeMd -Force

# Backup existing repo settings if they exist
$RepoSettings = Join-Path $RepoClaudeDir "settings.json"
if (Test-Path $RepoSettings) {
    $SettingsBackupName = "settings.json.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Write-Host "💾 Backing up existing repo settings..." -ForegroundColor Yellow
    Copy-Item -Path $RepoSettings -Destination (Join-Path $RepoClaudeDir $SettingsBackupName) -Force
}

# Copy generic repo settings
Write-Host "⚙️  Installing generic repo settings..." -ForegroundColor Cyan
$GenericSettings = Join-Path $SettingsDir "claude_templates\settings.json"
Copy-Item -Path $GenericSettings -Destination $RepoSettings -Force

Write-Host ""
Write-Host "🎉 Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 What was installed:" -ForegroundColor Cyan
Write-Host "  - Language-specific CLAUDE.md: $TargetClaudeMd" -ForegroundColor White
Write-Host "  - Local settings: $RepoSettings" -ForegroundColor White
Write-Host ""
