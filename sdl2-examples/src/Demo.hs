module Demo where
--
import Lesson01
import Lesson02
import Lesson03
import Lesson04
import Lesson05
import Lesson07
import Lesson08
import Lesson09
import Lesson10
import Lesson11
--
import System.Environment
--
main = do
   args <- getArgs
   let i = (read $ head (args++["0"])) :: Int
   case i of
      1  -> lesson01
      2  -> lesson02
      3  -> lesson03
      4  -> lesson04
      5  -> lesson05
      7  -> lesson07
      8  -> lesson08
      9  -> lesson09
      10 -> lesson10
      11 -> lesson11
      _ -> print $ "Lesson " ++ (show i) ++ " is undefined"
   return ()
