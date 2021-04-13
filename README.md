# 1Password Connect Helm Charts

This repository hosts the offical 1Password Helm Charts for deploying 1Password Connect and the 1Password Connect Kubernetes Operator.

## Installation Guide

### Install Helm

Get the latest [Helm release](https://github.com/kubernetes/helm#install).

### Add Repository
The following command allows you to download and install all the charts from this repository:

```
$ helm repo add 1password https://raw.githubusercontent.com/1Password/connect-helm-charts/main
```

## Preparing a Release

1. Create tgz file with chart in current directory:
```bash
helm package connect
```

2. Create the index.yaml file which references the connect chart
```bash
helm repo index .
```

3. Push tgz and updated index.yaml file to Github repo.
