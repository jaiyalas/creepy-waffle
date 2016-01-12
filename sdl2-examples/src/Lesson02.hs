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
   -- 取得 window 上的 surface
   gSurface <- SDL.getWindowSurface window
   -- 將圖檔讀為 surface
   pictureS <- SDL.loadBMP "./img/Broom.bmp"
   -- gSurface 全填滿為黑色
   SDL.surfaceFillRect gSurface Nothing $
      V4 minBound minBound minBound maxBound
   -- 將圖檔 surface 貼上(blit)視窗 surface
   SDL.surfaceBlit pictureS Nothing gSurface Nothing
   -- 更新視窗 surface
   SDL.updateWindowSurface window
   --
   threadDelay 5000000
   --
   SDL.destroyWindow window
   SDL.freeSurface pictureS
   SDL.quit
