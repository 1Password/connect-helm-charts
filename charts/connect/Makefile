# 1Password Connect Helm Chart - Testing

# Configuration
CHART_NAME := connect
NAMESPACE := onepassword-connect-test
KIND_CLUSTER_NAME := onepassword-connect-test
HELM_TIMEOUT := 120s

# Credentials
OP_CONNECT_CREDENTIALS ?= $(shell cat ~/.op/connect-credentials.json 2>/dev/null || echo "")
OP_CONNECT_TOKEN ?= $(shell op item get "Connect Token" --fields token 2>/dev/null || echo "")

# Test fixture values (must be set as environment variables)
# OP_VAULT_ID - 1Password vault ID for testing
# OP_ITEM_ID - 1Password item ID for testing  
# OP_SECRET_VALUE - Expected secret value for testing

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

.PHONY: help test-e2e test-e2e-setup test-e2e-run cleanup-test-e2e check-deps

test-e2e: check-deps test-e2e-setup test-e2e-run cleanup-test-e2e ## Run end-to-end tests (full workflow)

test-e2e-setup: ## Setup test environment
	@echo "$(BLUE)Setting up test environment...$(NC)"

	# Check if all required environment variables are set
	@if [ -z "$(OP_CONNECT_CREDENTIALS)" ]; then \
		echo "$(RED)Error: OP_CONNECT_CREDENTIALS environment variable is required$(NC)"; \
		exit 1; \
	fi
	@if [ -z "$(OP_CONNECT_TOKEN)" ]; then \
		echo "$(RED)Error: OP_CONNECT_TOKEN environment variable is required$(NC)"; \
		exit 1; \
	fi

	@if [ -z "$(OP_VAULT_ID)" ]; then \
		echo "$(RED)Error: OP_VAULT_ID environment variable is required$(NC)"; \
		echo "$(YELLOW)Set OP_VAULT_ID to your 1Password vault ID for testing$(NC)"; \
		exit 1; \
	fi
	@if [ -z "$(OP_ITEM_ID)" ]; then \
		echo "$(RED)Error: OP_ITEM_ID environment variable is required$(NC)"; \
		echo "$(YELLOW)Set OP_ITEM_ID to your 1Password item ID for testing$(NC)"; \
		exit 1; \
	fi
	@if [ -z "$(OP_SECRET_VALUE)" ]; then \
		echo "$(RED)Error: OP_SECRET_VALUE environment variable is required$(NC)"; \
		echo "$(YELLOW)Set OP_SECRET_VALUE to the expected secret value for testing$(NC)"; \
		exit 1; \
	fi

	# Create Kind cluster
	@echo "$(BLUE)Creating Kind cluster...$(NC)"
	@kind create cluster --name $(KIND_CLUSTER_NAME) --wait 60s || true

	# Create namespace
	@echo "$(BLUE)Creating namespace...$(NC)"
	@kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -

	# Prepare test fixtures
	@echo "$(BLUE)Preparing test fixtures...$(NC)"
	@echo "acceptanceTests:" > fixtures.yaml
	@echo "  enabled: true" >> fixtures.yaml
	@echo "  fixtures:" >> fixtures.yaml
	@echo "    vaultId: $(OP_VAULT_ID)" >> fixtures.yaml
	@echo "    itemId: $(OP_ITEM_ID)" >> fixtures.yaml
	@echo "    secretValue: $(OP_SECRET_VALUE)" >> fixtures.yaml

	# Process CI values files
	@echo "$(BLUE)Processing CI values files...$(NC)"
	@for values_file in ci/*.yaml; do \
		echo "$(BLUE)Processing $$values_file...$(NC)"; \
		yq eval '.connect.credentials = strenv(OP_CONNECT_CREDENTIALS) | .operator.token.value = strenv(OP_CONNECT_TOKEN)' -i $$values_file; \
		yq eval-all --inplace 'select(fileIndex == 0) * select(fileIndex == 1)' $$values_file fixtures.yaml; \
	done

	@echo "$(GREEN)Test environment setup complete$(NC)"

test-e2e-run: ## Run the actual tests
	@echo "$(BLUE)Running end-to-end tests...$(NC)"

	# Set up Helm repository
	@helm repo add stable https://charts.helm.sh/stable || true
	@helm repo update

	# Run chart testing
	@echo "$(BLUE)Installing chart and running tests...$(NC)"
	@cd ../.. && ct install --config ct.yaml --charts charts/connect --namespace $(NAMESPACE)

	@echo "$(GREEN)Tests completed successfully!$(NC)"

cleanup-test-e2e: ## Cleanup test environment
	@echo "$(BLUE)Cleaning up test environment...$(NC)"

	# Delete Kind cluster
	@kind delete cluster --name $(KIND_CLUSTER_NAME) || true

	# Clean up temporary files
	@rm -f fixtures.yaml

	@echo "$(GREEN)Cleanup complete$(NC)"

test-e2e-debug: check-deps test-e2e-setup ## Run tests without cleanup (for debugging)
	@echo "$(BLUE)Running tests (keeping cluster for debugging)...$(NC)"
	@cd ../.. && ct install --config ct.yaml --charts charts/connect --namespace $(NAMESPACE) --debug
	@echo "$(YELLOW)Cluster $(KIND_CLUSTER_NAME) is still running for debugging$(NC)"
	@echo "$(YELLOW)Run 'make test-e2e-cleanup' to clean up$(NC)"

# Utility commands
show-config: ## Show current test configuration
	@echo "$(BLUE)Test Configuration:$(NC)"
	@echo "  Chart Name: $(CHART_NAME)"
	@echo "  Namespace: $(NAMESPACE)"
	@echo "  Kind Cluster: $(KIND_CLUSTER_NAME)"
	@echo ""
	@echo "$(BLUE)Test Fixtures:$(NC)"
	@echo "  Vault ID: $(if $(OP_VAULT_ID),$(OP_VAULT_ID),Not Set)"
	@echo "  Item ID: $(if $(OP_ITEM_ID),$(OP_ITEM_ID),Not Set)"
	@echo "  Secret Value: $(if $(OP_SECRET_VALUE),Set,Not Set)"
	@echo ""
	@echo "$(BLUE)Credentials:$(NC)"
	@echo "  Connect Credentials: $(if $(OP_CONNECT_CREDENTIALS),Set,Not Set)"
	@echo "  Connect Token: $(if $(OP_CONNECT_TOKEN),Set,Not Set)"

install: ## Install required dependencies (auto-detect OS)
	@echo "$(BLUE)Detecting operating system...$(NC)"
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		echo "$(GREEN)Detected macOS$(NC)"; \
		$(MAKE) install-macos; \
	elif [ "$$(uname -s)" = "Linux" ]; then \
		echo "$(GREEN)Detected Linux$(NC)"; \
		$(MAKE) install-linux; \
	else \
		echo "$(RED)Unsupported operating system: $$(uname -s)$(NC)"; \
		echo "$(YELLOW)Please install dependencies manually or add support for your OS$(NC)"; \
		exit 1; \
	fi

install-macos: ## Install required dependencies (macOS)
	@echo "$(BLUE)Installing dependencies for macOS...$(NC)"
	@brew install helm kind yq chart-testing
	@echo "$(GREEN)macOS dependencies installed$(NC)"

install-linux: ## Install required dependencies (Linux)
	@echo "$(BLUE)Installing dependencies for Linux...$(NC)"
	@echo "$(YELLOW)Updating package lists...$(NC)"
	@sudo apt update
	@echo "$(YELLOW)Installing tools via apt...$(NC)"
	@sudo apt install -y helm kind yq chart-testing
	@echo "$(GREEN)Linux dependencies installed$(NC)"

install-windows: ## Install required dependencies (Windows)
	@echo "$(BLUE)Installing dependencies for Windows...$(NC)"
	@echo "$(YELLOW)Installing tools via Chocolatey...$(NC)"
	@choco install kubernetes-helm kind yq chart-testing -y --no-progress
	@echo "$(GREEN)Windows dependencies installed$(NC)"

check-deps: ## Check if required dependencies are installed
	@echo "$(BLUE)Checking dependencies...$(NC)"
	@command -v helm >/dev/null 2>&1 || { echo "$(RED)helm is required but not installed$(NC)"; exit 1; }
	@command -v kind >/dev/null 2>&1 || { echo "$(RED)kind is required but not installed$(NC)"; exit 1; }
	@command -v yq >/dev/null 2>&1 || { echo "$(RED)yq is required but not installed$(NC)"; exit 1; }
	@command -v ct >/dev/null 2>&1 || { echo "$(RED)ct (chart-testing) is required but not installed$(NC)"; exit 1; }
	@echo "$(GREEN)All dependencies are installed$(NC)"

help: ## Show this help message
	@echo "1Password Connect Helm Chart - Testing"
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo "$(BLUE)Installation Commands:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^install.*:.*?## / {printf "  $(BLUE)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BLUE)Testing Commands:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^test-e2e.*:.*?## / {printf "  $(BLUE)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BLUE)Utility Commands:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^(check-deps|show-config):.*?## / {printf "  $(BLUE)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
