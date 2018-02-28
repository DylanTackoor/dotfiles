# dotfiles

What good is a dev setup if you can't replicate it? Don't you only really know something if you can explain the topic in simple terms?

Goals:

- Automatic: minimal number of clicks required
- Reusable: Can be be run multiple times to reset system without breaking things
- Clarity: Documented meticulously to:
    1. Keep things clear for myself
    2. Keep things clear for you to learn from

## Operating Systems

### Mac

#### Installation

Safe way:

```sh
$ git clone https://github.com/dylantackoor/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ chmod +x mac.sh
$ ./mac.sh
```

Alternatively, you can install this into `~/dotfiles` remotely without Git using curl:

```sh
sh -c "`curl -fsSL https://raw.github.com/dylantackoor/dotfiles/master/mac.sh`"
```

Or, using wget:

```sh
sh -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/dylantackoor/dotfiles/master/mac.sh`"
```

### elementaryOS

//TODO:

### Windows 10

//TODO:

## Software

Symlinks are created for tracking the following config files:

- Visual Studio Code
- Spacemacs
- Git
- Zsh
- eslint

## Sources

- [Getting Started With Dotfiles](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789)
- https://github.com/mathiasbynens/dotfiles/blob/master/.macos
- https://github.com/nicksp/dotfiles/blob/master/osx/set-defaults.sh
