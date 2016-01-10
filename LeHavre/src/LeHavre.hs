{-# LANGUAGE OverloadedStrings #-}
--
module Main where
--
import qualified SDL as SDL
import Linear.V2 (V2(..))
import Linear.V4 (V4(..))
--
import Data.Int
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
   -- let yoo = map (picker . SDL.eventPayload) events
   --     yolo = foldr max (V2 0 0) yoo
   SDL.setMouseLocationMode SDL.AbsoluteLocation
   p <- SDL.getMouseLocation
   -- te <- SDL.getKeyboardState
   SDL.rendererDrawColor rdr SDL.$= V4 0 200 255 255
   SDL.clear rdr
   SDL.present rdr
   threadDelay 500000
   putStrLn $ (show p) -- ++ (show $ te SDL.ScancodeEscape)
   mainLoop rdr

picker :: SDL.EventPayload -> V2 Int32
picker (SDL.MouseMotionEvent mmed) =
   SDL.mouseMotionEventRelMotion mmed
picker _ = V2 0 0


-- .
winConfig = SDL.defaultWindow
   { SDL.windowPosition = SDL.Centered
   , SDL.windowInitialSize = V2 640 480
   }

rdrConfig = SDL.RendererConfig
   { SDL.rendererType = SDL.AcceleratedVSyncRenderer
   , SDL.rendererTargetTexture = True
   }
