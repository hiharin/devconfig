# devconfig — GNU Stow dotfiles
#
#   make install     symlink all packages into $HOME
#   make uninstall   remove those symlinks
#   make restow      re-sync links (run after adding/removing files in a package)
#   make check       report which expected tools are installed
#   make PKG=nvim install   operate on a single package

PACKAGES ?= nvim tmux wezterm claude
PKG      ?= $(PACKAGES)
STOW     ?= stow
TARGET   ?= $(HOME)

.PHONY: install uninstall restow check help

help:
	@echo 'make install     symlink all packages into $$HOME'
	@echo 'make uninstall   remove those symlinks'
	@echo 'make restow      re-sync links after adding/removing files'
	@echo 'make check       report which expected tools are installed'
	@echo 'make PKG=nvim install   operate on a single package'

install:
	@command -v $(STOW) >/dev/null 2>&1 || { echo "stow not found — run ./bootstrap.sh"; exit 1; }
	$(STOW) --target=$(TARGET) --verbose $(PKG)
	@echo "Linked: $(PKG)"

uninstall:
	$(STOW) --target=$(TARGET) --delete --verbose $(PKG)

restow:
	$(STOW) --target=$(TARGET) --restow --verbose $(PKG)

check:
	@for t in stow nvim tmux wezterm; do \
		if command -v $$t >/dev/null 2>&1; then \
			printf '  \033[32mok\033[0m   %s (%s)\n' "$$t" "$$(command -v $$t)"; \
		else \
			printf '  \033[31mmiss\033[0m %s\n' "$$t"; \
		fi; \
	done
	@grep -q 'claude-profiles' $(HOME)/.zshrc 2>/dev/null \
		&& echo "  ok   ~/.zshrc sources ~/.claude-profiles.sh" \
		|| echo "  miss ~/.zshrc does not source ~/.claude-profiles.sh (run ./bootstrap.sh)"
