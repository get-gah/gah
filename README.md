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
sh -c "$(curl -fsSL https://raw.githubusercontent.com/marverix/gah/refs/heads/master/tools/install.sh)"
```

## Usage

![gah demo](./_static/demo.gif)

Type `gah help` to see the list of available commands.

```text
gah
  install <github_owner/github_repo_name | known_alias> [<git_tag>]
  show <aliases>
  help
  version
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

## License

gah is licensed under the GPL-3.0 License. See [LICENSE](./LICENSE) for the full license text.
