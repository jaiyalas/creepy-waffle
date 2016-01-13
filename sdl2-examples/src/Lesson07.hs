{-# LANGUAGE OverloadedStrings #-}
module Lesson07 where
--
import qualified SDL
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
import Control.Monad (unless)
--
import qualified Config
--
lesson07 :: IO ()
lesson07 = do
   SDL.initialize [SDL.InitVideo]
   window <- SDL.createWindow "Lesson04" Config.winConfig
   renderer <- SDL.createRenderer window (-1) Config.rdrConfig

   -- 設定 renderer 的顏色
   SDL.rendererDrawColor renderer
      SDL.$= V4 minBound minBound maxBound maxBound

   -- 用 surface 讀取檔案到 memory 中
   -- 將 surface 轉換為 texture (i.e. 載入到顯示卡記憶體中)
   imgSf <- SDL.loadBMP "./img/down.bmp"
   imgTx <- SDL.createTextureFromSurface renderer imgSf
   SDL.freeSurface imgSf

   SDL.showWindow window
   let
      loop = do
         events <- SDL.pollEvents
         let quit = any (== SDL.QuitEvent) $ map SDL.eventPayload events
         -- 清除 texture (用 rendererDrawColor 指定的顏色)
         SDL.clear renderer
         -- rendering texture with renderer
         SDL.copy renderer imgTx Nothing Nothing
         -- renderer in SDL is a buffer, the function "present" will force to flush
         SDL.present renderer

         threadDelay 20000
         unless quit loop
   loop
   -- 釋放記憶體
   SDL.destroyWindow window
   SDL.destroyRenderer renderer
   SDL.destroyTexture imgTx
   SDL.quit
