#!/usr/bin/env pwsh
# Hostname Setup Script for Windows
# Sets hostname for network access

Param(
    [Parameter(Mandatory=$true, Position=0, HelpMessage="The new hostname for this computer")]
    [ValidatePattern('^[a-zA-Z0-9][a-zA-Z0-9\-]{0,14}$')]
    [string]$Hostname
)

Write-Host "Setting hostname to $Hostname..." -ForegroundColor Cyan

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Error: This script must be run as Administrator" -ForegroundColor Red
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Set the computer name
try {
    Rename-Computer -NewName $Hostname -Force -ErrorAction Stop
    Write-Host "Hostname successfully set to $Hostname" -ForegroundColor Green
    Write-Host ""
    Write-Host "Configuration complete!" -ForegroundColor Green
    Write-Host "You must restart your computer for the changes to take effect." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "After restart, you can test:" -ForegroundColor Cyan
    Write-Host "  hostname" -ForegroundColor White
    Write-Host "  ping $Hostname" -ForegroundColor White
    Write-Host ""
    Write-Host "For network access from other devices:" -ForegroundColor Cyan
    Write-Host "  ssh ishan@$Hostname" -ForegroundColor White
    Write-Host "  mysql -h $Hostname -u root -p" -ForegroundColor White
    Write-Host ""

    $restart = Read-Host "Would you like to restart now? (y/N)"
    if ($restart -eq 'y' -or $restart -eq 'Y') {
        Write-Host "Restarting in 10 seconds... Press Ctrl+C to cancel" -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        Restart-Computer -Force
    }
} catch {
    Write-Host "Error setting hostname: $_" -ForegroundColor Red
    exit 1
}
