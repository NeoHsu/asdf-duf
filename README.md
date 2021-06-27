<div align="center">

# asdf-duf ![Build](https://github.com/NeoHsu/asdf-duf/workflows/Build/badge.svg) ![Lint](https://github.com/NeoHsu/asdf-duf/workflows/Lint/badge.svg)

[duf](https://github.com/muesli/duf) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, `unzip(windows)` : generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add duf
# or
asdf plugin add duf https://github.com/NeoHsu/asdf-duf.git
```

duf:

```shell
# Show all installable versions
asdf list-all duf

# Install specific version
asdf install duf latest

# Set a version globally (on your ~/.tool-versions file)
asdf global duf latest

# Now duf commands are available
duf -version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/NeoHsu/asdf-duf/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Neo Hsu](https://github.com/NeoHsu/)
