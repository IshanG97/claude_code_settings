#!/usr/bin/env pwsh
# Complete Remote Access Setup Script for Windows
# Configures SSH Server, VSCode Remote SSH, RDP, and Network Discovery
# This script sets up everything needed for remote development and access

Write-Host "Configuring Complete Remote Access for Windows..." -ForegroundColor Cyan
Write-Host "  - SSH Server" -ForegroundColor White
Write-Host "  - VSCode Remote SSH" -ForegroundColor White
Write-Host "  - Remote Desktop (RDP)" -ForegroundColor White
Write-Host "  - Network Discovery" -ForegroundColor White
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Error: This script must be run as Administrator" -ForegroundColor Red
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Function to enable a service
function Enable-ServiceIfExists {
    param($ServiceName, $DisplayName)

    $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if ($service) {
        Write-Host "Configuring $DisplayName..." -ForegroundColor Yellow
        Set-Service -Name $ServiceName -StartupType Automatic -ErrorAction Stop
        Start-Service -Name $ServiceName -ErrorAction SilentlyContinue
        Write-Host "[OK] $DisplayName enabled and started" -ForegroundColor Green
        return $true
    }
    return $false
}

# 1. Install and Configure OpenSSH Server
Write-Host "[1/6] Setting up OpenSSH Server..." -ForegroundColor Cyan
$sshInstalled = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'

if ($sshInstalled.State -ne "Installed") {
    Write-Host "Installing OpenSSH Server..." -ForegroundColor Yellow
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -ErrorAction Stop
    Write-Host "[OK] OpenSSH Server installed" -ForegroundColor Green
} else {
    Write-Host "[OK] OpenSSH Server already installed" -ForegroundColor Green
}

Enable-ServiceIfExists "sshd" "SSH Server"

# Configure SSH firewall rule
Write-Host "Configuring SSH firewall rule..." -ForegroundColor Yellow
$sshFirewallRule = Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue
if (-not $sshFirewallRule) {
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 -Profile Any -ErrorAction Stop
    Write-Host "[OK] SSH firewall rule created (all network profiles)" -ForegroundColor Green
} else {
    Set-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -Enabled True -Profile Any -ErrorAction Stop
    Write-Host "[OK] SSH firewall rule enabled (all network profiles)" -ForegroundColor Green
}

Write-Host ""

# 2. Configure PowerShell as default SSH shell (for VSCode Remote)
Write-Host "[2/6] Configuring VSCode Remote SSH..." -ForegroundColor Cyan
$powershellPath = (Get-Command powershell.exe).Source
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value $powershellPath -PropertyType String -Force -ErrorAction Stop | Out-Null
Write-Host "[OK] PowerShell set as default SSH shell" -ForegroundColor Green

Write-Host ""

# 3. Enable Remote Desktop
Write-Host "[3/6] Setting up Remote Desktop (RDP)..." -ForegroundColor Cyan
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0 -ErrorAction Stop
Write-Host "[OK] RDP enabled" -ForegroundColor Green

# Enable RDP firewall rules
Write-Host "Configuring RDP firewall rules..." -ForegroundColor Yellow
Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction Stop
Write-Host "[OK] RDP firewall rules enabled" -ForegroundColor Green

Write-Host ""

# 4. Enable Network Discovery
Write-Host "[4/6] Enabling Network Discovery..." -ForegroundColor Cyan
Get-NetFirewallRule -DisplayGroup "Network Discovery" | Set-NetFirewallRule -Enabled True -ErrorAction Stop
Write-Host "[OK] Network Discovery enabled" -ForegroundColor Green

Write-Host ""

# 5. Configure Network Level Authentication (optional but recommended)
Write-Host "[5/6] Configuring RDP Security..." -ForegroundColor Cyan
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name "UserAuthentication" -Value 1 -ErrorAction Stop
Write-Host "[OK] Network Level Authentication enabled" -ForegroundColor Green

Write-Host ""

# 6. Restart SSH service
Write-Host "[6/6] Restarting SSH service..." -ForegroundColor Cyan
Restart-Service sshd -ErrorAction Stop
Write-Host "[OK] SSH service restarted" -ForegroundColor Green

Write-Host ""

# 7. Verify SSH/VSCode configuration
Write-Host "[7/7] Verifying SSH configuration..." -ForegroundColor Cyan
$defaultShell = Get-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -ErrorAction SilentlyContinue
$sshService = Get-Service -Name sshd
$rdpEnabled = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections").fDenyTSConnections -eq 0

Write-Host "  SSH Default Shell: $($defaultShell.DefaultShell)" -ForegroundColor White
Write-Host "  SSH Service Status: $($sshService.Status)" -ForegroundColor White
Write-Host "  RDP Enabled: $rdpEnabled" -ForegroundColor White

Write-Host ""

# 8. Display connection information
Write-Host "Configuration Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Connection Information:" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan

$hostname = hostname
$ipAddresses = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" } | Select-Object -ExpandProperty IPAddress

Write-Host ""
Write-Host "Hostname: " -NoNewline -ForegroundColor Yellow
Write-Host "$hostname" -ForegroundColor White

Write-Host "IP Address(es):" -ForegroundColor Yellow
foreach ($ip in $ipAddresses) {
    Write-Host "  - $ip" -ForegroundColor White
}

Write-Host ""
Write-Host "Usage Examples:" -ForegroundColor Cyan
Write-Host "===============" -ForegroundColor Cyan
Write-Host ""

Write-Host "SSH Access:" -ForegroundColor Yellow
Write-Host "  ssh ishan@$hostname" -ForegroundColor White
foreach ($ip in $ipAddresses) {
    Write-Host "  ssh ishan@$ip" -ForegroundColor White
}

Write-Host ""
Write-Host "RDP Access:" -ForegroundColor Yellow
Write-Host "  mstsc /v:$hostname" -ForegroundColor White
foreach ($ip in $ipAddresses) {
    Write-Host "  mstsc /v:$ip" -ForegroundColor White
}

Write-Host ""
Write-Host "VSCode Remote SSH:" -ForegroundColor Yellow
Write-Host "  1. Install 'Remote - SSH' extension in VSCode" -ForegroundColor White
Write-Host "  2. Press F1 and select 'Remote-SSH: Connect to Host...'" -ForegroundColor White
Write-Host "  3. Enter: ishan@$hostname or ishan@$($ipAddresses[0])" -ForegroundColor White

Write-Host ""
Write-Host "Note: Make sure you have:" -ForegroundColor Yellow
Write-Host "  - Password or SSH key authentication configured" -ForegroundColor White
Write-Host "  - User account has remote access permissions" -ForegroundColor White
Write-Host "  - Network firewall allows these connections" -ForegroundColor White

Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
