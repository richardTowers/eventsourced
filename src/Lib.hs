{-# LANGUAGE OverloadedStrings #-}

module Lib (application) where

import System.IO.Error (tryIOError)
import Network.Wai (Middleware, Application)
import Network.Wai.EventSource (ServerEvent(..), eventSourceAppIO)
import Network.Wai.Middleware.AddHeaders (addHeaders)
import Blaze.ByteString.Builder.Char8 (fromString)

serverEvent :: (Either IOError String) -> ServerEvent
serverEvent (Left e) = CloseEvent
serverEvent (Right s) = ServerEvent Nothing Nothing [ fromString s ]

eventFromLine :: IO ServerEvent
eventFromLine = do
    input <- tryIOError getLine
    return $ serverEvent input

addCorsHeaders :: Middleware
addCorsHeaders = addHeaders [("Access-Control-Allow-Origin", "*")]

application :: Application
application = addCorsHeaders $ eventSourceAppIO eventFromLine

