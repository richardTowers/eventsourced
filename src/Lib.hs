{-# LANGUAGE OverloadedStrings #-}

module Lib (createWaiApp) where

import System.IO.Error (tryIOError)
import Network.Wai
import Network.Wai.EventSource
import Network.Wai.Middleware.AddHeaders
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Lazy.Char8 as C
import Blaze.ByteString.Builder.ByteString
import Blaze.ByteString.Builder.Char8 (fromString)

nextEvent :: IO ServerEvent
nextEvent = do
    input <- tryIOError getLine
    case input of
        Left e -> return CloseEvent
        Right s -> return $ ServerEvent Nothing Nothing [ fromString s ]

addCorsHeaders :: Middleware
addCorsHeaders = addHeaders [("Access-Control-Allow-Origin", "*")]

createWaiApp :: Application
createWaiApp = addCorsHeaders $ eventSourceAppIO nextEvent

