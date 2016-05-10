import Test.HUnit
import Network.Wai.EventSource (ServerEvent(..))
import Blaze.ByteString.Builder.Char8 (fromString)

import Lib (serverEvent)

testServerEvent = do
    let expectedName = Nothing
    let expectedId = Nothing
    let expectedData = [ fromString "Hello World" ]
    let ServerEvent actualName actualId actualData = serverEvent $ Right "Hello World!"
    TestCase $ do
        assertEqual "for severEvent (Right \"Hello World!\")" (length actualData) 1

main :: IO ()
main = do
    counts <- runTestTT $ test [testServerEvent]
    putStrLn "Done"
