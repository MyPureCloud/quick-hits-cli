# Welcome to the quicks-hits-cli repository

## Introduction

The quick hit cli repository holds various recipes and examples for using the Genesys Cloud CLI. Most of the examples are not full working scripts, but instead guides to how to undertake using the Genesys Cloud CLI. We welcome pull requests for new examples. We are not just looking for *nix-based Genesys Cloud CLI examples, but also Windows PowerShell examples. Many of the CLI examples in this repository are combined with other tools like [jq](https://stedolan.github.io/jq/) and Unix commands (e.g. xargs).

## A Note on PowerShell Samples

For maximum compatibility, most of the PowerShell scripts are written and tested for PowerShell v5.1. Some samples may use other versions, which would be stated in the script description itself.

The PS samples also assumes a Windows environment and cli commands are written with the full filename `gc.exe`. If you're using cross-platform versions of PowerShell, you need to replace this with the correct filename (eg. `gc`), but  you'd also have to resolve the alias conflict with the cmdlet Get-Content.
