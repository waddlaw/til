{-@
data BST a = Leaf
           | Node { root  :: a
                  , left  :: BSTL a root
                  , right :: BSTR a root
                  }
@-}
data BST a = Leaf
           | Node { root  :: a
                  , left  :: BST a
                  , right :: BST a
                  }
  deriving (Eq, Show)

{-@ type BSTL a X = BST { v:a | v < X } @-}
{-@ type BSTR a X = BST { v:a | X < v } @-}

badBST :: BST Int
badBST = Node 1 (Node 1 Leaf Leaf)
                (Node 1 Leaf Leaf)