-- Formatting via conform.nvim. format_on_save falls back to the LSP
-- formatter when no dedicated formatter (or its binary) is available.

require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    sh = { 'shfmt' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
})

vim.keymap.set('n', '<leader>cF', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format file (conform)' })
