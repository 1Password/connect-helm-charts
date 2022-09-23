# 1Password Connect Helm Charts

This repository hosts the offical 1Password Helm Charts for deploying 1Password Connect and the 1Password Connect Kubernetes Operator.

## Installation Guide

### Install Helm

Get the latest [Helm release](https://github.com/kubernetes/helm#install).

### Add Repository
The following command allows you to download and install all the charts from this repository:

```
helm repo add 1password https://1password.github.io/connect-helm-charts
```

## Available Charts

* [1Password Connect and Kubernetes Operator](./charts/connect/)
