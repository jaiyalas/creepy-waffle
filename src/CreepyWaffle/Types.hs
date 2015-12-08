{-# LANGUAGE OverloadedStrings #-}

module CreepyWaffle.Types
   ( -- * Items
     Item (..)
   , ItemType (..)
     -- * Actions
   , Act (..)
   , ActType (..)
     -- * Player State
   , Player (..)
   , updateHP
   , updateMP
   , updateLX
   , updateLY
     -- * Current Cursor
   , CursorIdx (..)
     -- * Overall State (Player + Cursor)
   , State (..)
   , updateIdx
   , moveTo
   , moveToR
   --   -- * Small Event, a subset of Vty.Event
   -- , SmallEvent
   -- , vty2se
     -- * Block for Simple Map
   , Block (..)
   , (<!!>)
   ) where
--
import Data.Default
--
-- import qualified Graphics.Vty as V
--
data Item = Item
   { itName :: String
   , itType :: ItemType
   }
   deriving (Eq,Ord)
data ItemType = IT_WEAPON
              | IT_AROMR
              | IT_POSION Act
              | IT_BOOK   Act
              deriving (Eq,Ord)
instance Default Item where
   def = Item "unknown posion" $ IT_POSION def
instance Show ItemType where
   show IT_WEAPON     = "武"
   show IT_AROMR      = "防"
   show (IT_POSION _) = "藥"
   show (IT_BOOK _)   = "書"
instance Show Item where
   show (Item n t) = "["++ show t ++"]:"++n
--
data Act = Act
   { actName :: String
   , actType :: ActType
   }
   deriving (Eq,Ord)
data ActType = AT_CAST {heal :: Int, dmg :: Int}
             | AT_MOVE {speed :: Int}
             deriving (Eq,Ord)
instance Default Act where
   def = Act "idel" $ AT_MOVE 0
instance Show Act where
   show (Act n t) = "["++ show t ++"]:"++n
instance Show ActType where
   show (AT_CAST h d) = "效<"++show h++"/"++show d++">"
   show (AT_MOVE s)   = "移<"++show s++">"
--
data Player = Player
   { hp :: Int, mp :: Int
   , lX :: Int, lY :: Int
   , package :: [Item]
   , actions :: [Act]
   }
   deriving (Eq,Show)
--
updateHP :: Int -> Player -> Player
updateHP i p@(Player h m x y ps as) = p {hp = h+i}
updateMP :: Int -> Player -> Player
updateMP i p@(Player h m x y ps as) = p {mp = m+i}
updateLX :: Int -> Player -> Player
updateLX i p@(Player h m x y ps as) = p {lX = x+i}
updateLY :: Int -> Player -> Player
updateLY i p@(Player h m x y ps as) = p {lY = y+i}
--
data CursorIdx = CursorIdx {selX :: Int, selY :: Int}
               deriving (Eq,Show)
instance Default CursorIdx where
   def = CursorIdx 0 0
--
data State = St Player CursorIdx
           deriving (Eq,Show)
--
updateIdx :: Int -> Int -> State -> State
updateIdx _x _y st@(St p (CursorIdx x y)) =
   let newX = max 0 $ min (x+_x) 1
       newY = max 0 $ min (y+_y) $ (\n->n-1) $
         if newX == 0 then length $ package p else length $ actions p
   in St p (CursorIdx newX newY)
updateIdx _ _ st = st
--
moveTo :: Int -> Int -> State -> State
moveTo _x _y (St p c) = St (p {lX = _x, lY = _y}) c
moveToR :: Int -> Int -> State -> State
moveToR dx dy (St p c) = St (updateLX dx $ updateLY dy p) c
--
-- type SmallEvent = Maybe V.Key
-- --
-- vty2se :: V.Event -> SmallEvent
-- vty2se (V.EvKey ke ms) = Just ke
-- vty2se               _ = Nothing
--
class Block a where
   throughable :: a -> Bool
   encounterable :: a -> Bool
   pickable :: a -> Bool

(<!!>) :: [String] -> (Int,Int) -> Char
ls <!!> (x,y) = (ls !! y) !! x

instance Block Char where
   throughable '*' = False -- Wall
   throughable _   = True  -- Anything not a wall
   encounterable '1' = True
   encounterable '2' = True
   encounterable '3' = True
   encounterable '4' = True
   encounterable '5' = True
   encounterable _ = False
   pickable _ = False
