# Personal Claude Code account, kept isolated from the default (work) login
# via its own CLAUDE_CONFIG_DIR (separate credentials, settings, MCP config).
# First run will prompt `/login` for the personal account.
alias claude-personal='CLAUDE_CONFIG_DIR="$HOME/.claude-personal" claude'
