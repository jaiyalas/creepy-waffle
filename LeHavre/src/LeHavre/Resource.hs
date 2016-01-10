module Resource where
--
type Money  = Int
type Food   = Int
type Energy = Int
--
data Good = Cattle
          | Fish
          | Grain
          --
          | Wood
          | Coal
          | Clay
          | Iron
          | Hides
          --
          | Loan
          | Coin
          deriving (Show, Eq)
--
-- ##### ##### ##### ##### ##### ##### --
--
data AdvGood = Meat
             | SmokedFish
             | Bread
             --
             | Charcoal
             | Coke
             | Brick
             | Steel
             | Leather
             deriving (Show, Eq)
--
class PowerGen a where
   canGen   :: a -> Bool
   genPower :: a -> Energy
instance PowerGen Good where
   canGen Wood = True
   canGen Coal = True
   canGen _    = False
   genPower Wood = 1
   genPower Coal = 3
   genPower _    = 0
instance PowerGen AdvGood where
   canGen Charcoal = True
   canGen _        = False
   genPower Charcoal = 10
   genPower _        = 0
--
-- ##### ##### ##### ##### ##### ##### --
--
class Shippable a where
   ship :: a -> Money
instance Shippable Good where
   ship Cattle = 3
   ship Fish   = 1
   ship Grain  = 1
   ship Wood   = 1
   ship Coal   = 3
   ship Clay   = 1
   ship Iron   = 2
   ship Hides  = 2
   ship Loan   = 4
   ship Coin   = 1
instance Shippable AdvGood where
   ship Meat       = 2
   ship SmokedFish = 2
   ship Bread      = 3
   ship Charcoal   = 2
   ship Coke       = 5
   ship Brick      = 2
   ship Steel      = 8
   ship Leather    = 4
--
-- ##### ##### ##### ##### ##### ##### --
--
class Eatable a where
   isEatable :: a -> Bool
   toFood    :: a -> Food
instance Eatable Good where
   isEatable Fish = True
   isEatable Coin = True
   isEatable _    = False
   toFood Fish = 1
   toFood Coin = 1
   toFood _    = 0
instance Shippable AdvGood where
   isEatable Meat       = True
   isEatable SmokedFish = True
   isEatable Bread      = True
   isEatable _          = False
   toFood Meat       = 3
   toFood SmokedFish = 2
   toFood Bread      = 2
   toFood _          = 0
--
