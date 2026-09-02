local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ── Appearance ───────────────────────────────────────────────────────────────
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font_with_fallback {
  'JetBrains Mono',
  'Menlo',
  'Consolas',
  'monospace',
}
config.font_size = 13.0
config.line_height = 1.05
config.window_padding = { left = 8, right = 8, top = 8, bottom = 4 }
config.window_decorations = 'TITLE | RESIZE'
config.scrollback_lines = 50000
config.audible_bell = 'Disabled'

-- ── Tab bar ──────────────────────────────────────────────────────────────────
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.tab_max_width = 32

-- ── Keys ─────────────────────────────────────────────────────────────────────
-- Leader mirrors tmux's C-a so muscle memory carries over between the two.
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- Splits inherit the current pane's cwd by default
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER',       action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'c', mods = 'LEADER',       action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'x', mods = 'LEADER',       action = act.CloseCurrentPane { confirm = true } },
  { key = 'z', mods = 'LEADER',       action = act.TogglePaneZoomState },

  -- Pane navigation
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -- Tabs
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },

  -- Send a literal C-a
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },

  -- Copy-mode / search
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = '/', mods = 'LEADER', action = act.Search 'CurrentSelectionOrEmptyString' },
}

-- Resize panes with LEADER + arrows
for _, dir in ipairs { 'Left', 'Right', 'Up', 'Down' } do
  table.insert(config.keys, {
    key = dir .. 'Arrow',
    mods = 'LEADER',
    action = act.AdjustPaneSize { dir, 5 },
  })
end

return config
