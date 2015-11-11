{-# LANGUAGE OverloadedStrings #-}

module CreepyWaffle.SimpleMapLoader
   (
   readMap
   )where
--
import System.IO
--
readMap :: String -> IO [String]
readMap fname = do
   handle <- openFile fname ReadMode
   (width,height) <- (read :: String -> (Int,Int)) <$> hGetLine handle
   ms <- readCxt handle height []
   return $ map (take width) $ reverse ms
--
-- ########################################################
--
readCxt :: Handle -> Int -> [[Char]] -> IO [[Char]]
readCxt h 0 xs = return xs
readCxt h n xs = do
   rs <- readCxt h (n-1) xs
   line <- hGetLine h
   return $ line : rs
