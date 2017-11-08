# lines of code

- 計測方法は `cloc $(git ls-files)` とする。
- `git ls-files` としているので実際はもっとある

## hpack

```bash
$ cloc $(git ls-files)
      37 text files.
      37 unique files.
       4 files ignored.

github.com/AlDanial/cloc v 1.70  T=0.02 s (1455.0 files/s, 238040.7 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Haskell                         26            696              6           4173
Markdown                         2             81              0            269
YAML                             4             15              5            114
Bourne Shell                     1              8              0             32
-------------------------------------------------------------------------------
SUM:                            33            800             11           4588
-------------------------------------------------------------------------------
```

## Hakyll

```bash
$ cloc $(git ls-files)
     144 text files.
     144 unique files.
      40 files ignored.

github.com/AlDanial/cloc v 1.70  T=0.05 s (2399.8 files/s, 216630.3 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Haskell                         73           1483           1891           5211
Markdown                        15            245              0            517
CSS                              3             35              1            256
HTML                            13             39              6            240
XML                              4              0              0             42
YAML                             2              9              6             30
make                             1              1              2              6
-------------------------------------------------------------------------------
SUM:                           111           1812           1906           6302
-------------------------------------------------------------------------------
```

## Shakespeare

```bash
$ cloc $(git ls-files)
      65 text files.
      64 unique files.
      28 files ignored.

github.com/AlDanial/cloc v 1.70  T=0.14 s (257.4 files/s, 54497.8 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Haskell                         32            855            834           5793
YAML                             2             30             48            131
Markdown                         2             54              0             84
CoffeeScript                     1              0              0              5
-------------------------------------------------------------------------------
SUM:                            37            939            882           6013
-------------------------------------------------------------------------------
```

## Persistent

- ほぼCじゃん！と思ったけどファイル数が2なので、そういうことね。

```bash
$ cloc $(git ls-files)
     147 text files.
     132 unique files.
      36 files ignored.

2 errors:
Unable to read:  docs/PersistValue
Unable to read:  instances.md

github.com/AlDanial/cloc v 1.70  T=1.27 s (88.0 files/s, 182886.3 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
C                                2          14146          64387         124405
Haskell                         86           2072           2183          13998
C/C++ Header                     1            299           8754           1447
Markdown                        17            363              0            546
YAML                             4             14              8             79
Bourne Shell                     2              5              0             21
-------------------------------------------------------------------------------
SUM:                           112          16899          75332         140496
-------------------------------------------------------------------------------
```

## Yesod

- ライブラリなので思っていた通り、そこまで多くなかったけど、結構強い

```bash
$ cloc $(git ls-files)
     282 text files.
     256 unique files.
      69 files ignored.

3 errors:
Unable to read:  "yesod-static/test/unicode/\327\247\327\250\327\250\327\250\327\250.html"
Unable to read:  "yesod-static/test/unicode/\327\251\327\234\327\225\327\235"
Unable to read:  "yesod-static/test/unicode/\327\251\327\251\327\251/DUMMY.txt"

github.com/AlDanial/cloc v 1.70  T=0.41 s (547.0 files/s, 67962.3 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Haskell                        183           2758           4247          19167
Markdown                        29            461              0            703
YAML                             5             33             54            154
HTML                             1              0              0             86
Bourne Shell                     2              5              0             20
CSS                              2              1              0             14
JavaScript                       1              0              0              3
-------------------------------------------------------------------------------
SUM:                           223           3258           4301          20147
-------------------------------------------------------------------------------
```

## Stack

- master ブランチ

```bash
$ cloc $(git ls-files)
tar: test2/devB: mknod 不能: 許可されていない操作です
tar: test2/devC: mknod 不能: 許可されていない操作です
tar: 前のエラーにより失敗ステータスで終了します
     505 text files.
     441 unique files.
     160 files ignored.

3 errors:
Unable to read:  "test/integration/tests/1337-unicode-everywhere/files/\327\220\327\250\327\245/\320\237\317\203\316\265.hs"
Unable to read:  "test/integration/tests/1337-unicode-everywhere/files/\343\201\204\343\202\215\343\201\257-LICENSE"
Unable to read:  "test/integration/tests/1337-unicode-everywhere/files/\344\273\245.cabal"

github.com/AlDanial/cloc v 1.70  T=1.03 s (338.8 files/s, 47807.9 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Haskell                        247           3276           4464          30553
Markdown                        29           1856              0           6619
YAML                            54             93            106            968
Bourne Shell                    13            130            183            799
JavaScript                       1              5              1             23
DOS Batch                        2              0              1             17
Lisp                             1              0              0             10
CSS                              1              0              0              3
-------------------------------------------------------------------------------
SUM:                           348           5360           4755          38992
-------------------------------------------------------------------------------
```

## Pandoc

- これで5万行
- リアルワールドで成功しているアプリケーションになると、このぐらいの行数はあるってことか

```bash
$ cloc $(git ls-files)
     706 text files.
     698 unique files.
     362 files ignored.

github.com/AlDanial/cloc v 1.70  T=0.29 s (1539.1 files/s, 270752.7 lines/s)
-------------------------------------------------------------------------------------
Language                           files          blank        comment           code
-------------------------------------------------------------------------------------
Haskell                              159           6008           6746          49188
Markdown                             168           1341              0           6319
HTML                                  10             82             30           1930
XML                                   16              2              0           1752
YAML                                  53             58            244           1179
Lua                                   13            140            377            807
WiX source                             3             68             52            300
JavaScript                             1              0              8            190
Bourne Shell                           4             35             10            117
CSS                                    2              5              3             92
make                                   4             28              2             88
Perl                                   1             17             10             52
Lisp                                   1             11             21             32
DOS Batch                              1              1              0             28
TeX                                    3              6              0             12
WiX string localization                1              5              1              8
-------------------------------------------------------------------------------------
SUM:                                 440           7807           7504          62094
-------------------------------------------------------------------------------------
```

## LiquidHaskell

- 予想以上にコード量があった

```bash
$ cloc $(git ls-files)
    3440 text files.
    2559 unique files.
    1229 files ignored.

github.com/AlDanial/cloc v 1.70  T=2.82 s (820.5 files/s, 143141.5 lines/s)
--------------------------------------------------------------------------------
Language                      files          blank        comment           code
--------------------------------------------------------------------------------
Haskell                        2086          64323         105100         162815
Bourne Shell                     10           4833          10274          10212
C                                19            598            455           8294
JavaScript                       36           2222           2756           6806
CSS                              37           1487           1030           6367
Markdown                         24           1706              0           3373
HTML                             18            480            105           2010
Coq                               5            188             37           1440
C/C++ Header                     15            410            339           1190
make                             14            275            132            739
TeX                               6            142             59            669
Python                           11            123             43            544
SASS                             12            157             81            474
Bourne Again Shell                4            107             14            392
m4                                3             59             11            359
Perl                              3             25             49             93
Ruby                              5             22              7             88
JSON                              2              0              0             66
YAML                              4             10             15             65
--------------------------------------------------------------------------------
SUM:                           2314          77167         120507         205996
--------------------------------------------------------------------------------
```

## GHC

- ghc-8.2 ブランチ
- `7963 files ignored.` って出てるので、少なくとも `639405` 行以上はある。

```bash
$ cloc $(git ls-files)
   18943 text files.
   17560 unique files.
Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/^(.*?){ <-- HERE [^$]/ at /usr/bin/cloc line 4727.
Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/^(.*?){ <-- HERE [^$].*$/ at /usr/bin/cloc line 4731.
    7963 files ignored.

2 errors:
Unable to read:  spaces
Unable to read:  mk/build.mk.sample

github.com/AlDanial/cloc v 1.70  T=40.03 s (276.7 files/s, 32441.5 lines/s)
---------------------------------------------------------------------------------------
Language                             files          blank        comment           code
---------------------------------------------------------------------------------------
Haskell                               9411         164840         222788         639405
C                                      302          11076          13829          57399
HTML                                   166            406             33          34892
Bourne Shell                            64           3131           3842          25581
C/C++ Header                           288           4776           6765          16296
make                                   578           3529           4713          13172
TeX                                     22           2230            475           9653
JavaScript                               9           2333           2291           9430
yacc                                     5           1265             10           6097
Markdown                                75           1978              0           4056
m4                                      16            600            225           4022
Fortran 77                               6            662           1049           3527
Bourne Again Shell                       9            454            607           3482
Python                                  18            920            810           2938
CSS                                     11            682            123           2728
Pascal                                   1            557            444           2228
YAML                                    35            189            251           1261
Objective C                             12            130              3            615
Perl                                     6            145             64            565
Assembly                                 7             54            113            538
Lisp                                     5              6              4            532
C++                                      6             66              2            288
Racket                                   1             16             34            197
MATLAB                                   2             56              0            193
XML                                      1             35              1            154
PHP                                      3             37            111            148
Clean                                    1             17              0             77
Windows Module Definition                4             19              0             64
D                                        2             16             39             59
Mathematica                              1              5              0             38
DOS Batch                                4              5              2             27
Objective C++                            1             11              3             21
Haxe                                     1              3              0             13
C Shell                                  1              0              0              3
Windows Resource File                    1              0              0              1
---------------------------------------------------------------------------------------
SUM:                                 11075         200249         258631         839700
---------------------------------------------------------------------------------------
```
