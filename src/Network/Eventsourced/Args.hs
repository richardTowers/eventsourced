module Network.Eventsourced.Args (Options(..), getCommandLineOptions, defaultOptions) where

import Data.Tuple.Select (sel1)
import System.Console.GetOpt

type OptionsTransformer = (Options -> Options)

data Options = Options {
    optPort :: Int,
    optAllowOrigin :: String,
    optHelp :: Maybe String
} deriving (Eq, Show)

defaultOptions :: Options
defaultOptions = Options 1337 "null" Nothing

getCommandLineOptions :: [String] -> Options
getCommandLineOptions args =
    foldl (flip ($)) defaultOptions $ sel1 $ getOpt RequireOrder options args

options :: [OptDescr OptionsTransformer]
options =
    [ Option ['h'] ["help"] (NoArg makeHelp) "show this help message"
    , Option ['p'] ["port"] (ReqArg makePort "PORT") "send events to port (default 1337)"
    , Option ['a'] ["allow-origin"] (ReqArg makeAllowOrigin "ORIGIN") "value for the Access-Control-Allow-Origin header (default null)"
    ]

makeHelp :: OptionsTransformer
makeHelp opt = opt { optHelp = Just (usageInfo  "Usage: eventsourced [OPTIONS...]" options) }

makePort :: String -> OptionsTransformer
makePort s opt = opt { optPort = read s }

makeAllowOrigin :: String -> OptionsTransformer
makeAllowOrigin s opt = opt { optAllowOrigin = s }
