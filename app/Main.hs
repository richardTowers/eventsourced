module Main where

import Network.Wai.Handler.Warp (run)
import Lib (application)
import System.Environment (getArgs)
import System.Console.GetOpt

main :: IO ()
main = do
    args <- getArgs
    let (actions, nonOpts, msgs) = getOpt RequireOrder options args
    opts <- foldl (>>=) (return defaultOptions) actions
    let Options { optPort = port, optAllowOrigin = allowOrigin } = opts
    run port $ application allowOrigin

data Options = Options {
    optPort :: Int,
    optAllowOrigin :: String
}

defaultOptions = Options {
    optPort = 1337,
    optAllowOrigin = "null"
}

options :: [OptDescr (Options -> IO Options)]
options = [
    Option ['p'] ["port"] (ReqArg makePort "PORT") "send events to port",
    Option ['a'] ["allow-origin"] (ReqArg makeAllowOrigin "ORIGIN") "value for the Access-Control-Allow-Origin header"
  ]

makePort :: String -> Options -> IO Options
makePort s opt = return opt { optPort = (read s) }

makeAllowOrigin :: String -> Options -> IO Options
makeAllowOrigin s opt = return opt { optAllowOrigin = s }


