-- nvim-treesitter `main` branch (required for Neovim 0.12+). The old
-- `.configs.setup{ highlight = ... }` API is gone: parsers are installed with
-- `.install()`, and highlighting / indentation are opt-in per buffer.
--
-- Needs the `tree-sitter` CLI and a C compiler on PATH — see the Brewfile.
--
-- incremental_selection was dropped from this branch with no replacement; add
-- nvim-treesitter-textobjects (its own `main` branch) if you want it back.

local ts = require('nvim-treesitter')

-- One-time migration: an existing checkout from the old `master` branch has no
-- `.install()`. vim.pack won't switch branches on its own, so pull `main` now
-- and ask for a restart.
if type(ts.install) ~= 'function' then
  vim.notify(
    'nvim-treesitter: migrating to the main branch — restart Neovim when the update finishes.',
    vim.log.levels.WARN
  )
  vim.pack.update({ 'nvim-treesitter' }, { force = true })
  return
end

ts.setup({})

ts.install({
  'bash', 'c', 'diff', 'lua', 'luadoc', 'markdown', 'markdown_inline',
  'query', 'vim', 'vimdoc',
})

-- Turn on treesitter highlighting + indentation for any buffer whose language
-- has an installed parser.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('devconfig-treesitter', { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not (lang and pcall(vim.treesitter.language.add, lang)) then
      return
    end
    pcall(vim.treesitter.start, ev.buf, lang)
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
