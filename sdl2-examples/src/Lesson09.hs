{-# LANGUAGE OverloadedStrings #-}
module Lesson09 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
--
import qualified Config
--
lesson09 :: IO ()
lesson09 = do
   print "lesson09"
