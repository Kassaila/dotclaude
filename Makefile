.PHONY: help install install-mcp install-external uninstall status
.DEFAULT_GOAL := help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Symlink skills, agents, and config to ~/.claude/
	@chmod +x ./bin/install.sh
	@./bin/install.sh

install-mcp: ## Merge global MCP servers into ~/.claude/settings.json
	@chmod +x ./bin/install-mcp.sh
	@./bin/install-mcp.sh

install-external: ## Install external skills from external-skills.json
	@chmod +x ./bin/install-external.sh
	@./bin/install-external.sh

uninstall: ## Remove dotclaude symlinks from ~/.claude/
	@chmod +x ./bin/uninstall.sh
	@./bin/uninstall.sh

status: ## Show dotclaude and external skills status
	@chmod +x ./bin/status.sh
	@./bin/status.sh
