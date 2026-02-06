# 1Password Connect Helm Charts

CHART_SEARCH_ROOT := charts

.PHONY: docs docs-connect docs-secrets-injector docs-check docs-check-connect docs-check-secrets-injector help

##@ Documentation

docs: docs-connect docs-secrets-injector ## Generate README.md files for all charts

docs-connect: ## Generate README.md for the connect chart
	@helm-docs --chart-search-root=$(CHART_SEARCH_ROOT)/connect
	@echo "Documentation generated successfully.\n"

docs-secrets-injector: ## Generate README.md for the secrets-injector chart
	@helm-docs --chart-search-root=$(CHART_SEARCH_ROOT)/secrets-injector
	@echo "Documentation generated successfully.\n"

docs-check: ## Check if all README.md files are up-to-date
	@FAILED=0; \
	$(MAKE) --no-print-directory docs-check-connect 2>/dev/null || FAILED=1; \
	$(MAKE) --no-print-directory docs-check-secrets-injector 2>/dev/null || FAILED=1; \
	if [ $$FAILED -eq 1 ]; then \
		echo "Run 'make docs' to regenerate all README files."; \
		exit 1; \
	fi

docs-check-connect: ## Check if connect README.md is up-to-date
	@echo "Checking connect chart documentation..."
	@helm-docs --chart-search-root=$(CHART_SEARCH_ROOT)/connect --dry-run 2>/dev/null | diff -q $(CHART_SEARCH_ROOT)/connect/README.md - > /dev/null 2>&1 || \
		(echo "ERROR: connect/README.md is out of date. Run 'make docs-connect' to regenerate.\n" && exit 1)
	@echo "connect chart documentation is up-to-date.\n"

docs-check-secrets-injector: ## Check if secrets-injector README.md is up-to-date
	@echo "Checking secrets-injector chart documentation..."
	@helm-docs --chart-search-root=$(CHART_SEARCH_ROOT)/secrets-injector --dry-run 2>/dev/null | diff -q $(CHART_SEARCH_ROOT)/secrets-injector/README.md - > /dev/null 2>&1 || \
		(echo "ERROR: secrets-injector/README.md is out of date. Run 'make docs-secrets-injector' to regenerate.\n" && exit 1)
	@echo "secrets-injector chart documentation is up-to-date.\n"

##@ Help

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
