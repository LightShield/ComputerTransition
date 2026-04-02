# Colors
RED='\[\033[01;31m\]'
GREEN='\[\033[01;32m\]'
YELLOW='\[\033[01;33m\]'
BLUE='\[\033[01;34m\]'
MAGENTA='\[\033[01;35m\]'
CYAN='\[\033[01;36m\]'
RESET='\[\033[00m\]'

# Git branch function
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Function to display last command status if non-zero
last_status() {
    local exit_status=$?
    if [ $exit_status -ne 0 ]; then
        echo -e "${RED}[$exit_status]${RESET} "
    fi
}

# Set the PS1 prompt
# [status] user@host:fullpath (branch)$
PS1="\$(last_status)${GREEN}\u@\h${RESET}:${BLUE}\$PWD${RESET}${YELLOW}\$(parse_git_branch)${RESET}\$ "
