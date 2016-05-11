module Main where

import Lib (application)
import Args (Options(..), getCommandLineOptions)
import Network.Wai.Handler.Warp (run)

main :: IO ()
main = do
    Options port allowOrigin <- getCommandLineOptions
    putStrLn $ "Streaming standard input to port " ++ (show port)
    putStrLn $ "Allowed orgins: " ++ allowOrigin
    run port $ application allowOrigin
