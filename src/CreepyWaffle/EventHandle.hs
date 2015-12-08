{-# LANGUAGE OverloadedStrings #-}
module CreepyWaffle.EventHandle where
--
import CreepyWaffle.Types
--
import Data.Maybe (catMaybes)
import Control.Monad (mapM)
--
import qualified SDL
import SDL.Cairo (createCairoTexture)
import SDL.Cairo.Canvas
--
import qualified FRP.Elerea.Simple as Ele
--
quitPredicate :: IO Bool
quitPredicate = do
   events <- SDL.pollEvents
   return $ elem SDL.KeycodeEscape $ events2Kcodes events
--
testTrigger :: (String -> IO()) -> IO Bool
testTrigger sW = do
   kcs <- events2Kcodes <$> SDL.pollEvents
   mapM (perform sW) kcs
   return $ elem SDL.KeycodeEscape kcs

perform :: (String -> IO ()) -> SDL.Keycode -> IO ()
perform sW SDL.KeycodeUp      = sW "Up"
perform sW SDL.KeycodeDown    = sW "Down"
perform sW SDL.KeycodeLeft    = sW "Left"
perform sW SDL.KeycodeRight   = sW "Right"
perform sW _                  = return ()


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
isPressed edata = SDL.keyboardEventKeyMotion edata == SDL.Pressed
--
getKeycode :: SDL.KeyboardEventData -> SDL.Keycode
getKeycode = SDL.keysymKeycode . SDL.keyboardEventKeysym
--
