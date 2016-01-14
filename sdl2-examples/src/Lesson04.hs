{- Keyboard events handling -}
{-# LANGUAGE OverloadedStrings #-}
module Lesson04 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Data.Monoid
import Data.Maybe
--
import Control.Concurrent (threadDelay)
import Control.Monad (unless)
--
import qualified Config
--
lesson04 :: IO ()
lesson04 = do
   SDL.initialize [SDL.InitVideo]
   window <- SDL.createWindow "Lesson04" Config.winConfig
   SDL.showWindow window
   gSurface <- SDL.getWindowSurface window
   --
   picDefault <- SDL.loadBMP "./img/press.bmp"
   picUp      <- SDL.loadBMP "./img/up.bmp"
   picDown    <- SDL.loadBMP "./img/down.bmp"
   picLeft    <- SDL.loadBMP "./img/left.bmp"
   picRight   <- SDL.loadBMP "./img/right.bmp"
   -- function to convert a event into a surface
   let e2s = Last.(eventToSurface picUp picDown picLeft picRight picDefault).SDL.eventPayload
   -- define main loop with extra parameter: current blitted surface
   let loop = \prevSurface -> do
         events <- SDL.pollEvents
         let quit = any (== SDL.QuitEvent) $ map SDL.eventPayload events
         let newSurface =
               fromMaybe prevSurface
               -- select the last surface (or nothing)
               $ getLast
               -- convert all events into a list of Maybe surface
               $ foldMap e2s events
         SDL.surfaceFillRect gSurface Nothing $
            V4 minBound minBound minBound maxBound
         SDL.surfaceBlit newSurface Nothing gSurface Nothing
         SDL.updateWindowSurface window
         threadDelay 20000
         unless quit $ loop newSurface
   -- exec main loop
   loop picDefault
   -- release resources
   SDL.destroyWindow window
   SDL.freeSurface picDefault
   SDL.freeSurface picUp
   SDL.freeSurface picDown
   SDL.freeSurface picLeft
   SDL.freeSurface picRight
   SDL.quit

-- to decide a surface to blit from given event info.
eventToSurface :: SDL.Surface -- for up-event
               -> SDL.Surface -- for down-event
               -> SDL.Surface -- for left-event
               -> SDL.Surface -- for right-event
               -> SDL.Surface -- for default
               -> SDL.EventPayload
               -> Maybe SDL.Surface
eventToSurface picUp
               picDown
               picLeft
               picRight
               picDefault
               (SDL.KeyboardEvent ked) =
   case (SDL.keysymKeycode $ SDL.keyboardEventKeysym ked) of
      SDL.KeycodeUp    -> Just picUp
      SDL.KeycodeDown  -> Just picDown
      SDL.KeycodeLeft  -> Just picLeft
      SDL.KeycodeRight -> Just picRight
      otherwise        -> Just picDefault
-- if input event is not KeyboardEvent then return Nothing
eventToSurface _ _ _ _ _ _      = Nothing
