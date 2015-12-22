{-# LANGUAGE OverloadedStrings #-}
module Event where
--
import Data.Monoid
import Data.Default
--
import Control.Applicative
import Control.Monad (void)
import Control.Concurrent (newChan)
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
  , str
  )
import Brick.Util (on,fg,bg)
--
data ItemType = IT_WEAPON
              | IT_ARMOR
              | IT_POSION
              | IT_BOOK
              | IT_UNKNOWN
data Item = Item
   { itname :: String
   , ittype :: ItemType
   , itnum  :: Int}

instance Default Item where
   def = Item "unknown" IT_UNKNOWN 0
--
data ActType = AT_CAST {heal :: Int, dmg :: Int}
             | AT_MOVE {speed :: Int}
data Act = Act
   { actname :: String
   , acttype :: ActType}

instance Default Act where
   def = Act "idle" (AT_MOVE 0)
--
data Player = Player
   { hp :: Int
   , mp :: Int
   , package :: [Item]
   , action  :: [Act]}
--
type KeyEvent = Maybe V.Key

liftEKE :: V.Event -> KeyEvent
liftEKE (V.EvKey k ms) = Just $ k
liftEKE _              = Nothing

type State = Char

initState :: State
initState = '?'

--
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
            [ viewport status_vpn Vertical $
               padLeft (Pad 1) $ padRight Max $ str "狀態"
            , B.vBorder
            , viewport item_vpn   Vertical $
               padLeft (Pad 1) $ padRight Max $ str "道具"
            , B.vBorder
            , viewport spell_vpn  Vertical $
               padLeft (Pad 1) $ padRight Max $ str "行動"
            ]
        mainLog = viewport main_vpn Vertical $
            padLeft (Pad 1) $ str $ "> "++[st]
            -- vBox $ (str <$> [ "Line " <> show i | i <- [1..20::Int] ])
        footnote = vLimit 1 $ padLeft (Pad 1) $ str "info"

appEvent :: State -> KeyEvent -> EventM (Next State)
appEvent _ (Just (V.KChar c)) = M.continue c
appEvent _ (Just  V.KEsc)     = M.halt '?'
appEvent _ _ = M.continue '?'

globalDefault :: V.Attr
globalDefault = V.white `on` V.blue

attrSet :: State -> AM.AttrMap
attrSet st = AM.attrMap globalDefault
    [ ("foundFull",               V.white `on` V.green)
    , ("foundFgOnly",             fg V.red)
    , ("general",                 V.yellow `on` V.black)
    , ("general" <> "specific",   fg V.cyan)
    ]
--

main :: IO ()
main = do
   chan <- newChan
   void $ M.customMain (V.mkVty def) chan app initState

app :: M.App State KeyEvent
app = M.App { M.appDraw         = drawUi
            , M.appStartEvent   = return
            , M.appHandleEvent  = appEvent
            , M.appAttrMap      = attrSet
            , M.appLiftVtyEvent = liftEKE
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
