{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE OverloadedStrings #-}
--
module Main where
--
import Control.Concurrent (threadDelay)
--
import Data.Maybe (catMaybes)
--
import qualified SDL
import SDL.Cairo (createCairoTexture)
import SDL.Cairo.Canvas
--
import Linear.V2 (V2(..))
--
import Control.Wire hiding ((.),id)


main :: IO ()
main = do
   -- SDL.initializeAll
   SDL.initialize [SDL.InitVideo]
   window   <- SDL.createWindow "Hello!" winConfig
   renderer <- SDL.createRenderer window (-1) rdrConfig
   texture  <- createCairoTexture renderer (V2 winWidth winHeight)
   --
   mainloop renderer texture clockSession network
   SDL.destroyWindow window
   SDL.quit

--
mainloop :: (HasTime t s, Show t)
         => SDL.Renderer
         -> SDL.Texture
         -> Session IO s
         -> Wire s () Identity [SDL.Keycode] String
         ->  IO ()
mainloop re tx sess wire = do
   -- event pull
   kcs <- events2Kcodes <$> SDL.pollEvents
   -- kcs :: [SDL.Keycode]
   -- FRP step
   (st, sess') <- stepSession sess
   let Identity (eout, wire') = stepWire wire st (Right kcs)
   -- update screen
   withCanvas tx $ do
      background $ gray 250
      textFont $ Font "Hiragino Maru Gothic ProN" 20 False False
      stroke $ red 255
      text (show $ eout) (V2 40 40)
   refreshSDL tx re

   -- sys delay
   threadDelay 500000
   mainloop re tx sess' wire'
--
-- ### ### ### ### ### ### ### ### ### ### ### ### --
--

network :: HasTime t s => Wire s () Identity
            [SDL.Keycode] String
network = mkSF $ \state input ->
   ( show (dtime state) ++ "::" ++ (show input)
   , network)
--
-- ### ### ### ### ### ### ### ### ### ### ### ### --
--
events2Kcodes :: [SDL.Event] -> [SDL.Keycode]
events2Kcodes = catMaybes . map event2Kcode
--
event2Kcode :: SDL.Event -> Maybe SDL.Keycode
event2Kcode e = case SDL.eventPayload e of
   SDL.KeyboardEvent edata -> if isPressed edata
      then return $ getKeycode edata
      else Nothing
   otherwise -> Nothing
--
isPressed :: SDL.KeyboardEventData -> Bool
isPressed edata =
   SDL.keyboardEventKeyMotion edata == SDL.Pressed
--
getKeycode :: SDL.KeyboardEventData -> SDL.Keycode
getKeycode = SDL.keysymKeycode . SDL.keyboardEventKeysym
--
-- ### ### ### ### ### ### ### ### ### ### ### ### --
--
winWidth  = 800
winHeight = 600
--
winConfig = SDL.defaultWindow
   { SDL.windowPosition = SDL.Centered
   , SDL.windowInitialSize = V2 winWidth winHeight
   -- , SDL.windowMode = SDL.Fullscreen
   }

rdrConfig = SDL.RendererConfig
   { SDL.rendererType = SDL.AcceleratedVSyncRenderer
   , SDL.rendererTargetTexture = True
   }
--
refreshSDL :: SDL.Texture -> SDL.Renderer -> IO ()
refreshSDL t r = do
   SDL.clear r
   SDL.copy r t Nothing Nothing
   SDL.present r
