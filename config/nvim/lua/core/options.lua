-- options based on NvChad
local opt = vim.opt
local g = vim.g

opt.encoding = "utf-8"  -- displayed encoding
opt.fileencoding = "utf-8"  -- written encoding
-- opt.spell = true -- enable using :setlocal spell
opt.spelllang = {"en_gb", "pt_pt"}  -- default spell checking
opt.shell = "bash" -- set shell

g.mapleader = " "  -- set leader
g.maplocalleader = "\\" -- localleader

opt.laststatus = 3 -- global statusline
opt.showmode = false

-- ui
opt.title = true
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.colorcolumn = "80"
opt.showcmd = true
-- opt.cmdheight = 1 -- height of command bar
-- opt.pumheight = 10  -- pop-up menu height
opt.showmatch = true
-- opt.background = "dark"
opt.termguicolors = true  -- enables 24-bit rgb in TUI
-- opt.windblend = 0

-- Indenting
opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.softtabstop = 2
-- opt.autoindent = true
-- opt.wrap = false

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true  -- search as characters are entered
opt.hlsearch = true  -- highlight all matches
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false
opt.relativenumber = true

-- disable nvim intro
opt.shortmess:append "sI"

opt.scrolloff = 10
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 400
opt.undofile = true
opt.autochdir = true  -- auto change directory on file open
opt.backspace = "indent,eol,start"  -- allow backspacing over everything
-- opt.nostartofline = true -- make j/k respect the columns

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"


-- disable some builtin vim plugins
-- local default_plugins = {
--   "2html_plugin",
--   "getscript",
--   "getscriptPlugin",
--   "gzip",
--   "logipat",
--   "netrw",
--   "netrwPlugin",
--   "netrwSettings",
--   "netrwFileHandlers",
--   "matchit",
--   "tar",
--   "tarPlugin",
--   "rrhelper",
--   "spellfile_plugin",
--   "vimball",
--   "vimballPlugin",
--   "zip",
--   "zipPlugin",
--   "tutor",
--   "rplugin",
--   "syntax", -- syntax disabled by default, used by Vimtex
--   "synmenu",
--   "optwin",
--   "compiler",
--   "bugreport",
--   "ftplugin",
-- }

-- for _, plugin in pairs(default_plugins) do
--   g["loaded_" .. plugin] = 1
-- end

-- local default_providers = {
--   "node",
--   "perl",
--   "python3",
--   "ruby",
-- }
-- 
-- for _, provider in ipairs(default_providers) do
--   vim.g["loaded_" .. provider .. "_provider"] = 0
-- end

