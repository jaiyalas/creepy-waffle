{- Basic events handling -}
{-# LANGUAGE OverloadedStrings #-}
module Lesson03 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
import Control.Monad (unless)
--
import qualified Config
--
lesson03 :: IO ()
lesson03 = do
   SDL.initialize [SDL.InitVideo]
   window <- SDL.createWindow "Lesson03" Config.winConfig
   SDL.showWindow window
   gSurface <- SDL.getWindowSurface window
   pictureS <- SDL.loadBMP "./img/Broom.bmp"
   -- define the main loop
   let
      loop = do
         -- fetch all events from events pool
         events <- SDL.pollEvents
         -- check the existence of QuitEvent
         let quit = any (== SDL.QuitEvent) $ map SDL.eventPayload events
         SDL.surfaceFillRect gSurface Nothing $
            V4 minBound minBound minBound maxBound
         SDL.surfaceBlit pictureS Nothing gSurface Nothing
         SDL.updateWindowSurface window
         threadDelay 20000
         unless quit loop
   -- exec our main loop
   loop
   SDL.destroyWindow window
   SDL.freeSurface pictureS
   SDL.quit
