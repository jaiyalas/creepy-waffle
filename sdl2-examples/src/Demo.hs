module Demo where
--
import Lesson01
import Lesson02
import SDL
import Linear.V2

import System.Environment
--
main = do
   args <- getArgs
   let i = (read $ head (args++["0"])) :: Int
   case i of
      1 -> lesson01
      2 -> lesson02
      _ -> print $ "Lesson " ++ (show i) ++ " is undefined"
   return ()
