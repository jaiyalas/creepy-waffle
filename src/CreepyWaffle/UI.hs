{-# LANGUAGE OverloadedStrings #-}
module CreepyWaffle.UI where
--
import CreepyWaffle.Types
--
import qualified SDL
import SDL.Cairo (createCairoTexture)
import SDL.Cairo.Canvas
--
import qualified SDL.Cairo.Image as I
--
import Codec.Picture
import qualified Graphics.Rendering.Cairo as Ca
   (setAntialias, Antialias(..))
--
import Linear.V2 (V2(..))

winWidth  = 800
winHeight = 600
--
initSDL :: IO (SDL.Texture, SDL.Renderer)
initSDL = do
   SDL.initialize [SDL.InitEverything]
   window   <- SDL.createWindow "Hello!" winConfig
   renderer <- SDL.createRenderer window (-1) rdrConfig
   texture  <- createCairoTexture renderer (V2 winWidth winHeight)
   return (texture, renderer)
--
refreshSDL :: SDL.Texture -> SDL.Renderer -> IO ()
refreshSDL t r = do
   SDL.copy r t Nothing Nothing
   SDL.present r
--
showCharImg :: SDL.Texture -> Codec.Picture.Image PixelRGBA8 -> IO ()
showCharImg st img = I.drawImg st (V2 10 10) img
--
showNewtonImg :: SDL.Texture -> Codec.Picture.Image PixelRGBA8 -> IO ()
showNewtonImg st img = I.drawImg st (V2 10 150) img

--
-- withCanvas :: Texture -> Canvas a -> IO a
showWindowBg :: SDL.Texture -> IO ()
showWindowBg tx = withCanvas tx $ do
   background $ gray 220
   fill $ blue 255 !@ 64
   noStroke
   rect $ D 0 0 640 100
--
showPlayerInfo :: SDL.Texture -> Player -> IO ()
showPlayerInfo tx p = withCanvas tx $ do
   textFont $ Font "Hiragino Maru Gothic ProN" 20 False False
   fill $ gray 0
   text ("HP:[" ++ (show $ hp p) ++ "]  MP:["++ (show $ mp p) ++"]")
      (V2 30 40)
   text ("X/Y:[" ++ (show $ lX p) ++ "/"++ (show $ lY p) ++"]")
      (V2 400 40)
--
showConcole :: SDL.Texture -> [String] -> IO ()
showConcole tx ss = withCanvas tx $ do
   textFont $ Font "Hiragino Maru Gothic ProN" 20 False False
   fill $ gray 0
   let lctx = take 10 ss
       delta = 30
       initY = 150
       tab   = 25
       short = \x -> "> " ++ (take (28 `min` length x) x)
   text (short $ lctx !! 0) (V2 tab (initY + 0 * delta))
   text (short $ lctx !! 1) (V2 tab (initY + 1 * delta))
   text (short $ lctx !! 2) (V2 tab (initY + 2 * delta))
   text (short $ lctx !! 3) (V2 tab (initY + 3 * delta))
   text (short $ lctx !! 4) (V2 tab (initY + 4 * delta))
   text (short $ lctx !! 5) (V2 tab (initY + 5 * delta))
   text (short $ lctx !! 6) (V2 tab (initY + 6 * delta))
   text (short $ lctx !! 7) (V2 tab (initY + 7 * delta))
   text (short $ lctx !! 8) (V2 tab (initY + 8 * delta))
   text (short $ lctx !! 9) (V2 tab (initY + 9 * delta))
--
--
-- ########################################################
--
winConfig = SDL.defaultWindow
   { SDL.windowPosition = SDL.Centered
   , SDL.windowInitialSize = V2 winWidth winHeight
   , SDL.windowMode = SDL.Fullscreen
   }

rdrConfig = SDL.RendererConfig
   { SDL.rendererType = SDL.AcceleratedVSyncRenderer
   , SDL.rendererTargetTexture = True
   }
--
