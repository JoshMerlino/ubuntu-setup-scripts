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
echo "PS1='\e[30;44m \h \e[0m\e[34;104m\e[0m\e[0m\e[30;104m \u \e[0m\e[94;107m\e[0m\e[0m\e[30;107m \w \e[0m\e[97m\e[0m '" >> /etc/profile

# Set up aliases
echo "alias ls='ls --color=auto'" >> /etc/profile
echo "alias grep='grep --color=auto'" >> /etc/profile
echo "alias fgrep='fgrep --color=auto'" >> /etc/profile
echo "alias egrep='egrep --color=auto'" >> /etc/profile
echo "alias ll='ls -alF'" >> /etc/profile
echo "alias la='ls -A'" >> /etc/profile
echo "alias l='ls -CF'" >> /etc/profile

# If wsl setup
if grep -q microsoft /proc/version; then echo "alias reboot=\"echo \\\"Run 'Get-Service LxssManager | Restart-Service' as administrator in PowerShell.\\\"\"" >> /etc/profile; fi


# Link root to home dir
ln -fs /root /home/root
cd /home

# Purge all old .bash* files
sudo find -L . -name ".bash*" -type f -delete
