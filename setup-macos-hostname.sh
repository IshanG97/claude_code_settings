#!/bin/bash
# Hostname Setup Script
# Sets hostname to ishan-mbp-16 for network access

echo "Setting hostname to ishan-mbp-16..."

# Set network hostname
sudo scutil --set HostName ishan-mbp-16

# Set computer name (shown in System Preferences)
sudo scutil --set ComputerName "ishan-mbp-16"

# Set local hostname for Bonjour/mDNS (.local domain)
sudo scutil --set LocalHostName ishan-mbp-16

echo "Hostname configuration complete!"
echo "You may need to restart network services or reboot for full effect."
echo ""
echo "To test:"
echo "hostname"
echo "ping ishan-mbp-16.local"
echo ""
echo "For MySQL access, other devices can now use:"
echo "mysql -h ishan-mbp-16.local -u root -p"