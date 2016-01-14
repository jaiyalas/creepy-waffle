{-  Load and display image via surface -}
{-# LANGUAGE OverloadedStrings #-}
module Lesson02 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
--
import qualified Config
--
lesson02 :: IO ()
lesson02 = do
   SDL.initialize [SDL.InitVideo]
   window <- SDL.createWindow "Lesson02" Config.winConfig
   SDL.showWindow window
   gSurface <- SDL.getWindowSurface window
   SDL.surfaceFillRect gSurface Nothing $
      V4 minBound minBound minBound maxBound
   -- load image file as a surface
   pictureS <- SDL.loadBMP "./img/Broom.bmp"
   -- blit(copy/show) image surface onto window surface
   SDL.surfaceBlit pictureS Nothing gSurface Nothing
   SDL.updateWindowSurface window
   threadDelay 5000000
   SDL.destroyWindow window
   -- releace surface
   SDL.freeSurface pictureS
   SDL.quit
