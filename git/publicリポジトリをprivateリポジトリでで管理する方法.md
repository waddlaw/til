# public リポジトリを private リポジトリにして管理する方法

- [GitHub: How to make a fork of public repository private?](https://stackoverflow.com/questions/10065526/github-how-to-make-a-fork-of-public-repository-private)

## 初回作業

- github でプライベートリポジトリを作っておく

```bash
$ git clone --bare https://github.com/exampleuser/public-repo.git
$ cd public-repo.git
$ git push --mirror https://github.com/yourname/private-repo.git
$ cd ..
$ rm -rf public-repo.git
```

## git clone と git push

```bash
$ git clone https://github.com/yourname/private-repo.git
$ cd private-repo
$ make some changes
$ git commit
$ git push origin master
```

## git pull

```bash
$ cd private-repo
$ git remote add public https://github.com/exampleuser/public-repo.git
$ git pull public master # Creates a merge commit
$ git push origin master
```
