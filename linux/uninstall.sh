#!/bin/bash

# Define the pattern to search for in ~/.bashrc
START_MARKER="# --- ComputerTransition bashrc.d ---"
END_MARKER="# --- End of ComputerTransition bashrc.d ---"

if [ -L ~/.config/nvim ]; then
  echo "Removing Neovim symlink..."
  rm ~/.config/nvim
fi

if [ -L ~/.config/wezterm/wezterm.lua ]; then
  echo "Removing WezTerm symlink..."
  rm ~/.config/wezterm/wezterm.lua
fi

if [ -L ~/.local/share/applications/wezterm.desktop ]; then
  echo "Removing WezTerm desktop symlink..."
  rm ~/.local/share/applications/wezterm.desktop
fi

if command -v kwriteconfig6 &> /dev/null; then
  echo "Removing WezTerm global shortcut..."
  kwriteconfig6 --file ~/.config/kglobalshortcutsrc \
                --group "services" \
                --group "wezterm.desktop" \
                --key "_launch" --delete
  
  dbus-send --session --type=method_call --dest=org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel.reconfigure
fi

if command -v wezterm &> /dev/null; then
  echo "Uninstalling WezTerm and Fira Code..."
  sudo dnf remove -y wezterm fira-code-fonts
  sudo dnf copr disable -y wezfurlong/wezterm-nightly
fi

echo "Removing Git SSH preference for GitHub..."
git config --global --unset url."git@github.com:".insteadOf

if grep -q "$START_MARKER" ~/.bashrc; then
  echo "Removing bashrc.d source block from ~/.bashrc..."
  # Use sed to remove the block between markers
  sed -i "/$START_MARKER/,/$END_MARKER/d" ~/.bashrc
  echo "Uninstall complete! Please run 'source ~/.bashrc' or restart your terminal."
else
  echo "ComputerTransition configuration not found in ~/.bashrc."
fi
