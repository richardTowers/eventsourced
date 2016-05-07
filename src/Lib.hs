module Lib ( createWaiApp) where

import Network.Wai
import Network.Wai.EventSource
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Lazy.Char8 as C
import Blaze.ByteString.Builder.ByteString

toEvent :: [L.ByteString] -> ServerEvent
toEvent s = ServerEvent {
    eventName = Nothing,
    eventId = Nothing,
    eventData = map fromLazyByteString s
}

createWaiApp :: IO L.ByteString -> Application
createWaiApp input = eventSourceAppIO $ fmap toEvent $ fmap C.lines input

