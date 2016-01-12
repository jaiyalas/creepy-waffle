{-# LANGUAGE OverloadedStrings #-}
module Lesson05 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
--
import qualified Config
--
lesson05 :: IO ()
lesson05 = do
   print "lesson05"
