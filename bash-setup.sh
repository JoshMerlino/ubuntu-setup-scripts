#!/bin/bash
username=$1

# Make sure user exists
if getent passwd $username > /dev/null 2>&1; then
    echo "Setting up '$username' as the admin user."
else
    echo "User '$username' does not exist."
    exit
fi

# Set up no password
groupadd -f nopasswd
usermod -a -G nopasswd $username
echo "%nopasswd ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nopasswd

# Set up color prompt
echo "PS1='\e[30;44m \h \e[0m\e[34;104m\e[0m\e[0m\e[30;104m \u \e[0m\e[94;107m\e[0m\e[0m\e[30;107m \w \e[0m\e[97m\e[0m '" > /etc/profile.d/bash_prompt.sh

# Make profile executable
sudo chmod +x /etc/profile

# Set up aliases
echo "" > /etc/profile.d/bash_aliases.sh
echo "alias ls='ls --color=auto'" >> /etc/profile.d/bash_aliases.sh
echo "alias grep='grep --color=auto'" >> /etc/profile.d/bash_aliases.sh
echo "alias fgrep='fgrep --color=auto'" >> /etc/profile.d/bash_aliases.sh
echo "alias egrep='egrep --color=auto'" >> /etc/profile.d/bash_aliases.sh
echo "alias ll='ls -alF'" >> /etc/profile.d/bash_aliases.sh
echo "alias la='ls -A'" >> /etc/profile.d/bash_aliases.sh
echo "alias l='ls -CF'" >> /etc/profile.d/bash_aliases.sh
echo "alias sudo='sudo -i /etc/profile'" >> /etc/profile.d/bash_aliases.sh

# If wsl setup
if grep -q microsoft /proc/version; then echo "alias reboot=\"echo \\\"Run 'Get-Service LxssManager | Restart-Service' as administrator in PowerShell.\\\"\"" >> /etc/profile.d/bash_aliases.sh; fi

# Link root to home dir
ln -fs /root /home/root
cd /home

# Purge all old .bash* files
sudo find -L . -name ".bash*" -type f -delete

# install git
sudo apt install git

# Add NodeJS
groupadd -f nvm
git clone https://github.com/creationix/nvm.git /opt/nvm
mkdir /usr/local/nvm
mkdir /usr/local/node
chown -R root:nvm /usr/local/nvm
chmod -R 775 /usr/local/nvm
chown -R root:nvm /usr/local/node
chmod -R 775 /usr/local/node
echo "export NVM_DIR=/usr/local/nvm" > /etc/profile.d/nvm.sh
echo "source /opt/nvm/nvm.sh" >> /etc/profile.d/nvm.sh
echo "export NPM_CONFIG_PREFIX=/usr/local/node" >> /etc/profile.d/nvm.sh
echo "export PATH=\"/usr/local/node/bin:\$PATH\"" >> /etc/profile.d/nvm.sh

# Source all environments
sudo chmod +x /etc/profile.d/*.sh
source /etc/profile
