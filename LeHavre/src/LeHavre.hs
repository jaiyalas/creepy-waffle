{-# LANGUAGE OverloadedStrings #-}
--
module Main where
--
import qualified SDL as SDL
import Linear.V2 (V2(..))
import Linear.V4 (V4(..))
import Linear.Affine
--
import Foreign.C.Types (CInt)
import Data.Int (Int32)
import           Data.Map.Strict hiding (map, foldr)
import qualified Data.Map.Strict as Map (map, foldr)
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
   -- gSurface <- SDL.getWindowSurface gWindow
   -- gTexture <- SDL.createTextureFromSurface gRenderer gSurface
   -- .
   gTexture <- SDL.createTexture gRenderer SDL.ARGB8888 SDL.TextureAccessStreaming (V2 640 480)
   -- .
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
--

data Cat = E -- always empty
         | S -- always solid
         | B  -- body
         | C -- cockpit
         | K -- skin
         deriving (Show,Eq,Ord)

template :: [[Cat]]
template =
   [[E,E,E,E,K,K]
   ,[E,E,E,K,B,B]
   ,[E,E,E,K,B,S]
   ,[E,E,K,B,B,S]
   ,[E,E,K,B,B,S]
   ,[E,K,B,B,B,S]
   ,[K,B,B,B,C,C]
   ,[K,B,B,B,C,C]
   ,[K,B,B,B,C,C]
   ,[K,B,B,B,B,S]
   ,[E,K,K,B,B,B]
   ,[E,E,E,K,K,K]]

preset :: Map (Int, Int) Cat
preset = let aux y (x,v) = ((x,y),v) in
   fromList
   $ concat
   $ zipWith (\i row -> map (aux i) row) [0..]
   $ map (zip [0..]) template
--
wE :: (Int, Int) -> Map (Int, Int) Cat -> Map (Int, Int) Cat
wE xy m = update (const (Just E)) xy m
--
wS :: (Int, Int) -> Map (Int, Int) Cat -> Map (Int, Int) Cat
wS xy m = update (const (Just S)) xy m
--
wB :: (Int, Int) -> Map (Int, Int) Cat -> Map (Int, Int) Cat
wB xy m = update (const (Just B)) xy m
--
wC :: (Int, Int) -> Map (Int, Int) Cat -> Map (Int, Int) Cat
wC xy m = update (const (Just C)) xy m
--
wK :: (Int, Int) -> Map (Int, Int) Cat -> Map (Int, Int) Cat
wK xy m = update (const (Just K)) xy m
--

genCore :: IO

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
