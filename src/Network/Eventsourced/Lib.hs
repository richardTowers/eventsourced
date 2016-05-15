module Network.Eventsourced.Lib (application, serverEvent, createCorsHeaders) where

import Control.Concurrent (MVar, putMVar)
import System.IO.Error (tryIOError)
import Network.Wai (Middleware, Application)
import Network.Wai.EventSource (ServerEvent(..), eventSourceAppIO)
import Network.Wai.Middleware.AddHeaders (addHeaders)
import Blaze.ByteString.Builder.Char8 (fromString)
import Data.ByteString.Char8 (pack)
import Data.ByteString (ByteString)

serverEvent :: Either IOError String -> ServerEvent
serverEvent (Left _) = CloseEvent
serverEvent (Right s) = ServerEvent Nothing Nothing [ fromString s ]

eventFromLine :: MVar () -> IO ServerEvent
eventFromLine shutdownMVar = do
    input <- tryIOError getLine
    let event = serverEvent input
    case event of
        CloseEvent -> do
            putMVar shutdownMVar ()
            return event
        _ -> return event

createCorsHeaders :: String -> [(ByteString, ByteString)]
createCorsHeaders s = [(pack "Access-Control-Allow-Origin", pack s)]

addCorsHeaders :: String -> Middleware
addCorsHeaders s = addHeaders $ createCorsHeaders s

application :: MVar () -> String -> Application
application shutdown allowOrigin = do
    let app = eventSourceAppIO $ eventFromLine shutdown
    addCorsHeaders allowOrigin app
