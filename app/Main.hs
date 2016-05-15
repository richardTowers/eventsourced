module Main where

import Control.Concurrent (forkIO, newEmptyMVar, takeMVar)
import Network.Eventsourced.Lib (application)
import Network.Eventsourced.Args (Options(..), getCommandLineOptions)

import System.Environment (getArgs)
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = do
    args <- getArgs
    shutdownMVar <- newEmptyMVar
    let opts = getCommandLineOptions args
    case opts of
        Options _    _          (Just help)  -> putStrLn help
        Options port allowOrigin Nothing     -> do
            putStrLn $ "Streaming standard input to port " ++ (show port)
            putStrLn $ "Allowed orgins: " ++ allowOrigin
            let app = application shutdownMVar allowOrigin
            _ <- forkIO $ run port app
            takeMVar shutdownMVar
