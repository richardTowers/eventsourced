{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE OverloadedStrings #-}

import Test.HUnit
import System.IO.Error
import Network.Wai.EventSource (ServerEvent(..))
import Blaze.ByteString.Builder.Char8 (fromString)
import Blaze.ByteString.Builder (toByteString)
import Data.ByteString.Char8 (pack, unpack)
import Data.ByteString.Builder (Builder)

import Lib (serverEvent, createCorsHeaders)
import Args (Options(..), makePort, defaultOptions)

-- ServerEvent and Builder don't derive Eq or Show, which makes them hard to test.
-- We can tell Haskell how to compare / show them by creating type instances:
deriving instance Show ServerEvent
instance Show (Builder) where show = unpack . toByteString
deriving instance Eq ServerEvent
instance Eq Builder where
    (==) x y = (show x) == (show y)
    (/=) x y = (show x) /= (show y)

testServerEvent = do
    let expected = ServerEvent Nothing Nothing [ fromString "Hello World!" ]
    let actual = serverEvent $ Right "Hello World!"
    TestCase $ assertEqual "for severEvent (Right \"Hello World!\")" actual expected

testServerEventClosesWhenEndOfFileReached = do
    let endOfFileError = Left $ mkIOError eofErrorType "" Nothing Nothing
    TestCase $ assertEqual "for serverEvent (Left IOError)" (serverEvent endOfFileError) CloseEvent

testCreateCorsHeaders = do
    TestCase $ assertEqual "for createCorsHeaders BANANA" (createCorsHeaders "BANANA") [("Access-Control-Allow-Origin", "BANANA")]

testMakePort :: Test
testMakePort = do
    let port = makePort "0" defaultOptions
    TestCase $ assertEqual "for makePort PORT 1337" port (defaultOptions { optPort = 0 })

main :: IO ()
main = do
    counts <- runTestTT $ test [
        testServerEvent,
        testServerEventClosesWhenEndOfFileReached,
        testCreateCorsHeaders,
        testMakePort
      ]
    putStrLn "Done"
