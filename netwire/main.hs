module Main where

import Prelude hiding ((.))
import Control.Wire hiding (id)
import System.IO
import Control.Applicative
import Control.Monad.IO.Class (liftIO, MonadIO)
import Control.Monad.Fix (fix)
import Control.Concurrent (threadDelay)

import Data.Time.Clock -- (getCurrentTime, diffUTCTime, UTCTime)
import qualified Data.Time.LocalTime as LT

{-
A session is a state machine or so called state generator.
Namely, it must exist together with a step function that can generates next state.

This "state" is the thing that drives our system to work.
In FRP, such "states" is drived, or say, is determined, by the real time.
This is why session must contain a MonadIO as its working monad.
-}

data Sw a = On { level :: a } | Off deriving (Show, Eq)

instance Num a => Monoid (Sw a) where
   mempty  = Off
   mappend (On i) (On j) = On (i + j)
   mappend (On i)    Off = On i
   mappend Off   (On i)  = On i
   mappend Off Off       = Off

newtype MyInt = MyInt Int

simpleGen :: (MonadIO m) => Session m (Timed MyInt (Sw Int))
simpleGen = Session $ do
   tInit <- liftIO getCurrentTime
   let sec = round
           $ LT.todSec
           $ LT.localTimeOfDay
           $ LT.zonedTimeToLocalTime
           $ LT.utcToZonedTime LT.utc
           $ tInit
   return (On n, simpleGen')

simpleGen' :: (MonadIO m) => Session m (Timed MyInt (Sw Int))
simpleGen' = Session $ do
   return (Off, simpleGen)

turnLight :: Wire (Sw Int) () Identity () (Maybe Int)
turnLight = mkSF $
   \state _ ->
      case state of
         (On i) -> (Just i,  turnLight)
         (Off)  -> (Nothing, turnLight)

mainLoop wire sess = do
   (sw, nSess) <- stepSession sess
   let Identity (out, nWire) = stepWire wire sw (Right ())
   liftIO $ do
      putStrLn (either (\ex -> "PAUSED") show out)
      hFlush stdout
   threadDelay 1200000
   -- events <- SDL.pollEvents
   -- unless qPressed (loop nWire nSess)s
   mainLoop nWire nSess

-- main :: IO ()
-- main = mainLoop turnLight (simpleGen 0)


myIntegral :: (Fractional a, HasTime t s)
    => a -> Wire s e m a a
myIntegral n =
    mkPure $ -- (s -> a -> (Either e b, Wire s e m a b)) -> Wire s e m a b
    \state input ->
        let dt = realToFrac (dtime state)
        in n `seq` (Right n, myIntegral (n + dt * input))


--
--
--
-- type EmptyBlocking = ()
--
yoloSession :: (MonadIO m) => Session m (s -> Timed Int s)
yoloSession =
    Session $ do
        t0 <- liftIO getCurrentTime
        let sec = round
                $ LT.todSec
                $ LT.localTimeOfDay
                $ LT.zonedTimeToLocalTime
                $ LT.utcToZonedTime LT.utc
                $ t0
        return (Timed sec, loop t0)
    where
    loop t' =
        Session $ do
            t <- liftIO getCurrentTime
            let sec = round
                    $ LT.todSec
                    $ LT.localTimeOfDay
                    $ LT.zonedTimeToLocalTime
                    $ LT.utcToZonedTime LT.utc
                    $ t
            sec `seq` return (Timed sec, loop t)
--
-- yolo :: (MonadIO m)
--      => Session m (Timed Int ())
-- yolo = yoloSession <*> pure ()
--
-- twire :: Wire (Timed Int ()) EmptyBlocking Identity a Int
-- twire = myT 0
--
-- main :: IO ()
-- main = do
--    tInit <- liftIO getCurrentTime
--    let sec = round
--            $ LT.todSec
--            $ LT.localTimeOfDay
--            $ LT.zonedTimeToLocalTime
--            $ LT.utcToZonedTime LT.utc
--            $ tInit
--    testWire yolo (myT sec)
--    putStrLn $ show "."
--
--
-- myT :: (HasTime t s) => t -> Wire s EmptyBlocking m a t
-- myT t = mkSF -- :: Monoid s => (s -> a -> (b, Wire s e m a b)) -> Wire s e m a b
--       $ \ds _ ->
--         let u = t + dtime ds
--         in u `seq` (u, myT u)




--
