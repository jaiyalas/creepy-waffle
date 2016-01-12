{-# LANGUAGE OverloadedStrings #-}
--
module Main where
--
import qualified SDL as SDL
import Linear.V2 (V2(..))
import Linear.V4 (V4(..))
import Linear.Affine
--
-- import Foreign.C.Types (CInt)
-- import Data.Int (Int32)
--
-- import Control.Wire
import Control.Concurrent (threadDelay)
--
main :: IO ()
main = do
   SDL.initializeAll
   SDL.setMouseLocationMode SDL.AbsoluteLocation
   --
   gWindow <- SDL.createWindow "output" winConfig
   gRenderer <- SDL.createRenderer gWindow (-1) rdrConfig
   -- .
   rinfo <- SDL.getRendererInfo gRenderer
   print rinfo
   print "----------------------"
   -- .
   -- gSurface <- SDL.getWindowSurface gWindow
   -- gTexture <- SDL.createTextureFromSurface gRenderer gSurface
   -- .
   gTexture <- SDL.createTexture gRenderer SDL.ARGB8888 SDL.TextureAccessStreaming (V2 640 480)
   -- .
   tinfo <- SDL.queryTexture gTexture
   print tinfo
   print "----------------------"
   rdrScale <- SDL.get (SDL.rendererScale gRenderer)
   print rdrScale
   return ()
   -- mainLoop gRenderer
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

-- drawGrid :: SDL.Renderer -> IO ()
-- drawGrid rdr = do


-- .
winConfig = SDL.defaultWindow
   { SDL.windowPosition = SDL.Centered
   , SDL.windowInitialSize = V2 640 480
   }

rdrConfig = SDL.RendererConfig
   { SDL.rendererType = SDL.AcceleratedVSyncRenderer
   , SDL.rendererTargetTexture = True
   }
