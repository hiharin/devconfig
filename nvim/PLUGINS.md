# Neovim Plugins & Config Mods

Plugins are managed with Neovim's built-in `vim.pack` (0.12+) — no plugin
manager dependency. Declared in `lua/plugins/init.lua`, resolved versions are
locked in `nvim-pack-lock.json`. Run `:lua vim.pack.update()` to pull updates.

## Plugins

### token (colorscheme)
**What:** Dark colorscheme with a matching lualine theme.
**Why:** Consistent look across editor and statusline without hand-rolling a theme.

### nvim-web-devicons
**What:** Filetype icon set used by other plugins (lualine, telescope).
**Why:** Pure dependency — provides icons, not used directly.

### lualine.nvim
**What:** Statusline plugin.
**Why:** Readable mode/file/git/diagnostic status at a glance, themed to match `token` and set to `globalstatus` (one statusline for all splits instead of one per window).

### gitsigns.nvim
**What:** Git integration in the sign column (added/changed/removed line markers, hunk actions, blame).
**Why:** See and act on uncommitted changes without leaving the buffer or shelling out to `git diff`.
**What it does:** Adds `]c` / `[c` to jump between hunks, `<leader>gs`/`gr`/`gp` to stage/reset/preview a hunk, `<leader>gb` for a full blame of the current line. Bindings are buffer-local, set on attach.

### which-key.nvim
**What:** Popup that shows available keybindings as you type a prefix (e.g. after pressing `<leader>`).
**Why:** With leader-prefixed bindings spread across several plugin files, a discoverability aid beats memorizing everything.

### plenary.nvim
**What:** Lua utility library (async, path handling, job control).
**Why:** Pure dependency — required by telescope.nvim.

### telescope.nvim
**What:** Fuzzy finder / picker UI for files, grep results, buffers, help, diagnostics, etc.
**Why:** Fast fuzzy navigation is a bigger productivity win than any single feature — this is the primary way to move around a project.
**What it does:** `layout_strategy = 'flex'` adapts the picker layout to window width. Bound under `<leader>f*` (find files, live grep, buffers, help tags, diagnostics, resume last picker) — see `nvim/CHEATSHEET.md`.

### nvim-treesitter (`main` branch)
**What:** Incremental parser generator; provides accurate syntax highlighting and indentation from a real syntax tree instead of regex.
**Why:** More reliable highlighting/indent than Vim's built-in regex-based syntax files, especially for embedded languages and complex syntax.
**What it does:** Installs parsers for `bash`, `c`, `diff`, `lua`, `luadoc`, `markdown`, `markdown_inline`, `query`, `vim`, `vimdoc`. A `FileType` autocmd starts treesitter highlighting and switches on treesitter-based `indentexpr` for any buffer whose language has an installed parser.
**Note:** Pinned to the `main` branch because it's the only branch that supports Neovim 0.12+; the old `.configs.setup{ highlight = ... }` API and `incremental_selection` are gone from this branch. Requires the `tree-sitter` CLI and a C compiler on `PATH` (see the repo's `Brewfile`). The config includes a one-time migration check for existing checkouts on the old `master` branch.

### nvim-lspconfig
**What:** Community-maintained collection of sane default configs for language servers, consumed by Neovim's built-in LSP client.
**Why:** Avoids hand-writing `vim.lsp.config` boilerplate for every server.

### mason.nvim
**What:** Package manager for LSP servers, formatters, and linters (installs into `~/.local/share/nvim/mason`, cross-platform).
**Why:** Self-provisioning setup — a fresh checkout on macOS, Linux, WSL, or native Windows installs its own tools instead of relying on system package managers.

### mason-lspconfig.nvim
**What:** Bridges mason-installed servers into Neovim's LSP client automatically.
**Why:** Removes the manual step of registering each mason-installed server with `vim.lsp.config`/`enable`.

### mason-tool-installer.nvim
**What:** Declares one list of tools (by mason package name) that should always be installed, and installs anything missing on startup.
**Why:** Single source of truth for "what must exist" — currently `lua-language-server`, `bash-language-server`, `stylua`, `shfmt` — so LSP servers (`lsp.lua`) and formatters (`formatting.lua`) always have their backing binaries.

### blink.cmp
**What:** Completion engine with a prebuilt (Rust) fuzzy matcher.
**Why:** Chosen over nvim-cmp for a faster out-of-the-box fuzzy matcher and simpler setup; pinned to the `1` version tag specifically because it ships a prebuilt matcher binary (avoids a local Rust build).
**What it does:** `keymap = { preset = 'default' }` gives `<C-space>` to open the menu, `<C-y>` to accept, `<C-n>`/`<C-p>` to move selection. Completion sources: LSP, file paths, snippets, buffer words. Shows inline ghost text and auto-popup documentation. Also feeds `get_lsp_capabilities()` to every LSP server (in `lsp.lua`) so servers know blink.cmp's extended capabilities.

### conform.nvim
**What:** Formatter runner — wires up per-filetype formatters and format-on-save.
**Why:** Consistent formatting without each formatter needing its own bespoke Neovim integration.
**What it does:** Runs `stylua` for Lua and `shfmt` for shell. Formats on save (500ms timeout), falling back to the LSP's own formatter if no dedicated formatter/binary is available. `<leader>cF` runs it manually.

## Core config mods (not plugins)

### `lua/config/options.lua`
Sets editor behavior deliberately away from Vim defaults: relative+absolute
line numbers, always-on sign column (avoids text shifting when diagnostics
appear), 2-space indentation, persistent undo (`undofile`), system clipboard
integration, smart/ignorecase search, visible whitespace (`list`/`listchars`),
and a live substitute preview (`inccommand = 'split'`).

### `lua/config/autocmds.lua`
Three small quality-of-life behaviors: flash highlight on yank, restore
cursor to last edit position when reopening a file, and re-equalize split
sizes when the terminal window is resized.

### `lua/config/keymaps.lua`
General-purpose bindings not tied to a specific plugin: save/quit/delete
buffer, clear search highlight, `<C-hjkl>` window navigation, move
visually-selected lines up/down, centered half-page scroll and search
navigation, and diagnostic navigation (`]d`/`[d`, `<leader>cd`). Full list in
`nvim/CHEATSHEET.md`.

### `lua/plugins/lsp.lua`
Not a plugin itself, but the glue that turns mason-installed servers into a
working LSP setup: registers `lua_ls` settings, advertises blink.cmp's
capabilities to every server, and adds two buffer-local keymaps (`grd`,
`grD`) on top of Neovim 0.11+'s built-in LSP defaults (`grr`, `gra`, `gri`,
`grn`, `K`).
