{-# LANGUAGE OverloadedStrings #-}
import SDL
import Linear.V2 (V2(..))
import SDL.Cairo
import SDL.Cairo.Canvas

main :: IO ()
main = do
  initialize [InitEverything]
  window <- createWindow "SDL2 Cairo Canvas" defaultWindow
  renderer <- createRenderer window (-1) defaultRenderer
  texture <- createCairoTexture' renderer window

  withCanvas texture $ do
    background $ gray 102
    fill $ red 255 !@ 128
    noStroke
    rect $ D 200 200 100 100
    stroke $ green 255 !@ 128
    fill $ blue 255 !@ 128
    rect $ D 250 250 100 100
    triangle (V2 400 300) (V2 350 400) (V2 400 400)

  copy renderer texture Nothing Nothing
  present renderer
  delay 5000 
