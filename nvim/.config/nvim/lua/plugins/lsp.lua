-- LSP: mason installs the servers, mason-lspconfig auto-enables each one
-- through Neovim's built-in client (0.11+ vim.lsp API).

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'bashls' },
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
