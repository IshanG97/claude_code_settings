# Claude Code Configuration Setup (PowerShell)
# Installs Claude Code CLI globally and sets up configurations
# Can optionally set up repo-specific CLAUDE.md based on language

param(
    [Parameter(Mandatory=$false)]
    [string]$ProjectDirectory,

    [Parameter(Mandatory=$false)]
    [ValidateSet('javascript', 'python', 'csharp')]
    [string]$Language
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SettingsDir = $ScriptDir

# Function to prompt for yes/no
function Prompt-YesNo {
    param([string]$PromptText)
    do {
        $response = Read-Host "$PromptText (y/n)"
        $response = $response.ToLower()
        if ($response -eq 'y' -or $response -eq 'yes') {
            return $true
        } elseif ($response -eq 'n' -or $response -eq 'no') {
            return $false
        } else {
            Write-Host "Please answer y or n." -ForegroundColor Yellow
        }
    } while ($true)
}

# Function to check if a command exists
function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

Write-Host "[*] Claude Code Configuration Setup" -ForegroundColor Cyan
Write-Host ""

# Determine setup mode
$SetupMode = "interactive"
if ($ProjectDirectory -and $Language) {
    $SetupMode = "repo"
} elseif ($ProjectDirectory -or $Language) {
    Write-Host "[X] Both ProjectDirectory and Language are required when specifying arguments" -ForegroundColor Red
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\setup-claude-code.ps1                                    # Interactive mode" -ForegroundColor White
    Write-Host "  .\setup-claude-code.ps1 C:\path\to\project python          # Repo-only setup" -ForegroundColor White
    Write-Host "  .\setup-claude-code.ps1 .\my-js-app javascript             # Repo-only setup" -ForegroundColor White
    Write-Host "  .\setup-claude-code.ps1 .\my-dotnet-api csharp             # Repo-only setup" -ForegroundColor White
    exit 1
}

# Interactive mode setup
if ($SetupMode -eq "interactive") {
    $INSTALL_CLAUDE_CLI = $false
    $INSTALL_CODEX = $false
    $SETUP_GLOBAL_CLAUDE = $false
    $SETUP_REPO_CLAUDE = $false

    # Check if Claude Code CLI is installed
    if (-not (Test-Command "claude")) {
        if (Prompt-YesNo "[CLAUDE] Install Claude Code CLI?") {
            $INSTALL_CLAUDE_CLI = $true
        }
    } else {
        try {
            $version = claude --version 2>&1
            Write-Host "[OK] Claude Code CLI already installed: $version" -ForegroundColor Green
        } catch {
            Write-Host "[OK] Claude Code CLI already installed" -ForegroundColor Green
        }
    }

    # Check if @openai/codex is installed
    if (-not (Test-Command "npm")) {
        Write-Host "[!] npm not found. Cannot install @openai/codex" -ForegroundColor Yellow
    } else {
        $codexInstalled = npm list -g @openai/codex 2>$null
        if (-not $codexInstalled -or $LASTEXITCODE -ne 0) {
            if (Prompt-YesNo "[PKG] Install @openai/codex globally?") {
                $INSTALL_CODEX = $true
            }
        } else {
            Write-Host "[OK] @openai/codex already installed" -ForegroundColor Green
        }
    }

    # Check global CLAUDE.md
    $GlobalClaudeMd = Join-Path $env:USERPROFILE ".claude\CLAUDE.md"
    if (-not (Test-Path $GlobalClaudeMd)) {
        if (Prompt-YesNo "[GLOBAL] Setup global CLAUDE.md configuration?") {
            $SETUP_GLOBAL_CLAUDE = $true
        }
    } else {
        Write-Host "[OK] Global CLAUDE.md already configured" -ForegroundColor Green
        if (Prompt-YesNo "[GLOBAL] Update global CLAUDE.md configuration?") {
            $SETUP_GLOBAL_CLAUDE = $true
        }
    }

    # Ask about repo-specific setup
    if (Prompt-YesNo "[REPO] Setup repo-specific CLAUDE.md?") {
        $SETUP_REPO_CLAUDE = $true
        $ProjectDirectory = Read-Host "[REPO] Enter project directory"

        # Validate directory
        if (-not (Test-Path $ProjectDirectory -PathType Container)) {
            Write-Host "[X] Directory does not exist: $ProjectDirectory" -ForegroundColor Red
            exit 1
        }

        $ProjectDirectory = Resolve-Path $ProjectDirectory

        Write-Host ""
        Write-Host "Select language:" -ForegroundColor Cyan
        Write-Host "  1) JavaScript/TypeScript" -ForegroundColor White
        Write-Host "  2) Python" -ForegroundColor White
        Write-Host "  3) C#" -ForegroundColor White
        $langChoice = Read-Host "Enter choice (1-3)"

        switch ($langChoice) {
            "1" { $Language = "javascript" }
            "2" { $Language = "python" }
            "3" { $Language = "csharp" }
            default {
                Write-Host "[X] Invalid choice" -ForegroundColor Red
                exit 1
            }
        }
    }
}

# Repo-only mode setup
if ($SetupMode -eq "repo") {
    # Validate language
    if ($Language -notin @('javascript', 'python', 'csharp')) {
        Write-Host "[X] Invalid language: $Language" -ForegroundColor Red
        Write-Host "Valid languages: javascript, python, csharp" -ForegroundColor Yellow
        exit 1
    }

    # Resolve absolute path
    $ProjectDirectory = Resolve-Path $ProjectDirectory -ErrorAction SilentlyContinue
    if (-not $ProjectDirectory) {
        Write-Host "[X] Directory does not exist: $ProjectDirectory" -ForegroundColor Red
        exit 1
    }

    # Validate target directory exists
    if (-not (Test-Path $ProjectDirectory -PathType Container)) {
        Write-Host "[X] Directory does not exist: $ProjectDirectory" -ForegroundColor Red
        exit 1
    }

    $SETUP_REPO_CLAUDE = $true
}

Write-Host ""
Write-Host "[*] Starting installation..." -ForegroundColor Cyan
Write-Host ""

# Install Claude Code CLI
if ($INSTALL_CLAUDE_CLI) {
    Write-Host "[CLAUDE] Installing Claude Code CLI..." -ForegroundColor Yellow

    if (-not (Test-Command "npm")) {
        Write-Host "[X] npm not found. Please install Node.js first." -ForegroundColor Red
        Write-Host "   Visit: https://nodejs.org/" -ForegroundColor White
        exit 1
    }

    npm install -g @anthropic-ai/claude-code
    Write-Host "[OK] Claude Code CLI installed" -ForegroundColor Green
}

# Install @openai/codex
if ($INSTALL_CODEX) {
    Write-Host "[PKG] Installing @openai/codex..." -ForegroundColor Yellow
    npm install -g @openai/codex
    Write-Host "[OK] @openai/codex installed" -ForegroundColor Green
}

# Setup global CLAUDE.md configuration
if ($SETUP_GLOBAL_CLAUDE) {
    Write-Host "[GLOBAL] Setting up global CLAUDE.md configuration..." -ForegroundColor Yellow

    $GlobalClaudeDir = Join-Path $env:USERPROFILE ".claude"
    $SourceFile = Join-Path $ScriptDir "claude_templates\CLAUDE.md"

    # Create global .claude directory if it doesn't exist
    if (-not (Test-Path $GlobalClaudeDir)) {
        New-Item -ItemType Directory -Path $GlobalClaudeDir -Force | Out-Null
    }

    # Backup existing CLAUDE.md if it exists
    $GlobalClaudeMd = Join-Path $GlobalClaudeDir "CLAUDE.md"
    if (Test-Path $GlobalClaudeMd) {
        $BackupName = "CLAUDE.md.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Write-Host "[!] Backing up existing global CLAUDE.md..." -ForegroundColor Yellow
        Copy-Item -Path $GlobalClaudeMd -Destination (Join-Path $GlobalClaudeDir $BackupName) -Force
    }

    # Copy global CLAUDE.md
    Copy-Item -Path $SourceFile -Destination $GlobalClaudeMd -Force

    # Copy settings.json if it doesn't exist
    $GlobalSettings = Join-Path $GlobalClaudeDir "settings.json"
    if (-not (Test-Path $GlobalSettings)) {
        $SettingsFile = Join-Path $ScriptDir "claude_templates\settings.json"
        if (Test-Path $SettingsFile) {
            Copy-Item -Path $SettingsFile -Destination $GlobalSettings -Force
        }
    }

    Write-Host "[OK] Global CLAUDE.md configuration installed" -ForegroundColor Green
    Write-Host "   Location: $GlobalClaudeMd" -ForegroundColor White
}

# Setup repo-specific configuration
if ($SETUP_REPO_CLAUDE) {
    Write-Host ""
    Write-Host "[REPO] Setting up repo-specific configuration..." -ForegroundColor Yellow
    Write-Host "   Target: $ProjectDirectory" -ForegroundColor White
    Write-Host "   Language: $Language" -ForegroundColor White

    # Create .claude directory in target repo
    $RepoClaudeDir = Join-Path $ProjectDirectory ".claude"
    if (-not (Test-Path $RepoClaudeDir)) {
        Write-Host "[REPO] Creating .claude directory..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $RepoClaudeDir -Force | Out-Null
    }

    # Backup existing repo CLAUDE.md if it exists
    $TargetClaudeMd = Join-Path $ProjectDirectory "CLAUDE.md"
    if (Test-Path $TargetClaudeMd) {
        $BackupName = "CLAUDE.md.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Write-Host "[!] Backing up existing CLAUDE.md..." -ForegroundColor Yellow
        Copy-Item -Path $TargetClaudeMd -Destination (Join-Path $ProjectDirectory $BackupName) -Force
    }

    # Copy language-specific CLAUDE.md template
    Write-Host "[REPO] Installing $Language-specific CLAUDE.md..." -ForegroundColor Cyan
    $SourceClaudeMd = Join-Path $SettingsDir "claude_templates\$Language\CLAUDE.md"
    Copy-Item -Path $SourceClaudeMd -Destination $TargetClaudeMd -Force

    # Backup existing repo settings if they exist
    $RepoSettings = Join-Path $RepoClaudeDir "settings.json"
    if (Test-Path $RepoSettings) {
        $SettingsBackupName = "settings.json.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Write-Host "[!] Backing up existing repo settings..." -ForegroundColor Yellow
        Copy-Item -Path $RepoSettings -Destination (Join-Path $RepoClaudeDir $SettingsBackupName) -Force
    }

    # Copy generic repo settings
    Write-Host "[REPO] Installing generic repo settings..." -ForegroundColor Cyan
    $GenericSettings = Join-Path $SettingsDir "claude_templates\settings.json"
    Copy-Item -Path $GenericSettings -Destination $RepoSettings -Force

    Write-Host "[OK] Repo-specific configuration installed" -ForegroundColor Green
    Write-Host "   - Language-specific CLAUDE.md: $TargetClaudeMd" -ForegroundColor White
    Write-Host "   - Local settings: $RepoSettings" -ForegroundColor White
}

Write-Host ""
Write-Host "[DONE] Setup complete!" -ForegroundColor Green
Write-Host ""
