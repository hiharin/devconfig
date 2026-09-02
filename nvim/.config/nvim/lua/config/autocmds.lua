local augroup = vim.api.nvim_create_augroup('devconfig', { clear = true })

-- Flash yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  callback = function() vim.hl.on_yank() end,
})

-- Return to last edit position when opening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Equalise splits when the terminal is resized
vim.api.nvim_create_autocmd('VimResized', {
  group = augroup,
  command = 'wincmd =',
})
