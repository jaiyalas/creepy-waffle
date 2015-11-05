{-# LANGUAGE OverloadedStrings #-}
module MyBrick.Core where
--
--
import Data.Monoid
import Data.Default
--
import Control.Applicative
import Control.Monad (void,forever)
import Control.Concurrent (newChan,writeChan,threadDelay,forkIO)
--
import qualified FRP.Elerea.Simple as Ele
--
import qualified Graphics.Vty as V
import qualified Brick.Widgets.Center as C (center)
import qualified Brick.Widgets.Border as B (vBorder,hBorder,border)
import qualified Brick.AttrMap as AM (AttrMap(..), attrMap)
--
import qualified Brick.Main as M
   ( App(..), customMain, defaultMain
   , ViewportScroll, viewportScroll
   , continue, halt
   , neverShowCursor)
--
import Brick.Types
  ( Widget
  , Name
  , EventM
  , Next
  , Padding(Pad,Max)
  , ViewportType(Horizontal, Vertical, Both)
  )
import Brick.Widgets.Core
  ( hLimit  , vLimit
  , hBox    , vBox
  , padLeft , padRight
  , viewport
  , str, withAttr
  )
import Brick.Util (on,fg,bg)
--

data State = St String
           | DefSt

instance Show State where
   show (St s) = s
   show DefSt = "?"

type MyEvent = Maybe V.Key

vty2my :: V.Event -> MyEvent
vty2my (V.EvKey ke ms) = Just ke
vty2my _               = Nothing


drawUi :: State -> [Widget]
drawUi st = [ui]
    where
        ui = C.center $ B.border $ hLimit 80 $ vLimit 20 $
             vBox [ header
                  , B.hBorder
                  , mainLog
                  , B.hBorder
                  , footnote
                  ]
        header = vLimit 3 $ hBox
            [ withAttr "attrStatus" $ viewport status_vpn Vertical $
               padLeft (Pad 1) $ padRight Max $ str "狀態"
            , B.vBorder
            , withAttr "attrStatus" $ viewport item_vpn   Vertical $
               padLeft (Pad 1) $ padRight Max $ str "道具"
            , B.vBorder
            , withAttr "attrStatus" $ viewport spell_vpn  Vertical $
               padLeft (Pad 1) $ padRight Max $ str "行動"
            ]
        mainLog = viewport main_vpn Vertical $
            padLeft (Pad 1) $ str $ "> " ++ (show st)
            -- vBox $ (str <$> [ "Line " <> show i | i <- [1..20::Int] ])
        footnote = withAttr "attrInfo" $
            vLimit 1 $ padLeft (Pad 1) $ padRight Max $ str "info"

appEvent :: State -> MyEvent -> EventM (Next State)
appEvent st (Just k) = case k of
   (V.KChar c) -> M.continue $ St $ "current info is: "++[c]
   (V.KEsc)    -> M.halt DefSt
   _           -> M.continue DefSt
appEvent st Nothing = M.continue DefSt

--

globalDefault :: V.Attr
globalDefault = V.white `on` V.black

attrSet :: State -> AM.AttrMap
attrSet st = AM.attrMap globalDefault $
   [ ("attrStatus", V.white `on` V.blue)
   , ("attrInfo", V.blue `on` V.green)
   ]

--

main :: IO ()
main = do
   -- setup a chan for concurrently reseting
   -- MyEvent to default event, aka, Nothing
   chan <- newChan
   forkIO $ forever $ do
      writeChan chan (Nothing :: MyEvent)
      threadDelay 500000
   void $ M.customMain (V.mkVty def) chan app DefSt

app :: M.App State MyEvent
app = M.App { M.appDraw         = drawUi
            , M.appStartEvent   = return
            , M.appHandleEvent  = appEvent
            , M.appAttrMap      = attrSet
            , M.appLiftVtyEvent = vty2my
            , M.appChooseCursor = M.neverShowCursor
            }
--

status_vpn :: Name
status_vpn = "statusvp"
item_vpn :: Name
item_vpn = "itemvp"
spell_vpn :: Name
spell_vpn = "spellvp"
main_vpn :: Name
main_vpn = "mainvp"
status_vps :: M.ViewportScroll
status_vps = M.viewportScroll status_vpn
item_vps :: M.ViewportScroll
item_vps = M.viewportScroll item_vpn
spell_vps :: M.ViewportScroll
spell_vps = M.viewportScroll spell_vpn
main_vps :: M.ViewportScroll
main_vps = M.viewportScroll main_vpn
