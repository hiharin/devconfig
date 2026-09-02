require('telescope').setup({
  defaults = {
    layout_strategy = 'flex',
    sorting_strategy = 'ascending',
    layout_config = { prompt_position = 'top' },
  },
})

local builtin = require('telescope.builtin')
local map = vim.keymap.set
map('n', '<leader><leader>', builtin.find_files, { desc = 'Find files' })
map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
map('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
map('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
map('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
map('n', '<leader>fd', builtin.diagnostics, { desc = 'Diagnostics' })
map('n', '<leader>fr', builtin.resume, { desc = 'Resume last picker' })
