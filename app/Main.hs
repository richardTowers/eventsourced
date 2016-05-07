module Main where

import Network.Wai.Handler.Warp (run)
import Lib (createWaiApp)

main :: IO ()
main = do
    run 1337 $ createWaiApp getContents

