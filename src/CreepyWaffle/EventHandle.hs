{-# LANGUAGE OverloadedStrings #-}
module CreepyWaffle.EventHandle where
--
import CreepyWaffle.Types
--
import qualified SDL
import SDL.Cairo (createCairoTexture)
import SDL.Cairo.Canvas
--

quitPredicate :: IO Bool
quitPredicate = do
   events <- SDL.pollEvents
   let qPressed = not $ null $ filter eventIsESCPress events
   return qPressed
--
-- ########################################################
--
eventIsESCPress ::SDL.Event -> Bool
eventIsESCPress evt = pressKey $ SDL.eventPayload evt
--
pressKey :: SDL.EventPayload -> Bool
pressKey (SDL.KeyboardEvent kEvtData) =
   let kPressed = SDL.keyboardEventKeyMotion kEvtData == SDL.Pressed
   in case (SDL.keysymKeycode $ SDL.keyboardEventKeysym kEvtData) of
         -- SDL.KeycodeW -> True && kPressed
         -- SDL.KeycodeS -> True && kPressed
         -- SDL.KeycodeA -> True && kPressed
         -- SDL.KeycodeD -> True && kPressed
         SDL.KeycodeEscape -> True && kPressed
         _ -> False
pressKey _ = False
