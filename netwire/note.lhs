+ S 是時間狀態
+ Session 是一個時間狀態產生器, 每執行一次就產生一個新的時間狀態(S)
+ 時間狀態 S 可以是任意的狀態
+ 如果 S 是跟時間有關的話, 則可以將限制為 Timed
   + 一個 type, S, 被稱為 timed value 如果 我們可以將 S 轉換成某個 T <= Real T

Timed NominalDiffTime () :=
  S = ()
  T = NominalDiffTime

+ Session M S 的 M 是表示
  + 某個"包含某種現實時間的世界"的 monad
  + 而非關 wire 的內部狀態 monad
+ Session M S 的 S 是表示
  + 某種"狀態" which 會隨著 step 而改變

+ 這種"狀態"典型的例子是 On/Off (Bool)
   每次 step 以後會 switch 前一個狀態

另一種"狀態"的例子是 "時間"
時間有很多種表示法
最基本的是用某種 real number 來表示 UTC 之類的大宇宙時間(絕對時間)
另一種方法可以用時間間距來表示
我們可以定義那個間距的基準點是上一次 step 亦或是某個固定的點
前者就是 Netwire 裡面內建的 Clock
後者就會變成是類似於 UTC 這樣的東西

當我們想要用這樣的"狀態"來描述例如說時間時
我們就需要說這個 S 可以被轉換成某個 Real T
這很合理因為"狀態" S 現在是表示某種時間間距或是絕對時間
