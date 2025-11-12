# OpenAI Codex Installation Script (PowerShell)
# Installs @openai/codex npm package globally

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

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

Write-Host "[PKG] OpenAI Codex Setup" -ForegroundColor Cyan
Write-Host ""

# Check if npm is available
if (-not (Test-Command "npm")) {
    Write-Host "[X] npm not found. Please install Node.js first." -ForegroundColor Red
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Yellow
    Write-Host "  1. Run .\setup-windows.ps1 to install NVM and Node.js" -ForegroundColor White
    Write-Host "  2. Visit https://nodejs.org/ to download Node.js" -ForegroundColor White
    Write-Host "  3. Install NVM for Windows: https://github.com/coreybutler/nvm-windows" -ForegroundColor White
    exit 1
}

# Check if @openai/codex is already installed
$codexInstalled = npm list -g @openai/codex 2>$null
if ($codexInstalled -and $LASTEXITCODE -eq 0) {
    Write-Host "[OK] @openai/codex is already installed" -ForegroundColor Green

    # Show current version
    try {
        $versionInfo = npm list -g @openai/codex --depth=0 2>$null | Select-String "@openai/codex"
        if ($versionInfo) {
            Write-Host "   Current version: $versionInfo" -ForegroundColor White
        }
    } catch {}
    Write-Host ""

    $response = Read-Host "Do you want to update it? (y/n)"
    if ($response -eq 'y' -or $response -eq 'Y') {
        Write-Host "[PKG] Updating @openai/codex..." -ForegroundColor Yellow
        npm update -g @openai/codex
        Write-Host "[OK] @openai/codex updated" -ForegroundColor Green
    } else {
        Write-Host "Skipping update" -ForegroundColor White
        exit 0
    }
} else {
    Write-Host "[PKG] Installing @openai/codex..." -ForegroundColor Yellow
    npm install -g @openai/codex
    Write-Host "[OK] @openai/codex installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "[DONE] Setup complete!" -ForegroundColor Green
Write-Host ""
