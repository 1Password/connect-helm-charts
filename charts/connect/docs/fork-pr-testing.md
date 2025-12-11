# Fork PR Testing Guide

This document explains how to test external pull requests using workflow dispatch.

## How to test external PR

* Do a sanity check on the submitted PR
* Copy the most recent commit hash of the PR branch
* Go to 'Actions' -> 'Run acceptance tests' -> 'Run workflow'
* Fill in the following:
  * `checkout-repo`: `<PR author>/connect-helm-charts`
  * `checkout-ref`: <copied commit hash>
* After pipeline finishes, drop a comment and in the PR to let the contributor know if there are any issues
