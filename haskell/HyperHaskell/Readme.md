# HyperHaskell

- [HeinrichApfelmus/hyper-haskell](https://github.com/HeinrichApfelmus/hyper-haskell)

## Install (Ubuntu 16.04 LTS)

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
$ sudo apt install -y libgtk2.0-0 libxss-dev libgconf2-dev libnss3-dev libasound2-dev

# electron のインストール
$ npm install electron --save-dev --save-exact
```

Quickstart

```bash
$ git clone https://github.com/electron/electron-quick-start
$ cd electron-quick-start
$ npm install
$ npm start
```

###

```bash
$ curl -sSL https://get.haskellstack.org/ | sh
```
