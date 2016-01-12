{-  基本視窗顯示 -}
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
   -- 取得 window 上的 surface
   gSurface <- SDL.getWindowSurface window
   -- gSurface 全填滿為黑色
   SDL.surfaceFillRect gSurface Nothing $
      V4 minBound minBound minBound maxBound
   -- 更新視窗 surface
   SDL.updateWindowSurface window
   --
   threadDelay 2000000
   --
   SDL.destroyWindow window
   SDL.quit
