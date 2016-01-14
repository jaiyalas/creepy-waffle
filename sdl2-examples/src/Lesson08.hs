{- Geometry and drawing with renderer -}
{-# LANGUAGE OverloadedStrings #-}
module Lesson08 where
--
import qualified SDL
--
import Data.Word (Word8(..))
import Linear.Affine (Point(..))
import Linear.V2 (V2(..))
import Linear.V4 (V4(..))
--
import Control.Concurrent (threadDelay)
import Control.Monad (unless,forM_)
--
import qualified Config
--
-- defne colors with RGBA
v4White, v4Black, v4Green, v4Red, v4Blue, v4Yellow :: V4 Word8
v4White  = V4 maxBound maxBound maxBound maxBound
v4Black  = V4 minBound minBound minBound maxBound
v4Green  = V4 minBound maxBound minBound maxBound
v4Red    = V4 maxBound minBound minBound maxBound
v4Blue   = V4 minBound minBound maxBound maxBound
v4Yellow = V4 maxBound maxBound minBound maxBound
--
lesson08 :: IO ()
lesson08 = do
   SDL.initialize [SDL.InitVideo]
   window <- SDL.createWindow "Lesson08" Config.winConfig
   renderer <- SDL.createRenderer window (-1) Config.rdrConfig
   SDL.HintRenderScaleQuality SDL.$= SDL.ScaleLinear
   SDL.rendererDrawColor renderer SDL.$= v4White
   SDL.showWindow window
   let
      loop = do
         events <- SDL.pollEvents
         let quit = any (== SDL.QuitEvent) $ map SDL.eventPayload events
         -- *** beginning of drawing region ***
         SDL.rendererDrawColor renderer SDL.$= v4White
         SDL.clear renderer
         -- define rects
         let
            rect_red   = SDL.Rectangle
               (fmap (`div` 4) $ P $ Config.winV2)
               (fmap (`div` 2) Config.winV2)
            rect_green = SDL.Rectangle
               (fmap (`div` 6) $ P $ Config.winV2)
               (fmap ((`div` 3).(*2)) Config.winV2)
         -- fill the inner rect
         SDL.rendererDrawColor renderer SDL.$= v4Red
         SDL.fillRect renderer (Just $ rect_red)
         -- draw the outter rect
         SDL.rendererDrawColor renderer SDL.$= v4Green
         SDL.drawRect renderer (Just $ rect_green)
         -- draw line
         SDL.rendererDrawColor renderer SDL.$= v4Blue
         SDL.drawLine renderer
            (P $ V2           0 (Config.winH `div` 2))
            (P $ V2 Config.winW (Config.winH `div` 2))
         -- draw dotted line
         SDL.rendererDrawColor renderer SDL.$= v4Yellow
         forM_ [0,4..Config.winH] $
            (\y -> SDL.drawPoint renderer (P $ V2 (Config.winW `div` 2) y))
         --
         SDL.present renderer
         -- *** end of drawing region ***
         threadDelay 20000
         unless quit loop
   loop
   SDL.destroyWindow window
   SDL.destroyRenderer renderer
   SDL.quit
