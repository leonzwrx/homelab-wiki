```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```

# Post-Installation Steps for RHEL 9 Server
_Updated June 2025_

**General steps**
- For a basic RHEL9 VM, follow most defaults, automatic partitioning and disable root
- using `hostnamectl hostname` set hostname, set static IP
- Enable ssh, then via SSH or shell, install some basics below.
- copy any relevant dotfiles and .bashrc from https://github.com/leonzwrx/dotfiles

### Red Hat Subscription Management

First, register your system with Red Hat Subscription Management:

```bash
sudo subscription-manager register --username <your_Red_Hat_account_username> --password <your_Red_Hat_account_password>
```
Register (with Simple Content Access, no need to attach a license:
```bash
sudo subscription-manager refresh
#list available Developer subscription pool ID:
sudo subscription-manager list --available
```

### Install EPEL
```bash
sudo dnf install -y 'dnf-command(config-manager)'
sudo dnf config-manager --set-enabled crb
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
```

### Install Basics
```bash
sudo dnf install htop ncdu vim neofetch ranger git
#install starship
curl -sS https://starship.rs/install.sh | sh
```

- Enable Cockpit and set firewall zone to home:
`systemctl enable cockpit.service --now`
`firewall-cmd --set-default-zone=home`

### Others
```
dnf install command-line-assistant
```