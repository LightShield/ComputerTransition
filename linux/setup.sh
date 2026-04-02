#!/bin/bash

# Define the absolute path of the bashrc.d directory
BASHRC_D_PATH="$(realpath "$(dirname "$0")/bashrc.d")"

# --- WezTerm Installation ---
if ! command -v wezterm &> /dev/null; then
  echo "Installing WezTerm and Fira Code..."
  sudo dnf copr enable -y wezfurlong/wezterm-nightly
  sudo dnf install -y wezterm fira-code-fonts
fi

# --- WezTerm Linking ---
WEZTERM_CONFIG_PATH="$(realpath "$(dirname "$0")/wezterm")"
mkdir -p ~/.config/wezterm
mkdir -p ~/.local/share/applications

if [ ! -L ~/.config/wezterm/wezterm.lua ]; then
  echo "Linking WezTerm config..."
  ln -s "$WEZTERM_CONFIG_PATH/wezterm.lua" ~/.config/wezterm/wezterm.lua
fi

if [ ! -L ~/.local/share/applications/wezterm.desktop ]; then
  echo "Linking WezTerm desktop entry..."
  ln -s "$WEZTERM_CONFIG_PATH/wezterm.desktop" ~/.local/share/applications/wezterm.desktop
fi

# --- KDE Global Shortcut (Ctrl+Alt+T) ---
if command -v kwriteconfig6 &> /dev/null; then
  echo "Setting Ctrl+Alt+T shortcut for WezTerm..."
  kwriteconfig6 --file ~/.config/kglobalshortcutsrc \
                --group "services" \
                --group "wezterm.desktop" \
                --key "_launch" "Ctrl+Alt+T,none,WezTerm"
  
  # Trigger KDE to reload shortcuts
  dbus-send --session --type=method_call --dest=org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel.reconfigure
fi

# --- Git Configuration ---
echo "Configuring Git to prefer SSH for GitHub..."
git config --global url."git@github.com:".insteadOf "https://github.com/"

# --- Neovim Linking ---
NVIM_CONFIG_PATH="$(realpath "$(dirname "$0")/neovim")"
mkdir -p ~/.config
if [ ! -L ~/.config/nvim ] && [ ! -d ~/.config/nvim ]; then
  echo "Linking neovim config to ~/.config/nvim..."
  ln -s "$NVIM_CONFIG_PATH" ~/.config/nvim
elif [ -L ~/.config/nvim ]; then
  echo "Neovim symlink already exists."
else
  echo "Warning: ~/.config/nvim already exists and is a directory. Skipping symlink."
fi

# Block of code to append to ~/.bashrc
BASH_CONFIG_BLOCK="
# --- ComputerTransition bashrc.d ---
if [ -d \"$BASHRC_D_PATH\" ]; then
  for file in \"$BASHRC_D_PATH\"/*.sh; do
    [ -r \"\$file\" ] && . \"\$file\"
  done
fi
# --- End of ComputerTransition bashrc.d ---"

# Check if the block is already in ~/.bashrc to avoid duplicates
if ! grep -q "ComputerTransition bashrc.d" ~/.bashrc; then
  echo "Adding bashrc.d source loop to ~/.bashrc..."
  echo "$BASH_CONFIG_BLOCK" >> ~/.bashrc
  echo "Setup complete! Please run 'source ~/.bashrc' or restart your terminal."
else
  echo "bashrc.d loop already exists in ~/.bashrc."
fi
