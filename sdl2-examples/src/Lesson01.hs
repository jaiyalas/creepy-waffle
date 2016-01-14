{- Basic Window Setup and Display  -}
{-# LANGUAGE OverloadedStrings #-}
module Lesson01 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
--
import qualified Config
--
lesson01 :: IO ()
lesson01 = do
   SDL.initialize [SDL.InitVideo]
   window <- SDL.createWindow "Lesson01" Config.winConfig
   SDL.showWindow window
   -- get surface from given window
   gSurface <- SDL.getWindowSurface window
   -- fill the global surface with black
   SDL.surfaceFillRect gSurface Nothing $
      -- setting color with R-G-B-A
      V4 maxBound maxBound minBound maxBound
   -- update the surface for a specific window
   SDL.updateWindowSurface window
   --
   threadDelay 2000000
   --
   SDL.destroyWindow window
   SDL.quit
