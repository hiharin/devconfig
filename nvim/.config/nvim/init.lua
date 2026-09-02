vim.pack.add({
  {
    src = 'https://github.com/ThorstenRhau/token',
    version = vim.version.range('*'),
  },
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim',
})

vim.o.background = 'dark'
vim.cmd.colorscheme('token')

require('lualine').setup({
  options = {
    theme = 'token',
    globalstatus = true,
  },
})
