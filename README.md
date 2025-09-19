![gah! logo](./_static/logo.svg)


![GitHub top language](https://img.shields.io/github/languages/top/marverix/gah?color=d8d440&style=flat-square)
![GitHub file size in bytes](https://img.shields.io/github/size/marverix/gah/gah?color=db805a&style=flat-square)
[![GitHub Release](https://img.shields.io/github/v/release/marverix/gah?color=db5b92&style=flat-square)](https://github.com/marverix/gah/releases)
[![GitHub License](https://img.shields.io/github/license/marverix/gah?color=b95fda&style=flat-square)](https://github.com/marverix/gah/blob/master/LICENSE)
[![All Contributors](https://img.shields.io/github/all-contributors/marverix/gah?color=b1abea&style=flat-square)](#contributors)


`gah` is an GitHub Releases app installer, that **DOES NOT REQUIRE SUDO**! It is a simple bash script that downloads the latest release of an app from GitHub and installs it in `~/.local/bin`. It is designed to be used with apps that are distributed as a single binary file.

## Motivation

Nowadays more and more command-line tools and applications are distributed via GitHub Releases. The installation process looks always the same: you go to the release page, expand assets, find the right file for your platform (which may be very frustrating, especially when there are 200+ assets and very often developers use different naming conventions - e.g. `myapp-linux-amd64`, `myapp_linux_x64`, `myapp-unknown-linux-gnu-x86_64`, etc.), download it, unpack it, move it to `~/.local/bin`, execute `chmod +x` on it and don't forget to clean up afterwards. For me, it was a hassle. Each time I needed to go thru the process again I was doing "gah! not again!". So I thought, why not automate this process? In fact, I love automation and RegExp. And so `gah` was born.

## Features

- 🏷 Downloads the latest or given release of an app from GitHub
- 🎯 Automatically selects matching binary for the current platform

  - Supported OS: Linux and MacOS
  - Supported architectures: x64 and ARM64

- 🎳 Supports multiple matching apps in a single GitHub Release
- 📤 Supports archived (`.zip`, `.tar.gz`, `.tar.bz2`, `.tar.xz`) and single binary releases
- 🗃 Has own base of predefined aliases for GitHub repositories (PRs are welcome!)
- 🔐 Verifies downloaded files using provided by `openssl` against [asset's digest value](https://docs.github.com/en/rest/releases/assets?apiVersion=2022-11-28#get-a-release-asset)

## Installation

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/marverix/gah/refs/heads/master/tools/install.sh)"
```

## Usage

![gah demo](./_static/demo.gif)

Type `gah help` to see the list of available commands.

```text
gah
  install <github_owner/github_repo_name | known_alias> [--tag=<git_tag>] [--use-default-names]
  aliases <show | refresh>
  help
  version
```

### Using known aliases

`gah` has a predefined set of aliases for some popular apps. You can use these aliases to install the apps without specifying the full GitHub repository name.
To see the list of available aliases, type `gah aliases show`.

The file `db.json` with aliases is located in [db branch](https://github.com/marverix/gah/blob/db/db.json). Feel free to add your own aliases or suggest new ones by creating a pull request.

The file is cached locally for 24h.

### Specifying the tag

You can specify the tag of the release you want to install. If you don't specify a tag, the latest release will be installed.

```bash
gah install getsops/sops --tag=v3.10.2
```

### Unattended mode

`gah` will try to detect if your terminal supports input or not. To force this behavior you can either use the `--unattended` flag or set env var `UNATTENDED=true`.
This will skip the confirmation prompt and install the app without asking for any input.

```bash
gah install getsops/sops --unattended
```

or

```bash
export UNATTENDED=true
gah install getsops/sops
```

### Update gah

```sh
gah update
```

## Examples

### Install latest version of gh (GitHub CLI)

```bash
gah install gh
```

### Install specific version of argocd

```bash
gah install argocd --tag=v2.0.3
```

### Install an app that is not in the predefined aliases

```bash
gah install hashicorp/vagrant
```

## Configuration

Here is the list of supported environment variables:

Name | Description | Default
---|---|---
`GAH_INSTALL_DIR` | The directory where the gah will install your applications. This directory must be in your `PATH` environment variable. | `~/.local/bin`, for superuser it will be `/usr/local/bin`
`GAH_CACHE_DIR` | The directory where cache will be stored. | `~/.cache/gah`

## Using in GitHub Actions

There is an official GitHub Action to [setup gah](https://github.com/marverix/setup-gah).

## Contributors

Thanks to all contributors:

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/rverenich"><img src="https://avatars.githubusercontent.com/u/78074120?v=4?s=100" width="100px;" alt="Roman Verenich"/><br /><sub><b>Roman Verenich</b></sub></a><br /><a href="#data-rverenich" title="Data">🔣</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/LucasCzerny"><img src="https://avatars.githubusercontent.com/u/112941608?v=4?s=100" width="100px;" alt="Lucas"/><br /><sub><b>Lucas</b></sub></a><br /><a href="https://github.com/marverix/gah/commits?author=LucasCzerny" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

## License

gah is licensed under the Apache-2.0 License. See [LICENSE](./LICENSE) for the full license text.
