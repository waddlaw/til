# ロケールのエラー

```bash
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
	LANGUAGE = (unset),
	LC_ALL = (unset),
	LC_CTYPE = "UTF-8",
	LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to a fallback locale ("en_US.UTF-8").
locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_ALL to default locale: No such file or directory
```

## 解決方法

```bash
$ export LANG=en_US.UTF-8
$ export LC_ALL=$LANG
$ sudo locale-gen --purge $LANG
$ sudo dpkg-reconfigure -f noninteractive locales && /usr/sbin/update-locale LANG=$LANG LC_ALL=$LANG
```

- [debian でロケールのエラーが出るときの対処法](https://qiita.com/d6rkaiz/items/c32f2b4772e25b1ba3ba)
