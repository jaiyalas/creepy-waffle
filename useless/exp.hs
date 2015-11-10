import FRP.Elerea.Simple
--
import Data.Default
import Graphics.Vty
import Brick.Widgets.Border as B
import Brick.Widgets.Center as C
import Control.Monad
--
import Brick.Main (App(..), neverShowCursor, continue, halt, defaultMain)
import Brick.Types ( Widget , Padding(Max,Pad), EventM, Next)
import Brick.Widgets.Core ( str, hLimit, vLimit, padLeft , padRight)
--
-- ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
--
drawUIIO :: Geo -> IO [Widget]
drawUIIO st = do
   ...
   [C.center $ B.border $ hLimit 35 $ vLimit 10 $ str $ show $ st]

drawUI :: Geo -> [Widget]
drawUI st = return $

--
eventHandler :: Geo -> Event -> EventM (Next Geo)
eventHandler st (EvKey k _) = case k of
   --
   (KUp)    -> continue $ st {lY = (lY st + 1)}
   (KDown)  -> continue $ st {lY = (lY st - 1)}
   (KRight) -> continue $ st {lX = (lX st + 1)}
   (KLeft)  -> continue $ st {lX = (lX st - 1)}
   --
   (KEsc)    -> halt st
   _         -> continue st
eventHandler st _ = continue st
--
app :: App Geo Event
app st =
    App { appDraw = drawUI
        , appHandleEvent = eventHandler
        , appStartEvent = return
        , appAttrMap = const def
        , appChooseCursor = neverShowCursor
        , appLiftVtyEvent = id
        }
--
main = do
   -- ( IO Key, Key -> IO () )
   sig <- external (KChar ' ')
   -- IO a
   game <- start $ do
      
   void $ defaultMain app ()
--
data Geo = Geo {lX ::Int, lY :: Int} deriving (Eq,Ord)
instance Show Geo where
   show (Geo _x _y) = "MS["++ show _x ++"/"++ show _y ++"]"
