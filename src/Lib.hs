module Lib ( createWaiApp) where

import Network.Wai
import Network.Wai.EventSource

toEvent :: String -> ServerEvent
toEvent s = CloseEvent

createWaiApp :: IO String -> Application
createWaiApp input = eventSourceAppIO $ fmap toEvent input
