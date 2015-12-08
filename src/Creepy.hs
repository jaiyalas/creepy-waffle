{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE OverloadedStrings #-}
--
module Main where
--
import qualified CreepyWaffle.UI as UI
import qualified CreepyWaffle.EventHandle as EH
-- import qualified CreepyWaffle.SimpleMapLoader as Loader
import qualified SDL.Cairo.Image as I
--
import CreepyWaffle.Types
--
import Control.Concurrent (threadDelay)
import Control.Monad (unless,join)
import Control.Monad.Fix (fix)
--
import qualified FRP.Elerea.Simple as Ele
--
main :: IO ()
main = do
   --
   --
   -- smap <- Loader.readMap "simple.map"
   charImg <- I.loadRGBA8 I.PNG "/Users/jaiyalas/img/char.png"
   newtonImg <- I.loadRGBA8 I.PNG "/Users/jaiyalas/img/newton.png"
   --
   (texture,renderer) <- UI.initSDL
   --
   -- let player = Player
   --       { hp = 50, mp = 10
   --       , lX = 15, lY = 15
   --       , package = []
   --       , actions = []
   --       }
   --
   (sigR, sigW) <- Ele.external ""
   --
   let draw _ctx = do
         -- UI.showWindowBg   texture
         -- UI.showPlayerInfo texture player
         -- UI.showConcole    texture _ctx
         UI.showCharImg    texture charImg
         UI.showNewtonImg  texture newtonImg
         UI.refreshSDL texture renderer
         sigW ""
         return ()
   let updateCtx str ss = if str == ""
                           then ss
                           else str : (init ss)
   network <- Ele.start $ do
      -- ctx :: Signal [String]
      ctx <- Ele.transfer (take 10 $ repeat "") updateCtx sigR
      -- draw :: [String] -> IO ()
      return $ draw <$> ctx
   --
   let mainLoop = \loop -> do
         threadDelay 250000
         qb <- EH.testTrigger sigW
         join network
         --
         unless qb loop
   --
   fix $ mainLoop
{-
## 2D

### Role-playing
### Role-playing Choices
### Tactical RPGs
### 4X game
### Turn-based strategy
### Turn-based tactics

---

1. capture
2. clarify
3. organise
4. reflect
5. engage

-}
