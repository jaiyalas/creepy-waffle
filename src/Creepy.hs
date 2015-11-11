{-# LANGUAGE OverloadedStrings #-}
--
module Main where
--
import qualified CreepyWaffle.UI as UI
import qualified CreepyWaffle.EventHandle as EH
import qualified CreepyWaffle.SimpleMapLoader as Loader
--
import CreepyWaffle.Types
--
import Control.Concurrent (threadDelay)
import Control.Monad (unless)
import Control.Monad.Fix (fix)
--

--
main :: IO ()
main = do
   smap <- Loader.readMap "simple.map"
   --
   (texture,renderer) <- UI.initSDL
   --
   let player = Player
         { hp = 50, mp = 10
         , lX = 15, lY = 15
         , package = []
         , actions = []
         }
   --
   let mainLoop = \loop -> do
         threadDelay 50000
         --
         UI.showWindowBg   texture
         UI.showPlayerInfo texture player
         UI.showConcole    texture smap
         --
         UI.refreshSDL texture renderer
         --
         quitS <- EH.quitPredicate
         unless quitS loop
   --
   fix $ mainLoop
