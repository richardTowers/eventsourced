module Main where

import Lib (application)
import System.Environment (getArgs)
import Args (Options(..), getCommandLineOptions)
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = do
    args <- getArgs
    let opts = getCommandLineOptions args
    case opts of
        Options _    _          (Just help)  -> putStrLn help
        Options port allowOrigin Nothing     -> do
            putStrLn $ "Streaming standard input to port " ++ (show port)
            putStrLn $ "Allowed orgins: " ++ allowOrigin
            run port $ application allowOrigin
