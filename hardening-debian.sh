#!/bin/bash

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or using sudo."
  exit 1
fi

echo "Updating and upgrading packages..."
apt-get update
apt-get upgrade -y

# Enable firewall and configure rules (if not already configured)
if ! iptables -L | grep -q "Chain INPUT (policy DROP)"; then
  echo "Configuring the firewall..."
<<<<<<< HEAD

  iptables -P INPUT DROP

  # Allow SSH (replace with your SSH port if necessary)
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT

  # Allow loopback traffic
  iptables -A INPUT -i lo -j ACCEPT

  # Allow established and related connections
  iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

=======
  # Set the default policy for INPUT chain to DROP
  iptables -P INPUT DROP
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
>>>>>>> add
  iptables-save > /etc/iptables.rules

  # Enable the firewall on boot
  echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections
  echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections
  apt-get install -y iptables-persistent
fi

# Configure and harden SSH
if [ -f "/etc/ssh/sshd_config" ]; then
  echo "Configuring SSH..."

<<<<<<< HEAD
  sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

  # Disable password-based authentication (use key-based authentication)
=======
  # Disable root login
  sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

>>>>>>> add
  sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

  systemctl restart ssh
fi

<<<<<<< HEAD
# Remove unnecessary packages (adjust according to your requirements)
=======
>>>>>>> add
echo "Removing unnecessary packages..."
apt-get remove -y --purge telnet rsh

echo "Disabling unused services..."
systemctl disable <service-name>

<<<<<<< HEAD
# Secure the cron daemon
=======
>>>>>>> add
echo "Securing the cron daemon..."
chmod o-rwx /etc/cron.deny /etc/at.deny
chmod o-rwx /etc/cron.allow /etc/at.allow

<<<<<<< HEAD
#echo "Setting file permissions..."
#find / -type f -exec chmod 644 {} \;
#find / -type d -exec chmod 755 {} \;
=======
echo "Setting file permissions..."
find / -type f -exec chmod 644 {} \;
find / -type d -exec chmod 755 {} \;
>>>>>>> add

# Set secure permissions for sensitive files (adjust as needed)
chmod 600 /etc/shadow
chmod 600 /etc/gshadow
chmod 644 /etc/passwd
chmod 644 /etc/group

# Clear history and logs
echo "Clearing history and logs..."
history -c
find /var/log -type f -exec truncate --size 0 {} \;

echo "Debian hardening completed."

# reboot
