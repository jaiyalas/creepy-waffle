module Main where
--
-- fix :: (a -> a) -> a
-- join :: Monad am => m (m a) -> m a
-- when :: Applicative f => Bool -> f () -> f ()
-- unless :: Applicative f => Bool -> f () -> f ()
import Control.Monad (when, unless, join)
import Control.Monad.Fix (fix)
import Control.Applicative ((<*>), (<$>))
import System.Exit (exitSuccess)
import Control.Concurrent (threadDelay)
--
import qualified FRP.Elerea.Simple as Ele
--
import qualified SDL
--


-- transfer :: a	           -- ^ initial internal state
--          -> (t -> a -> a) -- ^ state updater function
--          -> Signal t	     -- ^ input signal
--          -> SignalGen (Signal a)

main :: IO ()
main = do
   SDL.initialize [SDL.InitEverything]
   fix appLoop
--
appLoop :: IO () -> IO ()
appLoop loop = do
   putStr "."
   events <- SDL.pollEvents
   let qPressed = not (null (filter eventIsQPress events))
   unless qPressed loop

eventIsQPress ::SDL.Event -> Bool
eventIsQPress evt = case SDL.eventPayload evt of
   (SDL.KeyboardEvent kEvtData) ->
      SDL.keyboardEventKeyMotion kEvtData == SDL.Pressed
      &&
      (SDL.keysymKeycode.SDL.keyboardEventKeysym) kEvtData == SDL.KeycodeQ
   otherwise -> False

{-
   -- 看一次就加一的計數器
   step <- Ele.start $ Ele.stateful 0 (1+)
   cntReader <- Ele.start $ Ele.stateful 0 (1+)
   sigReader <- Ele.start $ do
      cntSig <- Ele.effectful cntReader
      tSig <- Ele.transfer A (\n t -> next n t) cntSig
      return $ (print) <$> tSig
   fix $ (\loop -> do
      i <- step
      putStrLn $ "step"++(show i)
      join sigReader
      threadDelay 150000
      when (i<8) loop)
   print "EXIT as NORMAL"
   exitSuccess
-}
-- ############################### --

main2 = do
   cntReader <- Ele.start $ do
      Ele.stateful 0 (1+)
   fix $ (\loop -> do
      i <- cntReader
      print i
      threadDelay 150000
      unless (i==9) loop)
   print "EXIT as NORMAL"
   exitSuccess

-- ############################### --

{-
main = do
   putStrLn "Elerea Demo"
   putStrLn "==========="
   putStrLn "try \"external\""
   (sig,sigWriter) <- Ele.external 'x'
   sigReader <- Ele.start (return sig)
   -- sigReader is a `IO a = S a`
   -- read sigReader out of IO means that
   -- we read it with current IO state as sampling time
   v1 <- sigReader
   -- sigWriter is of type `a -> IO ()` means that
   -- sigWriter write value into the current IO state
   sigWriter 'y'
   v2 <- sigReader
   print [v1,v2]
   putStrLn "==========="
   putStrLn "try \"stateful\""
   cntReader <- Ele.start $ Ele.stateful 0 (1+)
   -- replicateM :: Int -> m a -> m [a]
   r <- replicateM 10 cntReader
   print r
   putStrLn "==========="
   putStrLn "try \"transfer\""
   qq <- Ele.start $ do
      -- cc <- Ele.stateful 1 (+1)
      cc <- Ele.effectful cntReader
      Ele.transfer A next cc
   -- replicateM :: Int -> m a -> m [a]
   r <- replicateM 10 qq
   print r
   putStrLn "==========="
   --
   -- sigReader / sigWriter
   --
   -- r1 <- smp
   -- r2 <- smp
   -- snk 7
   -- r3 <- smp
   -- snk 9
   -- snk 2
   -- r4 <- smp
   -- print [r1,r2,r3,r4]
   --
-}

{-
main :: IO ()
main = do -- in IO ()
   (trigR, trigW) <- external (False)
   -- < trigR :: S Bool
   -- < trigW :: Bool -> IO ()
   withWindow $ (\win -> do -- in IO ()
      network <- start $ do -- in IO ()
         -- > f :: a -> ()
         -- > x :: (S a)
         -- > f <$> a :: S ()
         return $ f <$> x
      -- > fix :: (IO () -> IO ()) -> IO ()
      fix $ \loop -> do
         readInput win trigW
         join network
         threadDelay 20000
         esc <- keyIsPressed win Key'Escape
         unless esc loop
      exitSuccess)
-}
