{-# LANGUAGE OverloadedStrings #-}
module Lesson03 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
--
import qualified Config
--
lesson03 :: IO ()
lesson03 = do
   print "lesson03"
