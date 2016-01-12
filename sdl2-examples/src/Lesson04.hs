{-  事件處理 -}
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
   -- 定義 loop
   let -- 這裡一定要換行
      loop = \prevSurface -> do
         -- 擷取所有 events
         events <- SDL.pollEvents
         -- 檢查是不是有 QuitEvent
         let
            --
            quit = any (== SDL.QuitEvent) $ map SDL.eventPayload events
            --
            eventToSurface (SDL.KeyboardEvent ked) =
               case (SDL.keysymKeycode $ SDL.keyboardEventKeysym ked) of
                  SDL.KeycodeUp    -> Just picUp
                  SDL.KeycodeDown  -> Just picDown
                  SDL.KeycodeLeft  -> Just picLeft
                  SDL.KeycodeRight -> Just picRight
                  otherwise        -> Just picDefault
            eventToSurface _        = Nothing
            --
            newSurface =
               fromMaybe prevSurface
               $ getFirst
               $ foldr mappend mempty
               $ map (First . eventToSurface . SDL.eventPayload) events
         -- 更新畫面
         SDL.surfaceFillRect gSurface Nothing $
          V4 minBound minBound minBound maxBound
         SDL.surfaceBlit newSurface Nothing gSurface Nothing
         SDL.updateWindowSurface window
         -- sleep and do next loop-step
         threadDelay 20000
         unless quit $ loop newSurface
   -- 執行 loop
   loop picDefault
   SDL.destroyWindow window
   SDL.freeSurface picDefault
   SDL.freeSurface picUp
   SDL.freeSurface picDown
   SDL.freeSurface picLeft
   SDL.freeSurface picRight
   SDL.quit
--
