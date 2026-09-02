require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash', 'c', 'diff', 'lua', 'luadoc', 'markdown', 'markdown_inline',
    'query', 'vim', 'vimdoc',
  },
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
    },
  },
})
