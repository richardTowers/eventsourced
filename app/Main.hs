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
    case getCommandLineOptions args of
        Options _ _ (Just help)              -> putStrLn help
        Options port allowOrigin Nothing     -> do
            putStrLn $ "Streaming standard input to port " ++ show port
            putStrLn $ "Allowed origin: " ++ allowOrigin
            _ <- forkIO $ run port $ application shutdownMVar allowOrigin
            takeMVar shutdownMVar
