# My Archlinux Repo

Welcome to my custom Arch Linux repository! This repository is a collection of custom scripts, configuration files, and tools that I use to enhance my Arch Linux environment. Feel free to explore and use anything you find helpful.

## Table of Contents

- [Getting Started](#getting-started)
- [Repository Contents](#repository-contents)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Getting Started

To get started with using this repository, you'll need to clone it and then take a look at the different components and configurations available. Modify and adapt them as necessary to fit your personal environment.

```sh
git clone https://github.com/yourusername/archrepo.git
cd archrepo
```

## Repository Contents

- **dashboard**: Custom Conky configuration file named `dashboard`.
- **dashboard2**: Another variant of my custom Conky configuration named `dashboard2`.
- **zshrc**: My personalized `.zshrc` file for the Z shell.
- **zsh-functions**: A collection of custom Zsh functions.

## Installation

### Conky

If you haven't already installed Conky, you can do so using your package manager:

```sh
sudo pacman -S conky
```

Then, you can use my configuration files by copying them to your Conky configuration directory:

```sh
cp dashboard ~/.config/conky/dashboard
cp dashboard2 ~/.config/conky/dashboard2
```

### Zsh

Ensure you have Zsh installed:

```sh
sudo pacman -S zsh
```

Then, you can replace your existing `.zshrc` with my custom version:

```sh
cp zshrc ~/.zshrc
```

To use the custom functions, you can source them in your `.zshrc`:

```sh
# Inside your .zshrc
fpath+=(~/path-to-your-archrepo/zsh-functions)
```

## Usage

Once installed, you can start Conky with your custom configurations:

```sh
conky -c ~/.config/conky/dashboard &
conky -c ~/.config/conky/dashboard2 &
```

After updating your `.zshrc`, you can reload it with:

```sh
source ~/.zshrc
```

This will allow you to use Zsh with all your custom configurations and functions ready to go.

## Contributing

Feel free to fork this repository and make your own improvements. Any contribution to enhance the configurations is welcome. Submit a pull request with a detailed description of the changes you have made.
