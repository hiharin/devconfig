-- LSP: mason installs the tools, mason-lspconfig auto-enables each server
-- through Neovim's built-in client (0.11+ vim.lsp API).
--
-- mason-tool-installer owns the full "what must exist" list (servers +
-- formatters + linters, by mason package name) so a fresh checkout on any
-- OS self-provisions on first launch. conform.nvim (formatting.lua) and the
-- LSP servers below just consume what it installs.

require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup({
  ensure_installed = {
    'lua-language-server',
    'bash-language-server',
    'stylua',
    'shfmt',
  },
})

-- Advertise blink.cmp's extra completion capabilities to every server.
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = { checkThirdParty = false },
      diagnostics = { globals = { 'vim' } },
      telemetry = { enable = false },
    },
  },
})

-- Buffer-local keymaps once a server attaches
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('devconfig-lsp', { clear = true }),
  callback = function(args)
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = args.buf, desc = desc })
    end
    map('grd', vim.lsp.buf.definition, 'Go to definition')
    map('grD', vim.lsp.buf.declaration, 'Go to declaration')
    map('<leader>cf', function() vim.lsp.buf.format({ async = true }) end, 'Format buffer (LSP)')
    -- grn (rename), gra (code action), grr (references), gri (implementation),
    -- K (hover) are Neovim 0.11+ defaults.
  end,
})
