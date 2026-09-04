# devconfig — GNU Stow dotfiles
#
#   make deps        install system packages from Brewfile
#   make install     symlink all packages into $HOME
#   make uninstall   remove those symlinks
#   make restow      re-sync links (run after adding/removing files in a package)
#   make check       report which expected tools are installed
#   make PKG=nvim install   operate on a single package

PACKAGES ?= nvim tmux wezterm claude shell
PKG      ?= $(PACKAGES)
STOW     ?= stow
TARGET   ?= $(HOME)

.PHONY: deps install uninstall restow check help

help:
	@echo 'make deps        install system packages from Brewfile'
	@echo 'make install     symlink all packages into $$HOME'
	@echo 'make uninstall   remove those symlinks'
	@echo 'make restow      re-sync links after adding/removing files'
	@echo 'make check       report which expected tools are installed'
	@echo 'make PKG=nvim install   operate on a single package'

deps:
	@command -v brew >/dev/null 2>&1 || { echo "Homebrew not found — run ./bootstrap.sh"; exit 1; }
	brew bundle --file=Brewfile

install:
	@command -v $(STOW) >/dev/null 2>&1 || { echo "stow not found — run 'make deps' or ./bootstrap.sh"; exit 1; }
	$(STOW) --target=$(TARGET) --verbose $(PKG)
	@echo "Linked: $(PKG)"

uninstall:
	$(STOW) --target=$(TARGET) --delete --verbose $(PKG)

restow:
	$(STOW) --target=$(TARGET) --restow --verbose $(PKG)

check:
	@for t in stow nvim tmux node rg fd; do \
		if command -v $$t >/dev/null 2>&1; then \
			printf '  \033[32mok\033[0m   %s (%s)\n' "$$t" "$$(command -v $$t)"; \
		else \
			printf '  \033[31mmiss\033[0m %s\n' "$$t"; \
		fi; \
	done
	@if command -v wezterm >/dev/null 2>&1; then \
		printf '  \033[32mok\033[0m   wezterm (%s)\n' "$$(command -v wezterm)"; \
	elif [ "$$(uname -s)" = "Darwin" ]; then \
		printf '  \033[31mmiss\033[0m wezterm\n'; \
	else \
		printf '  \033[33minfo\033[0m wezterm not on PATH — Homebrew has no Linux build; install via apt (see README.md)\n'; \
	fi
	@command -v brew >/dev/null 2>&1 \
		&& { brew bundle check --no-upgrade --file=Brewfile >/dev/null 2>&1 \
			&& echo "  ok   Brewfile satisfied" \
			|| echo "  miss Brewfile has unmet dependencies (run 'make deps')"; } \
		|| echo "  miss Homebrew not installed (run ./bootstrap.sh)"
	@if grep -qs 'claude-profiles' $(HOME)/.zshrc $(HOME)/.bashrc 2>/dev/null; then \
		echo "  ok   shell rc sources ~/.claude-profiles.sh"; \
	else \
		echo "  miss shell rc (~/.zshrc or ~/.bashrc) does not source ~/.claude-profiles.sh (run ./bootstrap.sh)"; \
	fi
	@if grep -qs 'devconfig/shell-integration.sh' $(HOME)/.zshrc $(HOME)/.bashrc 2>/dev/null; then \
		echo "  ok   shell rc sources shell-integration.sh"; \
	else \
		echo "  miss shell rc (~/.zshrc or ~/.bashrc) does not source shell-integration.sh (run ./bootstrap.sh)"; \
	fi
