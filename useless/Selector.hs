module CreepyWaffle.Selector
   (
   -- * Basic Vex
     Vex (..)
   , Vex2 (..)
   , Vex3 (..)
   , VexZipper (..)
   , initVMZ
   -- * ...
   , mvCursorLeft
   , mvCursorRight
   , mvCursorDown
   , mvCursorUp
   -- * Geo
   , Geo (..)
   , geoXsucc
   , geoXpred
   , geoYsucc
   , geoYpred
   , geoZsucc
   , geoZpred
   ) where
--
import qualified Data.List.NonEmpty as NL
--
type Vex  a = NL.NonEmpty       a
type Vex2 a = NL.NonEmpty (Vex  a)
type Vex3 a = NL.NonEmpty (Vex2 a)

data VexZipper a = VexZipper
   { cItem :: a
   , cGeo  :: Geo
   , vPrev :: [Vex2 a]
   , vNext :: [Vex2 a]
   , hPrev :: [Vex a]
   , hNext :: [Vex a]
   , iPrev :: [a]
   , iNext :: [a]
   }
   deriving (Eq,Ord,Show)

initVMZ :: Vex3 a -> VexZipper a
initVMZ (((i NL.:| is) NL.:| xs) NL.:| ys) = VexZipper
   { cItem = i -- :: a
   , cGeo = Geo 0 0 0 -- :: Geo
   , vPrev = [] -- :: [Vex2 a]
   , vNext = ys -- :: [Vex2 a]
   , hPrev = [] -- :: [Vex a]
   , hNext = xs -- :: [Vex a]
   , iPrev = [] -- :: [a]
   , iNext = is -- :: [a]
   }

-- | ...
mvCursorLeft :: VexZipper a -> VexZipper a
mvCursorLeft vz = case hPrev vz of
   [] -> vz
   (h:hs) -> -- h :: Vex a = NEL a
      let (Geo _x _y _z) = cGeo vz
          nx = _x - 1
          ny = _y
          nz = _z `min` (NL.length h - 1)
          (xs,ci:rs) = NL.splitAt nz h
          newNext = NL.fromList $ iPrev vz ++ (cItem vz) : iNext vz
      in VexZipper { cItem = ci
                   , cGeo  = Geo nx ny nz
                   , vPrev = vPrev vz
                   , vNext = vNext vz
                   , hPrev = hs
                   , hNext = newNext : hNext vz
                   , iPrev = xs
                   , iNext = rs
                   }
-- | ...
mvCursorRight :: VexZipper a -> VexZipper a
mvCursorRight vz = case hNext vz of
   [] -> vz
   (h:hs) ->
      let (Geo _x _y _z) = cGeo vz
          nx = _x + 1
          ny = _y
          nz = _z `min` (NL.length h - 1)
          (xs,ci:rs) = NL.splitAt nz h
          newPrev = NL.fromList $ iPrev vz ++ cItem vz : iNext vz
      in VexZipper { cItem = ci
                   , cGeo  = Geo nx ny nz
                   , vPrev = vPrev vz
                   , vNext = vNext vz
                   , hPrev = newPrev : hPrev vz
                   , hNext = hs
                   , iPrev = xs
                   , iNext = rs
                   }
-- | ...
mvCursorUp :: VexZipper a -> VexZipper a
mvCursorUp vz = case (iPrev vz , vPrev vz) of
   ([],[]) -> vz
   ([],v:vs) -> let (Geo _x _y _z) = cGeo vz
                    nx = _x `min` (NL.length v - 1)
                    ny = _y - 1
                    (xs,ci:rs) = NL.splitAt nx v
                    nz = NL.length ci - 1
                    newRowRight = NL.fromList $ iPrev vz ++ cItem vz : iNext vz
                    newRow = foldr (NL.<|) (newRowRight NL.:| hNext vz) (hPrev vz)
                in VexZipper { cItem = NL.last ci
                             , cGeo  = Geo nx ny nz
                             , vPrev = vs
                             , vNext = newRow : vNext vz
                             , hPrev = xs
                             , hNext = rs
                             , iPrev = NL.init ci
                             , iNext = []
                             }
   (is, _) -> VexZipper { cItem = head $ iPrev vz
                        , cGeo  = geoZpred $ cGeo vz
                        , vPrev = vPrev vz
                        , vNext = vNext vz
                        , hPrev = hPrev vz
                        , hNext = hNext vz
                        , iPrev = tail $ iPrev vz
                        , iNext = cItem vz : iNext vz
                        }
--
mvCursorDown :: VexZipper a -> VexZipper a
mvCursorDown vz = case (iNext vz , vNext vz) of
   ([],[]) -> vz
   ([],v:vs) -> let (Geo _x _y _z) = cGeo vz
                    nx = _x `min` (NL.length v - 1)
                    ny = _y + 1
                    nz = 0
                    (xs,ci:rs) = NL.splitAt nx v
                    newRowRight = NL.fromList $ iPrev vz ++ cItem vz : iNext vz
                    newRow = foldr (NL.<|) (newRowRight NL.:| hNext vz) (hPrev vz)
                in VexZipper { cItem = NL.head ci
                             , cGeo  = Geo nx ny nz
                             , vPrev = newRow : vPrev vz -- !!!
                             , vNext = vs
                             , hPrev = xs
                             , hNext = rs
                             , iPrev = []
                             , iNext = NL.tail ci
                             }
   (is, _) -> VexZipper { cItem = head $ iNext vz
                        , cGeo  = geoZsucc $ cGeo vz
                        , vPrev = vPrev vz
                        , vNext = vNext vz
                        , hPrev = hPrev vz
                        , hNext = hNext vz
                        , iPrev = cItem vz : iPrev vz
                        , iNext = tail $ iNext vz
                        }
--
data Geo = Geo {gx :: Int, gy :: Int, gz :: Int}
         deriving (Eq, Ord, Show)

geoXsucc :: Geo -> Geo
geoXsucc (Geo x y z) = Geo (x+1) y z
geoXpred :: Geo -> Geo
geoXpred (Geo x y z) = Geo (x-1) y z
geoYsucc :: Geo -> Geo
geoYsucc (Geo x y z) = Geo x (y+1) z
geoYpred :: Geo -> Geo
geoYpred (Geo x y z) = Geo x (y-1) z
geoZsucc :: Geo -> Geo
geoZsucc (Geo x y z) = Geo x y (z+1)
geoZpred :: Geo -> Geo
geoZpred (Geo x y z) = Geo x y (z-1)
