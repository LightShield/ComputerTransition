-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- --- COLORS & FONT ---
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font 'Fira Code'
config.font_size = 12.0

-- --- WINDOW ---
config.window_background_opacity = 0.95
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- --- PERFORMANCE ---
config.front_end = "WebGpu"

-- --- KEYBINDINGS (IDE Style) ---
config.keys = {
  -- SPLIT PANES (Alt + s for horizontal, Alt + v for vertical)
  {
    key = 's',
    mods = 'ALT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'v',
    mods = 'ALT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  
  -- CLOSE PANE (Alt + w)
  {
    key = 'w',
    mods = 'ALT',
    action = act.CloseCurrentPane { confirm = true },
  },

  -- NAVIGATION (Alt + h/j/k/l to move between panes)
  {
    key = 'h',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Down',
  },

  -- FULLSCREEN (Alt + Enter)
  {
    key = 'Enter',
    mods = 'ALT',
    action = act.ToggleFullScreen,
  },

  -- TABS (Alt + t for new tab, Alt + [ / ] for navigation)
  {
    key = 't',
    mods = 'ALT',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = '[',
    mods = 'ALT',
    action = act.ActivateTabRelative(-1),
  },
  {
    key = ']',
    mods = 'ALT',
    action = act.ActivateTabRelative(1),
  },

  -- Jump to tabs 1-9 (Alt + 1-9)
  { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
  { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
  { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
  { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
  { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
  { key = '6', mods = 'ALT', action = act.ActivateTab(5) },
  { key = '7', mods = 'ALT', action = act.ActivateTab(6) },
  { key = '8', mods = 'ALT', action = act.ActivateTab(7) },
  { key = '9', mods = 'ALT', action = act.ActivateTab(8) },
}

-- Return the configuration to wezterm
return config
