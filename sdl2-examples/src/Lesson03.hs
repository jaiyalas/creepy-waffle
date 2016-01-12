{-  事件處理 -}
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
   -- 定義 loop
   let -- 這裡一定要換行
      loop = do
         -- 擷取所有 events
         events <- SDL.pollEvents
         -- 檢查是不是有 QuitEvent
         let quit = any (== SDL.QuitEvent) $ map SDL.eventPayload events
         -- 更新畫面
         SDL.surfaceFillRect gSurface Nothing $
          V4 minBound minBound minBound maxBound
         SDL.surfaceBlit pictureS Nothing gSurface Nothing
         SDL.updateWindowSurface window
         -- sleep and do next loop-step
         threadDelay 20000
         unless quit loop
   -- 執行 loop
   loop
   SDL.destroyWindow window
   SDL.freeSurface pictureS
   SDL.quit
