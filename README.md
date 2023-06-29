<div style="text-align: center;">
  <!-- Image sourced from https://blog.1password.com/introducing-secrets-automation/ -->
  <img src="assets/connect-illustration.svg" alt="Connect illustration">
  <p>
    <h1 style="border-bottom:0;margin-bottom:0;">1Password Helm Charts</h1>
    This repository hosts the official 1Password Helm Charts.
  </p>

  <br>

  <p>
    <a href="#quickstart">
      <img alt="Get Started/Quick start" src="https://user-images.githubusercontent.com/45081667/226940040-16d3684b-60f4-4d95-adb2-5757a8f1bc15.png" height="37" />
    </a>
  </p>

  <hr>
</div>

## ✨ Quickstart

1. Get the latest [Helm release](https://github.com/kubernetes/helm#install).
2. Add the 1password repository to be able to download and install all the charts from this repository:
   ```
   helm repo add 1password https://1password.github.io/connect-helm-charts
   ```

## 📦 Available Charts

- [1Password Connect and Kubernetes Operator](./charts/connect)
- [1Password Secrets Injector](./charts/secrets-injector)

## 💙 Community & Support

- File an [issue](correct_link) for bugs and feature requests.
- Join the [Developer Slack workspace](https://join.slack.com/t/1password-devs/shared_invite/zt-1halo11ps-6o9pEv96xZ3LtX_VE0fJQA).
- Subscribe to the [Developer Newsletter](https://1password.com/dev-subscribe/).

## 🔐 Security

1Password requests you practice responsible disclosure if you discover a vulnerability.

Please file requests via [**BugCrowd**](https://bugcrowd.com/agilebits).

For information about security practices, please visit our [Security homepage](https://bugcrowd.com/agilebits).
