# Contributing

Hello and thank you for your interest in contributing to the 1Password `connect-helm-chart` project 👋! We sincerely appreciate the time and effort you put into improving our Helm Charts. Before you start, please take a moment to read through this guide to understand our contribution process.

## Getting Started

To start contributing, you'll need to fork this repository and clone it locally. Next,

1. Get the latest [Helm release](https://github.com/helm/helm#install).
2. Add the 1password repository to be able to download and install all the charts from this repository:
   ```
   helm repo add 1password https://1password.github.io/connect-helm-charts
   ```
3. For the Connect and Kubernetes Operator, follow: [connect readme](./charts/connect/README.md)
4. For the Secrets Injector, follow: [secrets-injector readme](./charts/secrets-injector/README.md)

## Testing

NOTE: This only applies to changes made in `./charts/connect`.

Run the following command to test changes made to the Connect Helm chart:

```
helm test connect
```

## Debugging

- Running `helm lint` in the applicable subdirectory will verify that your chart follows best practices.

- To run `helm template --debug`:

1. navigate to the root of the repository
2. `cd..`
3. `helm template connect-helm-charts/charts/secrets-injector --debug` for **secrets-injector** OR `helm template connect-helm-charts/charts/connect --debug` for **connect**.

For more debugging templates, feel free to consult the [docs](https://helm.sh/docs/chart_template_guide/debugging/).

## Sign your commits

To get your PR merged, we require you to sign your commits.

### Sign commits with 1Password

You can also sign commits using 1Password, which lets you sign commits with biometrics without the signing key leaving the local 1Password process.

Learn how to use [1Password to sign your commits](https://developer.1password.com/docs/ssh/git-commit-signing/).

### Sign commits with ssh-agent

Follow the steps below to set up commit signing with `ssh-agent`:

1. [Generate an SSH key and add it to ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
2. [Add the SSH key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
3. [Configure git to use your SSH key for commits signing](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-ssh-key)

### Sign commits with gpg

Follow the steps below to set up commit signing with `gpg`:

1. [Generate a GPG key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
2. [Add the GPG key to your GitHub account](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account)
3. [Configure git to use your GPG key for commits signing](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-gpg-key)
