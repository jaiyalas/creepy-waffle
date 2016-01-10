{-# LANGUAGE OverloadedStrings #-}
--
module Main where
--
import qualified SDL as SDL
import Linear.V2 (V2(..))
import Linear.V4 (V4(..))
--
-- import Control.Wire
import Control.Concurrent (threadDelay)
--
main :: IO ()
main = do
   SDL.initializeAll
   window <- SDL.createWindow "output" winConfig
   renderer <- SDL.createRenderer window (-1) rdrConfig
   mainLoop renderer
--
mainLoop :: SDL.Renderer -> IO ()
mainLoop rdr = do
   -- events <- SDL.pollEvents
   SDL.rendererDrawColor rdr SDL.$= V4 0 0 255 255
   SDL.clear rdr
   SDL.present rdr
   threadDelay 20000
   mainLoop rdr


-- .
winConfig = SDL.defaultWindow
   { SDL.windowPosition = SDL.Centered
   , SDL.windowInitialSize = V2 640 480
   }

rdrConfig = SDL.RendererConfig
   { SDL.rendererType = SDL.AcceleratedVSyncRenderer
   , SDL.rendererTargetTexture = True
   }
