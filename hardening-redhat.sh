#!/bin/bash

check_command() {
  if [ $? -eq 0 ]; then
    echo "[SUCCESS] $1"
  else
    echo "[ERROR] $1"
    exit 1
  fi
}

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Please run this script as root or using sudo."
  exit 1
fi

echo "Updating and upgrading packages..."
yum -y update
check_command "Package updates"

# Enable firewall and configure rules (if not already configured)
if ! iptables -L | grep -q "Chain INPUT (policy DROP)"; then
  echo "Configuring the firewall..."

  iptables -P INPUT DROP

  iptables -A INPUT -p tcp --dport 22 -j ACCEPT

  iptables -A INPUT -i lo -j ACCEPT

  iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

  iptables-save > /etc/sysconfig/iptables
  check_command "Firewall configuration"

  systemctl enable iptables
  check_command "Firewall enabled on boot"
fi

# Configure and harden SSH
if [ -f "/etc/ssh/sshd_config" ]; then
  echo "Configuring SSH..."

  sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

  # Disable password-based authentication (use key-based authentication)
  sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

  # Restart SSH service
  systemctl restart sshd
  check_command "SSH configuration"
fi

echo "Removing unnecessary packages..."
yum -y remove telnet rsh
check_command "Unnecessary packages removed"

echo "Disabling unused services..."
systemctl disable <service-name>
check_command "Unused services disabled"

echo "Securing the cron daemon..."
chmod 600 /etc/cron.deny /etc/at.deny
chmod 644 /etc/cron.allow /etc/at.allow
check_command "Cron daemon security"

echo "Setting file permissions..."
find / -type f -exec chmod 644 {} \;
find / -type d -exec chmod 755 {} \;
check_command "File permissions set"

# Set secure permissions for sensitive files (adjust as needed)
chmod 600 /etc/shadow
chmod 600 /etc/gshadow
chmod 644 /etc/passwd
chmod 644 /etc/group
check_command "Secure permissions for sensitive files"

echo "Clearing history and logs..."
history -c
find /var/log -type f -exec truncate --size 0 {} \;
check_command "History and logs cleared"

echo "RedHat hardening completed."

# reboot
