-- Welcome to your Neovim configuration!
-- Neovim uses Lua as its configuration language.
-- Lines starting with '--' are comments.

-------------------------------------------------------------------------------
-- 1. BASIC SETTINGS (OPTIONS)
-------------------------------------------------------------------------------
-- In Lua, we use 'vim.opt' to set Neovim options.

-- Show line numbers on the left
vim.opt.number = true
-- Show relative line numbers (useful for jumping multiple lines)
vim.opt.relativenumber = true

-- Use 4 spaces for indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Enable mouse support (handy when starting out!)
vim.opt.mouse = 'a'

-- Keep the cursor in the middle of the screen when scrolling
vim.opt.scrolloff = 8

-- Enable 24-bit RGB color
vim.opt.termguicolors = true

-- Highlight the line the cursor is currently on
vim.opt.cursorline = true

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = 'unnamedplus'

-------------------------------------------------------------------------------
-- 2. KEYMAPS (SHORTCUTS)
-------------------------------------------------------------------------------
-- 'vim.keymap.set' is used to define new shortcuts.
-- Modes: 'n' = Normal, 'i' = Insert, 'v' = Visual

-- Set <Space> as your 'Leader' key (the prefix for many custom commands)
vim.g.mapleader = " "

-- Save file with Space + s
vim.keymap.set("n", "<leader>s", ":w<CR>", { desc = "Save file" })

-- TERMINAL MANAGEMENT
-- Open terminal in a bottom pane (split)
vim.keymap.set("n", "<leader>t", ":botright split | terminal<CR>i", { desc = "Terminal in bottom pane" })
-- Open terminal in a new tab
vim.keymap.set("n", "<leader>T", ":tab terminal<CR>i", { desc = "Terminal in new tab" })

-- Easy exit from terminal mode to normal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- IDE Navigation Shortcuts
-- Use Alt + h/j/k/l to move between split windows
vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Move to right window" })

-------------------------------------------------------------------------------
-- 3. PLUGIN MANAGER (LAZY.NVIM)
-------------------------------------------------------------------------------
-- This block 'bootstraps' lazy.nvim, which means it automatically downloads
-- the plugin manager if it's missing.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------------
-- 4. PLUGIN LIST
-------------------------------------------------------------------------------
-- Here we tell Lazy which plugins we want to install.

require("lazy").setup({
  -- COLORSCHEME: A nice theme for your editor
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- Load this immediately on startup
    priority = 1000, -- Load this before everything else
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- STATUSLINE: A beautiful bar at the bottom
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}, -- This tells the plugin to use default settings
  },

  -- KEYBINDING HELP: Press Space and wait, or Space + ?
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.timeout = true
      vim.opt.timeoutlen = 300
    end,
    config = function()
      local wk = require("which-key")
      wk.setup()
      vim.keymap.set("n", "<leader>?", function()
        wk.show({ global = false })
      end, { desc = "Buffer Local Keymaps (Help)" })
    end,
  },

  -- FILE EXPLORER: Press <leader>e to toggle
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
      vim.keymap.set("n", "<leader>b", ":NvimTreeFocus<CR>", { desc = "Focus File Explorer" })
    end,
  },

  -- FUZZY FINDER: Find files and text easily
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Search text in project" })
    end,
  },

  -- TREESITTER: High-performance syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" }, -- Load when you open a file
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    config = function()
      -- Use a safe require to avoid the 'module not found' error during first install
      local status, configs = pcall(require, "nvim-treesitter.configs")
      if not status then return end
      
      configs.setup({
        ensure_installed = { "lua", "python", "bash", "markdown", "javascript", "c" },
        highlight = { enable = true },
      })
    end,
  },

  -- AUTO-PAIRS: Automatically close brackets (), [], {}, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {} -- This runs setup() with default settings
  },

  -- COMPLETION ENGINE: The dropdown menus for code suggestions
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP source for cmp
      "hrsh7th/cmp-buffer",   -- Text in current buffer source
      "hrsh7th/cmp-path",     -- File system paths source
      "L3MON4D3/LuaSnip",     -- Snippet engine
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion manually
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept completion
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- LSP (Language Server Protocol): The 'Brain' of your IDE
  -- This provides autocomplete, 'Go to Definition', and error checking.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",           -- Automatically install LSPs
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright" },
        handlers = {
          -- This "default handler" automatically sets up every LSP you install
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
        },
      })

      -- Basic LSP keybinds
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Show documentation" })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
    end,
  },
})
