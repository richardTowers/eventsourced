module Main where

import Network.Wai.Handler.Warp (run)
import Lib (createWaiApp)
import qualified Data.ByteString.Lazy as L

main :: IO ()
main = do
    run 1337 $ createWaiApp

