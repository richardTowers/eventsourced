module Main where

import Network.Wai.Handler.Warp (run)
import Lib (application)

main :: IO ()
main = run 1337 $ application

