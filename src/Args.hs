module Args (Options(..), getCommandLineOptions) where

import Lib (application)
import System.Environment (getArgs)
import System.Exit (exitWith, ExitCode(..))
import System.Console.GetOpt

getCommandLineOptions :: IO Options
getCommandLineOptions = do
    args <- getArgs
    let (actions, _, _) = getOpt RequireOrder options args
    foldl (>>=) defaultOptions actions

data Options   = Options { optPort :: Int, optAllowOrigin :: String }
defaultOptions :: IO Options
defaultOptions = return $ Options 1337 "null"

options :: [OptDescr (Options -> IO Options)]
options = [
    Option ['h'] ["help"] (NoArg showHelp) "show this help message",
    Option ['p'] ["port"] (ReqArg makePort "PORT") "send events to port (default 1337)",
    Option ['a'] ["allow-origin"] (ReqArg makeAllowOrigin "ORIGIN") "value for the Access-Control-Allow-Origin header (default null)"
  ]

showHelp :: Options -> IO Options
showHelp _ = do
    putStrLn $ usageInfo header options
    exitWith ExitSuccess

makePort :: String -> Options -> IO Options
makePort s opt = return opt { optPort = (read s) }

makeAllowOrigin :: String -> Options -> IO Options
makeAllowOrigin s opt = return opt { optAllowOrigin = s }

header :: String
header = "Usage: eventsourced [OPTIONS...]"
