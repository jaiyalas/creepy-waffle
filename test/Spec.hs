import Test.Hspec

main :: IO ()
main = do
   hspec spec

spec :: Spec
spec = do
   describe "whatever" $ do
      it "1 == 1" $ do
         1 `shouldBe` (1 :: Int)
