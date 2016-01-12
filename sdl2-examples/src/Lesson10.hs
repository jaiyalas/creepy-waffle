{-# LANGUAGE OverloadedStrings #-}
module Lesson10 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
--
import qualified Config
--
lesson10 :: IO ()
lesson10 = do
   print "lesson10"
