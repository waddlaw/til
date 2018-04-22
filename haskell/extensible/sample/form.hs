#!/usr/bin/env stack
{- stack script
   --resolver nightly-2018-04-21
   --package extensible
   --package blaze-html
   --package text
   --package optional-args
   --package bytestring
   -- keys.hs
-}

{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Extensible
import Data.Text (Text)
import Text.Blaze.Html.Renderer.Pretty (renderHtml)
import qualified Text.Blaze.Html as B
import qualified Text.Blaze.Html5 as B
import qualified Data.ByteString as B
import Data.Monoid
import qualified Data.Text.Encoding as T
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as H
import Data.Optional
import GHC.TypeLits

type TestFields =
  [ "firstName" >: Text
  , "lastName" >: Text
  , "gender" >: Text
  ]

testForm :: Form TestFields
testForm = #firstName @= text "First Name"
  <: #lastName @= text "Last Name"
  <: #gender @= select ["Male", "Female", "Other"]
  <: nil

main = putStrLn $ renderHtml $ simpleHtml testForm

{-
$ ./form.hs
<input type="text" placeholder="First Name">
<input type="text" placeholder="Last Name">
<select>
    <option>
        Male
    </option>
    <option>
        Female
    </option>
    <option>
        Other
    </option>
</select>

-}

--

type Form = RecordOf Input

text :: Text
  -> Input Text
text ph = Input
  { inputToHtml = H.input
    H.! H.type_ "text"
    H.! H.placeholder (H.textValue ph)
  , parseValue = pure . T.decodeUtf8
  }

select :: [Text] -> Input Text
select xs = Input
  { inputToHtml = H.select $ mapM_ (H.option . H.text) xs
  , parseValue = pure . T.decodeUtf8
  }

data Input a = Input
  { inputToHtml :: H.Html
  , parseValue :: B.ByteString -> Either String a
  }

instance Wrapper Input where
  type Repr Input a = Input a
  _Wrapper = id

simpleHtml :: Forall (KeyIs KnownSymbol) xs => Form xs -> H.Html
simpleHtml = hfoldMap (inputToHtml . getField)
