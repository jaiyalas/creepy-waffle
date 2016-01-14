{- draw sprite with image clipping -}
{-# LANGUAGE OverloadedStrings #-}
module Lesson11 where
--
import qualified SDL
--
import Data.Word (Word8(..))
import Linear.Affine (Point(..))
import Linear.V2 (V2(..))
import Linear.V4 (V4(..))
import Foreign.C.Types (CInt)
--
import Control.Concurrent (threadDelay)
import Control.Monad (unless)
--
import qualified Config
--

-- setup xywh for all clips
gSpriteClips :: [SDL.Rectangle CInt]
gSpriteClips =
   [ rect   0   0 100 100  -- LU
   , rect 100   0 100 100  -- RU
   , rect   0 100 100 100  -- LD
   , rect 100 100 100 100] -- RD
   where rect x y w h = SDL.Rectangle (P$V2 x y) (V2 w h)

getClipsW :: [SDL.Rectangle CInt] -> Int -> CInt
getClipsW xs i = let (SDL.Rectangle _ (V2 w _)) = xs !! i in w
getClipsH :: [SDL.Rectangle CInt] -> Int -> CInt
getClipsH xs i = let (SDL.Rectangle _ (V2 _ h)) = xs !! i in h

-- definition of LTexture
data LTexture = LTexture {getTx :: SDL.Texture, getWH :: (V2 CInt)}
--
class Renderable a where
   render :: SDL.Renderer -> a -> SDL.Rectangle CInt -> V2 CInt -> IO ()
--
instance Renderable LTexture where
   render rdr ltx xywh@(SDL.Rectangle _ (V2 w h)) xy = do
      SDL.copy rdr (getTx ltx) (Just xywh) (Just $ SDL.Rectangle (P xy) (V2 w h))

-- definition of loading function
loadFromFile :: SDL.Renderer -> FilePath -> IO LTexture
loadFromFile rdr path = do
   tempSf <- SDL.loadBMP path
   wh <- SDL.surfaceDimensions tempSf
   -- ************ --
   SDL.surfaceColorKey tempSf SDL.$= (Just (V4 223 113 38 maxBound))
   tx <- SDL.createTextureFromSurface rdr tempSf
   SDL.freeSurface tempSf
   return (LTexture tx wh)

--
lesson11 :: IO ()
lesson11 = do
   SDL.initialize [SDL.InitVideo]
   window <- SDL.createWindow "Lesson11" Config.winConfig
   renderer <- SDL.createRenderer window (-1) Config.rdrConfig
   SDL.HintRenderScaleQuality SDL.$= SDL.ScaleLinear
   SDL.rendererDrawColor renderer SDL.$=
      V4 maxBound maxBound minBound maxBound
   SDL.showWindow window

   gSpriteSheetTexture <- loadFromFile renderer "./img/11/sprite.bmp"

   let
      loop = do
         events <- SDL.pollEvents
         let quit = any (== SDL.QuitEvent) $ map SDL.eventPayload events
         -- *** beginning of drawing region ***
         SDL.rendererDrawColor renderer SDL.$=
            V4 minBound minBound maxBound maxBound
         SDL.clear renderer
         -- render with our own function
         render renderer gSpriteSheetTexture (gSpriteClips !! 0) -- LU
            $ V2 0 0
         render renderer gSpriteSheetTexture (gSpriteClips !! 1) -- RU
            $ V2 (Config.winW - (getClipsW gSpriteClips 1) ) 0
            -- $ V2 (Config.winW - (getClipsW gSpriteClips 1) ) 0
         render renderer gSpriteSheetTexture (gSpriteClips !! 2) -- LD
            $ V2 0 (Config.winH - (getClipsH gSpriteClips 2))
         render renderer gSpriteSheetTexture (gSpriteClips !! 3) -- RD
            $ V2 (Config.winW - (getClipsW gSpriteClips 3))
                 (Config.winH - (getClipsH gSpriteClips 3))
         --
         SDL.present renderer
         -- *** end of drawing region ***
         threadDelay 20000
         unless quit loop
   loop
   SDL.destroyWindow window
   SDL.destroyRenderer renderer
   SDL.quit
--
