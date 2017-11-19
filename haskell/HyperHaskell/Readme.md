# HyperHaskell

- [HeinrichApfelmus/hyper-haskell](https://github.com/HeinrichApfelmus/hyper-haskell)

## Install (Ubuntu 17.10)

```bash
$ sudo apt update
$ sudo apt upgrade -y
```

### node & npm

- [Installing Node.js and updating npm](https://docs.npmjs.com/getting-started/installing-node)
- [nodesource/distributions](https://github.com/nodesource/distributions#debinstall)

```bash
# version 9 はサポートされていないので 8 にした
$ curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
$ sudo apt-get install -y nodejs
$ node -v
v8.9.1

# update npm
$ sudo npm install npm@latest -g
$ sudo chown -R $USER:$(id -gn $USER) /home/bm12/.config
$ npm -v
5.5.1
```

### Electron

- [electron/electron](https://github.com/electron/electron#installation)

```bash
$ sudo apt install -y libgtk2.0-0 libxss-dev libgconf2-dev libnss3-dev libasound2-dev libx11-xcb-dev libxtst6

# electron のインストール
$ sudo npm install electron@1.4.13 -g --unsafe-perm=true --allow-root
$ electron -v
v1.4.13
```

### stack

```bash
$ stack --version
Version 1.6.0, Git revision 10559c85d45e53dc4957aae1dda2a911cf7a961b (5337 commits) x86_64 hpack-0.18.1
```

### hyper-haskell

`Makefile` の `ELECTRON` の行を `$ which electron` で表示されたパスで書き換える。 

```Makefile
ELECTRON=/usr/bin/electron
```

```bash
$ git clone https://github.com/HeinrichApfelmus/hyper-haskell.git
$ cd hyper-haskell
$ make run
```
