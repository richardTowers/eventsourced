{-# LANGUAGE StandaloneDeriving #-}

import Test.HUnit
import System.IO.Error
import Network.Wai.EventSource (ServerEvent(..))
import Blaze.ByteString.Builder.Char8 (fromString)
import Blaze.ByteString.Builder (toByteString)
import Data.ByteString.Char8 (unpack)
import Data.ByteString.Builder (Builder)

import Lib (serverEvent)

-- ServerEvent and Builder don't derive Eq or Show, which makes them hard to test.
-- We can tell Haskell how to compare / show them by creating type instances:
deriving instance Show ServerEvent
instance Show (Builder) where show = unpack . toByteString
deriving instance Eq ServerEvent
instance Eq Builder where
    (==) x y = (show x) == (show y)
    (/=) x y = (show x) /= (show y)

testServerEvent = do
    let expectedName = Nothing
    let expectedId = Nothing
    let expectedData = [ fromString "Hello World!" ]
    let ServerEvent actualName actualId actualData = serverEvent $ Right "Hello World!"
    TestCase $ do
        assertEqual "for severEvent (Right \"Hello World!\")" actualName expectedName
        assertEqual "for severEvent (Right \"Hello World!\")" actualId expectedId
        assertEqual "for severEvent (Right \"Hello World!\")" actualData expectedData

testServerEventClosesWhenEndOfFileReached = do
    let endOfFileError = Left $ mkIOError eofErrorType "" Nothing Nothing
    TestCase $ do
        assertEqual "for serverEvent (Left IOError)" (serverEvent endOfFileError) CloseEvent

main :: IO ()
main = do
    counts <- runTestTT $ test [testServerEvent, testServerEventClosesWhenEndOfFileReached]
    putStrLn "Done"
