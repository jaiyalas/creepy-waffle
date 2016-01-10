* Session 是 state machine
  + St generator
  + M is real-timed world



n :: Num a => a
n = 1 :: Int



+ Session M S 的 M 是表示
  + 某個"包含某種現實時間的世界"的 monad
  + 而非關 wire 的內部狀態 monad
+ Session M S 的 S 是表示
  + 某種"狀態" which 會隨著 step 而改變
