# Custom Aliases
alias ll='ls -la'
alias reload='source ~/.bashrc'

# Create a directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}
