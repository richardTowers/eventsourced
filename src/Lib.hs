{-# LANGUAGE OverloadedStrings #-}

module Lib ( createWaiApp) where

import Network.Wai
import Network.Wai.EventSource
import Network.Wai.Middleware.AddHeaders
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Lazy.Char8 as C
import Blaze.ByteString.Builder.ByteString

toEvent :: [L.ByteString] -> ServerEvent
toEvent s = ServerEvent {
    eventName = Nothing,
    eventId = Nothing,
    eventData = map fromLazyByteString s
}

addCorsHeaders :: Application -> Application
addCorsHeaders = addHeaders [("Access-Control-Allow-Origin", "*")]

createWaiApp :: IO L.ByteString -> Application
createWaiApp input = addCorsHeaders $ eventSourceAppIO $ fmap toEvent $ fmap C.lines input

