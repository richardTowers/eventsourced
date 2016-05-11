module Lib (application, serverEvent, createCorsHeaders) where

import System.IO.Error (tryIOError)
import Network.Wai (Middleware, Application)
import Network.Wai.EventSource (ServerEvent(..), eventSourceAppIO)
import Network.Wai.Middleware.AddHeaders (addHeaders)
import Blaze.ByteString.Builder.Char8 (fromString)
import Data.ByteString.Char8 (pack)
import Data.ByteString (ByteString)

serverEvent :: (Either IOError String) -> ServerEvent
serverEvent (Left _) = CloseEvent
serverEvent (Right s) = ServerEvent Nothing Nothing [ fromString s ]

eventFromLine :: IO ServerEvent
eventFromLine = do
    input <- tryIOError getLine
    return $ serverEvent input

createCorsHeaders :: String -> [(ByteString, ByteString)]
createCorsHeaders s = [(pack "Access-Control-Allow-Origin", pack s)]

addCorsHeaders :: String -> Middleware
addCorsHeaders s = addHeaders $ createCorsHeaders s

application :: String -> Application
application allowOrigin = addCorsHeaders allowOrigin $ eventSourceAppIO eventFromLine
