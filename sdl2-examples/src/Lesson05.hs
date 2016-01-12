{-# LANGUAGE OverloadedStrings #-}
module Lesson04 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
--
import qualified Config
--
lesson04 :: IO ()
lesson04 = do
   print "lesson04"
