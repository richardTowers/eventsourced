module Args (
    Options(..),
    getCommandLineOptions,
    defaultOptions,
    mergeOptions,
    makePort,
    makeAllowOrigin
  ) where

import System.Console.GetOpt

type OptionsTransformer = (Options -> Options)

getCommandLineOptions :: [String] -> Options
getCommandLineOptions args = do
    let (transformers, _, _) = getOpt RequireOrder options args
    mergeOptions transformers

mergeOptions :: [(OptionsTransformer)] -> Options
mergeOptions = foldl (flip ($)) defaultOptions

data Options = Options {
    optPort :: Int,
    optAllowOrigin :: String,
    optHelp :: (Maybe String)
} deriving (Eq, Show)
defaultOptions :: Options
defaultOptions = Options 1337 "null" Nothing

options :: [OptDescr (OptionsTransformer)]
options = [
    Option ['h'] ["help"] (NoArg showHelp) "show this help message",
    Option ['p'] ["port"] (ReqArg makePort "PORT") "send events to port (default 1337)",
    Option ['a'] ["allow-origin"] (ReqArg makeAllowOrigin "ORIGIN") "value for the Access-Control-Allow-Origin header (default null)"
  ]

showHelp :: Options -> Options
showHelp opt = opt { optHelp = Just (usageInfo header options) }

makePort :: String -> OptionsTransformer
makePort s opt = opt { optPort = (read s) }

makeAllowOrigin :: String -> OptionsTransformer
makeAllowOrigin s opt = opt { optAllowOrigin = s }

header :: String
header = "Usage: eventsourced [OPTIONS...]"
