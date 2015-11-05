{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad (when, unless, join)
import Control.Monad.Fix (fix)
import Control.Applicative ((<*>), (<$>))
import System.Exit (exitSuccess)
import Control.Concurrent (threadDelay)
--
--
import qualified FRP.Elerea.Simple as Ele
--
import qualified SDL
--
winConfig = SDL.defaultWindow
   { SDL.windowPosition = SDL.Centered -- (P (V2 100 100))
   -- , SDL.windowInitialSize = V2 640 480
   }

rdrConfig = SDL.RendererConfig
   { SDL.rendererType = SDL.AcceleratedVSyncRenderer
   , SDL.rendererTargetTexture = True
   }
--
main = do
   window <- SDL.createWindow "Hello!" winConfig
   renderer <- SDL.createRenderer window (-1) rdrConfig
   bmp <- SDL.loadBMP "/Users/jaiyalas/project/creepy-waffle/hello.bmp"
   tex <- SDL.createTextureFromSurface renderer bmp
   SDL.freeSurface bmp
   --
   SDL.clear renderer
   SDL.copy renderer tex Nothing Nothing
   SDL.present renderer
   --
   SDL.delay 20000
   --
   SDL.destroyTexture tex
   SDL.destroyRenderer renderer
   SDL.destroyWindow window
   --
   SDL.quit
