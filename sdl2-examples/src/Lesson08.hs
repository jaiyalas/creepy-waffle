{-# LANGUAGE OverloadedStrings #-}
module Lesson08 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
--
import qualified Config
--
lesson08 :: IO ()
lesson08 = do
   print "lesson08"
