{-# LANGUAGE OverloadedStrings #-}
--
module Main where
--
import qualified SDL as SDL
import Linear.V2 (V2(..))
import Linear.V4 (V4(..))
import Linear.Affine
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
   SDL.setMouseLocationMode SDL.AbsoluteLocation
   mainLoop renderer
--
mainLoop :: SDL.Renderer -> IO ()
mainLoop rdr = do
   events <- SDL.pollEvents
   let yoo = map (picker . SDL.eventPayload) events
       p = foldr max Nothing yoo
   SDL.rendererDrawColor rdr SDL.$= V4 0 200 255 255
   SDL.clear rdr
   SDL.present rdr
   threadDelay 300000
   putStr $ maybe "" (\x -> "YES " ++ (show x) ++ "\n") p
   pos <- SDL.getAbsoluteMouseLocation
   putStrLn $ (show pos)
   mainLoop rdr

picker :: SDL.EventPayload -> Maybe (Point V2 Int32)
picker (SDL.MouseButtonEvent mmed) =
   case SDL.mouseButtonEventMotion mmed of
      SDL.Released -> Just $ SDL.mouseButtonEventPos mmed
      SDL.Pressed  -> Nothing
picker _ = Nothing

drawGrid :: SDL.Renderer -> IO ()
drawGrid rdr = do
   

-- .
winConfig = SDL.defaultWindow
   { SDL.windowPosition = SDL.Centered
   , SDL.windowInitialSize = V2 640 480
   }

rdrConfig = SDL.RendererConfig
   { SDL.rendererType = SDL.AcceleratedVSyncRenderer
   , SDL.rendererTargetTexture = True
   }
