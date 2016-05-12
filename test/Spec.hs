{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

import Test.HUnit
import System.IO.Error
import Control.Monad
import Network.Wai.EventSource (ServerEvent(..))
import Blaze.ByteString.Builder.Char8 (fromString)
import Blaze.ByteString.Builder (toByteString)
import Data.ByteString.Char8 (unpack)
import Data.ByteString.Builder (Builder)

import Lib (serverEvent, createCorsHeaders)
import Args (Options(..), getCommandLineOptions, defaultOptions)

-- ServerEvent and Builder don't derive Eq or Show, which makes them hard to test.
-- We can tell Haskell how to compare / show them by creating type instances:
deriving instance Show ServerEvent
instance Show (Builder) where show = unpack . toByteString
deriving instance Eq ServerEvent
instance Eq Builder where
    (==) x y = (show x) == (show y)
    (/=) x y = (show x) /= (show y)

testServerEvent :: Test
testServerEvent = do
    let expected = ServerEvent Nothing Nothing [ fromString "Hello World!" ]
    let actual = serverEvent $ Right "Hello World!"
    TestCase $ assertEqual "for severEvent (Right \"Hello World!\")" actual expected

testServerEventClosesWhenEndOfFileReached :: Test
testServerEventClosesWhenEndOfFileReached = do
    let endOfFileError = Left $ mkIOError eofErrorType "" Nothing Nothing
    TestCase $ assertEqual "for serverEvent (Left IOError)" (serverEvent endOfFileError) CloseEvent

testCreateCorsHeaders :: Test
testCreateCorsHeaders = do
    TestCase $ assertEqual "for createCorsHeaders BANANA" (createCorsHeaders "BANANA") [("Access-Control-Allow-Origin", "BANANA")]

testGetCommandLineOptions :: Test
testGetCommandLineOptions = do
    TestCase $ do
        assertEqual "getCommandLineOptions []" (getCommandLineOptions []) defaultOptions
        assertEqual "getCommandLineOptions [--port=12345]" (getCommandLineOptions ["--port=12345"]) (defaultOptions { optPort = 12345 })
        assertEqual "getCommandLineOptions [--allow-origin=*]" (getCommandLineOptions ["--allow-origin=*"]) (defaultOptions { optAllowOrigin = "*" })
        assertEqual "getCommandLineOptions [--port=12345 --allow-origin=*]" (getCommandLineOptions ["--port=12345", "--allow-origin=*"]) (defaultOptions {  optPort = 12345, optAllowOrigin = "*" })

main :: IO ()
main = void $ runTestTT $ test [
    testServerEvent,
    testServerEventClosesWhenEndOfFileReached,
    testCreateCorsHeaders,
    testGetCommandLineOptions
  ]
