![gah! logo](./_static/logo.svg)

`gah` is an GitHub Releases app installer, that **DOES NOT REQUIRE SUDO**! It is a simple bash script that downloads the latest release of an app from GitHub and installs it in `~/.local/bin`. It is designed to be used with apps that are distributed as a single binary file.

Features:

- Downloads the latest or given release of an app from GitHub
- Automatically selects matching binary for the current platform

  - Supported OS: Linux and MacOS
  - Supported architectures: x64 and ARM64

- Supports multiple matching apps in a single GitHub Release
- Supports archived (`.zip`, `.tar.gz`, `.tar.bz2`, `.tar.xz`) and single binary releases
- Has own base of predefined aliases for GitHub repositories (PRs are welcome!)

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
gah install argocd v2.0.3
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

## License

gah is licensed under the GPL-3.0 License. See [LICENSE](./LICENSE) for the full license text.
