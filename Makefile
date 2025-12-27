.PHONY: help release-patch release-minor release-major release-version release-status release-check clean

# Color output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

help:
	@echo "$(BLUE)RapidSpec Release Management$(NC)"
	@echo ""
	@echo "$(GREEN)Version Bump & Release:$(NC)"
	@echo "  make release-patch               Bump patch version (0.0.11 → 0.0.12)"
	@echo "  make release-minor               Bump minor version (0.0.11 → 0.1.0)"
	@echo "  make release-major               Bump major version (0.1.0 → 1.0.0)"
	@echo "  make release-version VERSION=X.Y.Z   Bump to specific version"
	@echo ""
	@echo "$(GREEN)Release Status:$(NC)"
	@echo "  make release-status              Show latest workflow status"
	@echo "  make release-check               Check current version"
	@echo ""
	@echo "$(GREEN)Utility:$(NC)"
	@echo "  make help                        Show this help message"
	@echo ""
	@echo "$(YELLOW)Examples:$(NC)"
	@echo "  make release-patch"
	@echo "  make release-minor"
	@echo "  make release-version VERSION=1.0.0"
	@echo ""

# Get current version
CURRENT_VERSION := $(shell grep -m 1 'version = ' pyproject.toml | sed 's/.*version = "\([^"]*\)".*/\1/')

release-patch:
	@echo "$(BLUE)Bumping patch version...$(NC)"
	@./scripts/bump-version.sh patch

release-minor:
	@echo "$(BLUE)Bumping minor version...$(NC)"
	@./scripts/bump-version.sh minor

release-major:
	@echo "$(BLUE)Bumping major version...$(NC)"
	@./scripts/bump-version.sh major

release-version:
	@if [ -z "$(VERSION)" ]; then \
		echo "$(RED)Error: VERSION not specified$(NC)"; \
		echo "Usage: make release-version VERSION=0.0.12"; \
		exit 1; \
	fi
	@echo "$(BLUE)Bumping to version $(VERSION)...$(NC)"
	@./scripts/bump-version.sh $(VERSION)

release-status:
	@echo "$(BLUE)Latest Workflow Run:$(NC)"
	@gh run list --workflow=release.yml --limit=1 --json 'name,status,conclusion,createdAt' --jq '.[] | "\(.status) - \(.conclusion) - \(.createdAt)"' || echo "No workflows found"
	@echo ""
	@echo "$(BLUE)Latest Release:$(NC)"
	@gh release view --json 'tagName,name,publishedAt' --jq '"\(.tagName) - \(.name) - \(.publishedAt)"' || echo "No releases found"

release-check:
	@echo "$(BLUE)Release Status:$(NC)"
	@echo "  Current Version: $(CURRENT_VERSION)"
	@echo "  Git Branch: $$(git rev-parse --abbrev-ref HEAD)"
	@echo "  Git Status: $$(git status --short | wc -l) files changed"
	@echo ""
	@echo "$(GREEN)Ready to release?$(NC)"
	@echo "  1. Review changes: git status"
	@echo "  2. Bump version: make release-patch|minor|major"
	@echo "  3. Check status: make release-status"

clean:
	@echo "$(BLUE)Cleaning build artifacts...$(NC)"
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name ".tox" -exec rm -rf {} + 2>/dev/null || true
	@echo "$(GREEN)Cleaned!$(NC)"
