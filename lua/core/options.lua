-- General
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.smartindent = true
vim.opt.timeoutlen = 200
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.shortmess:append("A")

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Mouse
vim.opt.mousemoveevent = true

-- UI & Appearance
vim.opt.termguicolors = true
vim.opt.pumheight = 10
vim.opt.showmode = false
vim.opt.showtabline = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.guifont = "JetBainsMono Nerd Font"

-- Cursor & Scrolling
vim.opt.cursorline = true
vim.opt.scrolloff = 15
vim.opt.sidescrolloff = 8

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.signcolumn = "yes"

-- Tabs & Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Wrapping & Formatting
vim.opt.wrap = false
vim.opt.linebreak = true

-- Status Line & Tabline
vim.opt.laststatus = 1
vim.opt.tabline = "%t"

-- Hidden Characters
vim.opt.list = true
vim.opt.listchars:append("space:.")
-- vim.opt.listchars:append "eol:↴"

-- Spell Chck
vim.opt.spell = true
vim.opt.spelllang = "en_us,pt_br"

-- Disable netrw (for better file explorer alternatives like nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
