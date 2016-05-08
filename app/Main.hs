module Main where

import Network.Wai.Handler.Warp (run)
import Lib (application)
import System.Environment (getArgs)
import System.Exit (exitWith, ExitCode(..))
import System.Console.GetOpt

main :: IO ()
main = do
    args <- getArgs
    let (actions, nonOpts, msgs) = getOpt RequireOrder options args
    opts <- foldl (>>=) (return defaultOptions) actions
    let Options { optPort = port, optAllowOrigin = allowOrigin } = opts
    putStrLn $ "Streaming standard input to port " ++ (show port)
    putStrLn $ "Allowed orgins: " ++ allowOrigin
    run port $ application allowOrigin

data Options   = Options { optPort :: Int, optAllowOrigin :: String }
defaultOptions = Options 1337 "null"

options :: [OptDescr (Options -> IO Options)]
options = [
    Option ['h'] ["help"] (NoArg showHelp) "show this help message",
    Option ['p'] ["port"] (ReqArg makePort "PORT") "send events to port (default 1337)",
    Option ['a'] ["allow-origin"] (ReqArg makeAllowOrigin "ORIGIN") "value for the Access-Control-Allow-Origin header (default null)"
  ]

showHelp _ = do
    putStrLn $ usageInfo header options
    exitWith ExitSuccess

makePort :: String -> Options -> IO Options
makePort s opt = return opt { optPort = (read s) }

makeAllowOrigin :: String -> Options -> IO Options
makeAllowOrigin s opt = return opt { optAllowOrigin = s }

header = "Usage: eventsourced [OPTIONS...]"
