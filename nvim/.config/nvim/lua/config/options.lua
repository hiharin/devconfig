local o = vim.opt

-- UI
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = 'yes'
o.scrolloff = 8
o.termguicolors = true
o.list = true
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
o.inccommand = 'split'
o.splitright = true
o.splitbelow = true

-- Editing
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.breakindent = true
o.undofile = true
o.mouse = 'a'
o.clipboard = 'unnamedplus'

-- Search
o.ignorecase = true
o.smartcase = true

-- Responsiveness
o.updatetime = 250
o.timeoutlen = 400
