{- blit optmized image with scaling -}
{-# LANGUAGE OverloadedStrings #-}
module Lesson05 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
import Control.Monad (unless)
import Control.Applicative ((<*))
--
import qualified Config

-- In fact, SDL converts color mode in every blitting if
-- the color mode of source surface doesn't match
-- the color mode of target surface.
-- To avoid those converting, a simple way is to
-- align their color mode whenever we load an image.
optLoadBMPwith :: SDL.Surface -> FilePath -> IO SDL.Surface
optLoadBMPwith originSf path = do
   imgSf <- SDL.loadBMP path
   -- get the color mode of given surface
   spf <- SDL.surfaceFormat originSf
   -- align the color mode of image surface
   SDL.convertSurface imgSf spf
      <* SDL.freeSurface imgSf
   -- equals to the following lines
   -- optSf <- SDL.convertSurface imgSf spf
   -- SDL.freeSurface imgSf
   -- return optSf
--
lesson05 :: IO ()
lesson05 = do
   SDL.initialize [SDL.InitVideo]
   window <- SDL.createWindow "Lesson05" Config.winConfig
   SDL.showWindow window
   gSurface <- SDL.getWindowSurface window
   sf <- optLoadBMPwith gSurface "./img/05/up.bmp"
   let
      loop = do
         events <- SDL.pollEvents
         let quit = any (== SDL.QuitEvent) $ map SDL.eventPayload events
         SDL.surfaceFillRect gSurface Nothing $
            V4 minBound minBound minBound maxBound
         -- blit with given scaling setup
         -- Nothing for default setup - blitting with fully filling
         SDL.surfaceBlitScaled sf Nothing gSurface Nothing
         SDL.updateWindowSurface window
         threadDelay 20000
         unless quit loop
   loop
   SDL.destroyWindow window
   SDL.freeSurface sf
   SDL.quit

-- .
