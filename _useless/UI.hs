{-# LANGUAGE OverloadedStrings #-}

module CreepyWaffle.UI
   ( drawUi
   , eventHandler
   , attrSet
   ) where
--
import CreepyWaffle.Types
--
import Data.Monoid ((<>))
import Control.Applicative
--
import qualified Graphics.Vty as V
import qualified Brick.Widgets.Center as C (center)
import qualified Brick.Widgets.Border as B (vBorder,hBorder,border)
import qualified Brick.AttrMap as AM (AttrMap(..), attrMap)
--
import qualified Brick.Main as M
   ( App(..)
   , ViewportScroll, viewportScroll, vScrollBy
   , continue, halt
   , neverShowCursor)
--
import Brick.Types
  ( Widget
  , Name
  , EventM
  , Next
  , Padding (Pad,Max)
  , ViewportType (Horizontal, Vertical, Both)
  )
import Brick.Widgets.Core
  ( hLimit  , vLimit
  , hBox    , vBox
  , padLeft , padRight
  , viewport
  , str, withAttr, visible
  )
import Brick.Util (on, fg, bg)
--

-- | draw
drawUi :: State -> [Widget]
drawUi (St player idx) = [ui]
   where
      ui = C.center $ B.border $ hLimit 80 $ vLimit 20 $
         vBox [ header
            , B.hBorder
            , mainLog
            , B.hBorder
            , footnote
            ]
      header = vLimit 3 $ hBox
         [ withAttr "status" $ viewport status_vpn Vertical $
            padLeft (Pad 1) $ padRight Max $ -- str "狀態"
            vBox [ str $ "HP: "++(show $ hp player)
                 , str $ "MP: "++(show $ mp player)
                 , str $ "Location: "++(show $ lX player)++" X "++(show $ lY player)]
         , B.vBorder
         , withAttr "status" $ viewport item_vpn   Vertical $
            padLeft (Pad 1) $ padRight Max $ -- str "道具"
            vBox $ do
               it <- zip (package player) [0..]
               let mkItem = if selX idx == 0 && selY idx == snd it
                      then withAttr "cursor" . visible else id
               return $ mkItem $ str $ show (fst it)
         , B.vBorder
         , withAttr "status" $ viewport spell_vpn  Vertical $
            padLeft (Pad 1) $ padRight Max $ -- str "行動"
            vBox $ do
               it <- zip (actions player) [0..]
               let mkItem = if selX idx == 1 && selY idx == snd it
                      then withAttr "cursor" . visible else id
               return $ mkItem $ str $ show (fst it)
         ]
      mainLog = viewport main_vpn Vertical $
         padLeft (Pad 1) $ str $ "> " -- ++ (show st)
         -- vBox $ (str <$> [ "Line " <> show i | i <- [1..20::Int] ])
      footnote = withAttr "info" $
         vLimit 1 $ padLeft (Pad 1) $ padRight Max $
         str $ show idx

-- |
eventHandler :: State -> SmallEvent -> EventM (Next State)
eventHandler st@(St ply ci) (Just k) = case k of
   --
   (V.KDown)  -> M.continue $ moveToR ( 0) ( 1) st
   (V.KUp)    -> M.continue $ moveToR ( 0) (-1) st
   (V.KRight) -> M.continue $ moveToR ( 1) ( 0) st
   (V.KLeft)  -> M.continue $ moveToR (-1) ( 0) st
   --
   (V.KChar ']') -> M.continue $ updateIdx ( 0) ( 1) st
   (V.KChar '[') -> M.continue $ updateIdx ( 0) (-1) st
   (V.KChar '}') -> M.continue $ updateIdx ( 1) ( 0) st
   (V.KChar '{') -> M.continue $ updateIdx (-1) ( 0) st
   --
   (V.KChar 'h') -> M.continue $ (St (updateHP ( 1) ply) ci)
   (V.KChar 'd') -> M.continue $ (St (updateHP (-1) ply) ci)
   (V.KChar c)   -> M.continue $ (St ply ci)
   --
   (V.KEnter)    -> M.continue $ (St ply ci)
   --
   (V.KEsc)    -> M.halt st
   _           -> M.continue st
eventHandler st Nothing = M.continue st

-- |
attrSet :: State -> AM.AttrMap
attrSet st = AM.attrMap (V.white `on` V.black) $
   [ ("status", V.white `on` V.blue)
   , ("cursor", V.blue `on` V.white)
   , ("info",   V.brightBlack `on` V.black)
   ]

--
status_vpn :: Name
status_vpn = "statusvp"
item_vpn :: Name
item_vpn = "itemvp"
spell_vpn :: Name
spell_vpn = "spellvp"
main_vpn :: Name
main_vpn = "mainvp"
-- status_vps :: M.ViewportScroll
-- status_vps = M.viewportScroll status_vpn
-- item_vps :: M.ViewportScroll
-- item_vps = M.viewportScroll item_vpn
-- spell_vps :: M.ViewportScroll
-- spell_vps = M.viewportScroll spell_vpn
-- main_vps :: M.ViewportScroll
-- main_vps = M.viewportScroll main_vpn
