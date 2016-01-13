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
--
-- SDL 會在每次 blit 時做色彩格式轉換
-- 因此可以在 load bmp 之後預先轉換格式
optLoadBMPwith :: SDL.Surface -> FilePath -> IO SDL.Surface
optLoadBMPwith originSf path = do
   newSf <- SDL.loadBMP path
   -- 取得目標 surface 的色彩格式
   spf <- SDL.surfaceFormat originSf
   -- 轉換色彩格式;
   SDL.convertSurface newSf spf
      <* SDL.freeSurface newSf
   -- 等同於以下三行程式碼
   -- optSf <- SDL.convertSurface newSf spf
   -- SDL.freeSurface newSf
   -- return optSf
--
lesson05 :: IO ()
lesson05 = do
   SDL.initialize [SDL.InitVideo]
   window <- SDL.createWindow "Lesson05" Config.winConfig
   SDL.showWindow window
   gSurface <- SDL.getWindowSurface window
   -- 讀圖
   sf <- optLoadBMPwith gSurface "./img/up.bmp"
   let
      loop = do
         events <- SDL.pollEvents
         let quit = any (== SDL.QuitEvent) $ map SDL.eventPayload events
         -- 更新畫面
         SDL.surfaceFillRect gSurface Nothing $
            V4 minBound minBound minBound maxBound
         -- 用不同縮放比例執行 blit
         SDL.surfaceBlitScaled sf Nothing gSurface Nothing
         SDL.updateWindowSurface window
         -- sleep and do next loop-step
         threadDelay 20000
         unless quit loop
   -- 執行 loop
   loop
   SDL.destroyWindow window
   SDL.freeSurface sf
   SDL.quit

-- .
