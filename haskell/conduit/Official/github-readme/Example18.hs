#!/usr/bin/env stack
-- stack script --resolver lts-10.9
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings #-}
import Conduit
import Data.Text (Text)

message :: Text
message = "This is my message. Try to decode it with the base64 command.\n"

main :: IO ()
main = runConduit $ yield message .| encodeUtf8C .| encodeBase64C .| stdoutC

{-
$ ./Example18.hs
VGhpcyBpcyBteSBtZXNzYWdlLiBUcnkgdG8gZGVjb2RlIGl0IHdpdGggdGhlIGJhc2U2NCBjb21tYW5kLgo=
-}
