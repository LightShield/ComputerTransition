#!/bin/bash

# Constant for default color temperature
DEFAULT_COLOR_TEMPERATURE=1700

enable_nightlight() {
    local color_temperature=${1:-$DEFAULT_COLOR_TEMPERATURE}
    # Enable Night Light
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    # Set the color temperature
    gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature "$color_temperature"
}

# Call the function with the desired temperature
enable_nightlight "$@"


install_thefuck() {
    # Install python3 and python3-pip if they are not installed
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip

    # Install TheFuck
    sudo pip3 install thefuck

    # Setup TheFuck using the automatic append to the correct config file
    thefuck --alias >> ~/.bashrc

    # Reload bashrc to reflect changes
    source ~/.bashrc
}

update_git_aliases() {
    # Add or update git aliases
    git config --global alias.co checkout
    git config --global alias.st status
    git config --global alias.lola "log --graph --decorate --pretty=oneline --abbrev-commit --all"
    git config --global alias.conflicts "diff --name-only --diff-filter=U"
    git config --global alias.subup "submodule update --init --recursive"
    git config --global alias.l log --format='%C(yellow)%h%C(reset) %C(blue)%cd%C(reset) %C(green)<%an>%C(reset) %C(red)%d%C(reset) %s'
    echo "Git aliases updated successfully."
}

update_see_branch_from_directory() {
    # Backup the existing .bashrc file
    cp ~/.bashrc ~/.bashrc.backup

    # Append the parse_git_branch function and PS1 modification to .bashrc
    {
        echo 'parse_git_branch() {'
        echo ' git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\\1)/"'
        echo '}'
        echo 'if [ "$color_prompt" = yes ]; then'
        echo ' PS1="${debian_chroot:+($debian_chroot)}\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[01;31m\\]\\$(parse_git_branch)\\[\\033[00m\\]\\$ "'
        echo 'else'
        echo ' PS1="${debian_chroot:+($debian_chroot)}\\u@\\h:\\w\\$(parse_git_branch)\\$ "'
        echo 'fi'
    } >> ~/.bashrc

    # Reload .bashrc to reflect changes
    source ~/.bashrc

    echo "Git branch in prompt has been enabled."
}


main() {
	enable_nightlight
	install_thefuck
	update_git_aliases
	update_see_branch_from_directory
}

main
