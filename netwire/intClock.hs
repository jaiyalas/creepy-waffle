module Main where
--
import Prelude hiding (id,(.))
import Control.Wire
--
import Control.Applicative
import Control.Monad.IO.Class (liftIO, MonadIO)
--
import qualified Data.Time.Clock as Clock (getCurrentTime, diffUTCTime, UTCTime)
--
import System.IO
import Control.Concurrent (threadDelay)
--

--
clockN :: MonadIO m => Session m (s -> Timed Int s)
clockN = Session $ do
   t0 <- liftIO Clock.getCurrentTime
   return (Timed 0, clockN' t0)
clockN' :: MonadIO m => Clock.UTCTime -> Session m (s -> Timed Int s)
clockN' ti = Session $ do
   tj <- liftIO Clock.getCurrentTime
   let dt = floor $ Clock.diffUTCTime tj ti
   dt `seq` return (Timed dt, clockN' tj)
--
timeNW :: Int -> Wire (Timed Int ()) () Identity () Int
timeNW i = mkSF $ \state input ->
   let t = i + (dtime state)
   in t `seq` (t, timeNW t)
--
runUnitWire :: (MonadIO m)
            => Session m (() -> Timed Int ())
            -> Wire (Timed Int ()) () Identity () Int
            -> m x
runUnitWire sess wire = do
   (st, s') <- stepSession sess
   let Identity (out, w') = stepWire wire (st ()) (Right ())
   liftIO $ do
      putStrLn $ "t: " ++ (show out) ++ "s"
      threadDelay 2000000
   runUnitWire s' w'
--
-- main2 = runUnitWire clockN (timeNW 0)

alpha :: (HasTime t s, Monad m) => Wire s e m a (Maybe Float)
alpha = pure (Just 1.0)

beta :: (HasTime t s, Monad m) => Wire s e m a (Maybe Float)
beta = mkConst $ Right (Just 0.5)

testW :: (HasTime t s,
          Monad m,
          Monoid e)
      => Wire s e m a String
testW = (pure "Bilp!") >>> for 2 >>> after 3
      <|> (pure "zzz")



ev :: (Monad m, Monoid e, HasTime t s) => Wire s e m a t
ev = time >>> at 3 >>> holdFor 3

ev2 :: (Monad m, Monoid e, HasTime t s) => Wire s e m a String
ev2 = pure kE >>> at 3 >>> holdFor 3

ve :: (Monad m, HasTime t s) => Wire s e m a t
ve = time <<< at 3 <<< pure "Beep!"
-- main :: IO ()
-- main = testWire clockSession_ $ ev
