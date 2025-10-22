# Local Testing Guide

This guide explains how to run the same end-to-end tests locally that run in GitHub Actions.

## Prerequisites

### Required Tools
- **Helm** (v3.4.1+)
- **Kind** (Kubernetes in Docker)
- **yq** (YAML processor)
- **ct** (chart-testing CLI)

## Quick Start

### 1. Install Dependencies
```bash
# Auto-detect OS and install dependencies
make install
```

### 2. Set Up Test Environment

#### Set Environment Variables
```bash
# Set credentials as environment variables
export OP_CONNECT_CREDENTIALS=$(cat ./1password-credentials.json) # your 1password-credentials.json file content
export OP_CONNECT_TOKEN="your-connect-token"
export OP_SERVICE_ACCOUNT_TOKEN="your-service-account-token"

# Set required test fixture values
export OP_VAULT_ID="your-vault-id"
export OP_ITEM_ID="your-item-id"
export OP_SECRET_VALUE="your-expected-secret-value"
```

### 3. Run Tests
```bash
# Run the complete test suite
make test-e2e
```

## Available Commands

### Installation Commands
- `make install` - Auto-detect OS and install dependencies
- `make install-macos` - Install dependencies for macOS (Homebrew)
- `make install-linux` - Install dependencies for Linux
- `make install-windows` - Install dependencies for Windows (WSL/Git Bash)

### Main Test Commands
- `make test-e2e` - Run complete end-to-end tests (setup → test → cleanup)

### Utility Commands
- `make check-deps` - Check if all dependencies are installed
- `make show-config` - Show current test configuration
- `make test-e2e-cleanup` - Clean up test environment

## Adding New Test Scenarios
To add a new test scenario:
1. Create a new YAML file in `ci/` directory
2. Configure the desired chart values
3. The workflow will automatically run tests for this configuration

## Debugging

### Keep Cluster for Debugging
```bash
make test-e2e
# Cluster stays running for inspection
kubectl get pods -n onepassword-connect-test
kubectl logs -n onepassword-connect-test <pod-name>
make test-e2e-cleanup  # Clean up when done
```

### Check Test Logs
```bash
# After running tests, check pod logs
kubectl get pods -n onepassword-connect-test
kubectl logs -n onepassword-connect-test <test-pod-name>
```

### Manual Chart Installation
```bash
# Install chart manually for testing
helm install connect . --namespace onepassword-connect-test \
  --set connect.credentials="$(echo $OP_CONNECT_CREDENTIALS | base64 -d)" \
  --set operator.token.value="$OP_CONNECT_TOKEN"
```

## Troubleshooting

### Common Issues

1. **Missing Environment Variables**
   ```bash
   # Check which variables are missing
   make show-config
   
   # Set all required variables
   export OP_CONNECT_CREDENTIALS="your-credentials"
   export OP_CONNECT_TOKEN="your-token"
   export OP_VAULT_ID="your-vault-id"
   export OP_ITEM_ID="your-item-id"
   export OP_SECRET_VALUE="your-secret-value"
   ```

2. **Kind Cluster Issues**
   ```bash
   # Check cluster status
   kind get clusters
   
   # Delete and recreate
   kind delete cluster --name onepassword-connect-test
   make test-e2e-setup
   ```

3. **Test Failures**
   ```bash
   # Run test
   make test-e2e
   
   # Check pod logs
   kubectl logs -n onepassword-connect-test <failing-pod>
   ```

## Security Notes

- Environment variables contain sensitive credentials
- Never commit credentials to git
- Use `1password-cli` for secure credential management when possible
