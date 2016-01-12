{-# LANGUAGE OverloadedStrings #-}
module Lesson07 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
--
import qualified Config
--
lesson07 :: IO ()
lesson07 = do
   print "lesson07"
