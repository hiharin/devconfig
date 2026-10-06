-- Plugins are managed with Neovim's built-in `vim.pack` (0.12+).
-- The resolved commits are written to nvim-pack-lock.json; run
-- `:lua vim.pack.update()` to pull newer versions.

vim.pack.add({
  -- Colorscheme + statusline
  { src = 'https://github.com/ThorstenRhau/token', version = vim.version.range('*') },
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim',

  -- Editing niceties
  'https://github.com/lewis6991/gitsigns.nvim',
  { src = 'https://github.com/folke/which-key.nvim', version = vim.version.range('*') },

  -- Fuzzy finder
  'https://github.com/nvim-lua/plenary.nvim',
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = vim.version.range('*') },

  -- Treesitter (main branch: the only branch that supports Neovim 0.12+)
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  -- LSP + cross-platform tool management (mason installs servers/formatters/
  -- linters on macOS, Linux, WSL, and native Windows alike)
  'https://github.com/neovim/nvim-lspconfig',
  { src = 'https://github.com/mason-org/mason.nvim', version = vim.version.range('*') },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim', version = vim.version.range('*') },
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',

  -- Completion (versioned tag ships a prebuilt fuzzy-matcher binary)
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1') },

  -- Formatting
  { src = 'https://github.com/stevearc/conform.nvim', version = vim.version.range('*') },

  -- Markdown rendering in-buffer (needs the markdown + markdown_inline parsers)
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim', version = vim.version.range('*') },
})

-- Colorscheme
vim.o.background = 'dark'
vim.cmd.colorscheme('token')

-- Simple plugin setups
require('nvim-web-devicons').setup()
require('lualine').setup({ options = { theme = 'token', globalstatus = true } })
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map('n', ']c', function() gs.nav_hunk('next') end, 'Next git hunk')
    map('n', '[c', function() gs.nav_hunk('prev') end, 'Prev git hunk')
    map('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
    map('n', '<leader>gr', gs.reset_hunk, 'Reset hunk')
    map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, 'Blame line')
  end,
})
require('which-key').setup()

-- Renders markdown in the buffer (styled headings, bullets, tables, code
-- blocks) and un-renders the line the cursor is on so it stays editable.
-- LaTeX rendering is off: it shells out to `latex2text`, which isn't in the
-- Brewfile, and would error on every `$$` block.
require('render-markdown').setup({ latex = { enabled = false } })
vim.keymap.set('n', '<leader>um', function()
  require('render-markdown').toggle()
end, { desc = 'Toggle markdown rendering' })

-- Feature modules (order matters: completion before lsp for capabilities)
require('plugins.treesitter')
require('plugins.completion')
require('plugins.lsp')
require('plugins.formatting')
require('plugins.telescope')
