main=mapM_ (print.sum)$take 100$iterate(\[a,b,c,d,e]->[d+e,d+a,b,e,c])[1,0,0,0,0]
