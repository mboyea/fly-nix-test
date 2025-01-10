---
title: Fly Nix Test
author: [ Matthew T. C. Boyea ]
lang: en
subject: server
keywords: [ nix, docker, server, fly, fly.io, issue, test ]
default_: report
---
## A repository to test an issue with deploying to Fly

See https://community.fly.io/t/docker-image-works-locally-but-not-on-fly-io-getting-command-not-found/23387/12 for details.

### Get Started

#### Install

First, copy the repository.

- [Clone this repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) from GitHub to your computer.

Because Nix manages all packages, it is the only dependency required to be installed manually.

- [Install Nix](https://nixos.org/download/).
- [Enable Flakes](https://nixos.wiki/wiki/Flakes).

#### Scripts

Scripts can be run from within the project directories using any shell with Nix installed and Flakes enabled. See [#### Install](#install).

| Command | Description |
|:--- |:--- |
| `nix run` | Alias for `.#help` |
| `nix run .#help` | Print this helpful information |
| `nix run .#start` | Alias for `.#start native` |
| `nix run .#start native` | Start the server natively on your machine |
| `nix run .#start container` | Start the server in a container on your machine |
| `nix run .#deploy` | Deploy the server to Fly.io |
| `nix develop` | Start a dev shell with all project dependencies installed |

#### Deploy

- [Make a Fly.io account](https://fly.io/dashboard). Link your payment method in the account.
- Run `nix develop` to open a shell with access to development tools (like `flyctl`).
- Run `flyctl auth login`
- Run `touch .env` to make file named `.env`
- Determine your `<unique_app_name>`.
- Set line `app = '<unique_app_name>'` in `fly.toml`.
- Set line `FLY_APP_NAME="<unique_app_name>"` in `.env`.
- Run `flyctl launch --no-deploy --name <unique_app_name>`
- Run `flyctl tokens create deploy` to generate your `<fly_api_token>`.
- Set line `FLY_API_TOKEN="<fly_api_token>"` in `.env`.
- Run `nix run .#deploy`
