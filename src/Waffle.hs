{-# LANGUAGE OverloadedStrings #-}
-- SDL2
import qualified SDL

-- 定義 2D vector 用
-- 例如, (V2 x y) 在 cairo 中被用來表示座標
import Linear.V2 (V2(..))

-- 用來橋接 SDL 和 cairo 用的
import SDL.Cairo (createCairoTexture)

-- 畫圖用的小工具都是定義在這
-- 包括一個用來表示"維度"的資料結構： Dim
-- Dim 的 constructor 是 D
-- D 後面要給四個參數分別表示: X Y W H
import SDL.Cairo.Canvas

-- 控制程式邏輯要用的
import Control.Concurrent (threadDelay)
import Control.Monad (unless)
import Control.Monad.Fix (fix)
--

-- 無限長的一串空字串
ctx :: [String]
ctx = "" : [ x | x <- ctx]

-- 玩家資訊
data Player = Player
   { hp :: Int, mp :: Int
   , lX :: Int, lY :: Int
   }
   deriving (Eq,Show)

main :: IO ()
main = do
   -- SDL 初始化
   SDL.initialize [SDL.InitEverything]
   -- 從 SDL 中創造一個 window (用 winConfig 當做設定)
   -- 產生一個 renderer 並且將其崁入 window 上 (用 rdrConfig 為設定)
   -- P.S. 這裡的 renderer 是類似繪圖影擎的東西, 被稱為 *SDL rendering device*
   -- P.S. winConfig 和 rdrConfig 的定義寫在最下面
   window   <- SDL.createWindow "Hello!" winConfig
   renderer <- SDL.createRenderer window (-1) rdrConfig
   -- 創造一個 texture (相當於是畫布的東西)
   -- 然後把這個畫布貼到 renderer 之上
   texture  <- createCairoTexture renderer (V2 640 480)
   -- 設定初始玩家資訊
   let player = Player 50 10 15 15
   -- 這裡開始定義程式的 main loop
   -- mainLoop 是一個 a -> a 的 lambda function
   -- mainLoop 中定義程式邏輯的「執行一步」是要做什麼
   let mainLoop = \loop -> do
         threadDelay 20000
         -- 在 texture 上把東西畫出來
         -- 下述三個 functions 都定義在下面
         -- cairo 座標軸是左上為 (0,0) 往右是 +X 往下是 +Y
         showWindowBg   texture
         showPlayerInfo texture player
         showConcole    texture
         -- [顯示相關] 將 texture 目前的結果傳遞給 renderer
         SDL.copy renderer texture Nothing Nothing
         -- [顯示相關] 要求 renderer 顯示與更新畫面
         SDL.present renderer
         -- [鍵盤事件] 倒出目前所有的 events :: [Event]
         events <- SDL.pollEvents
         -- [鍵盤事件] 判斷是否 「有」 *ESC被按下去* 的事件
         -- P.S. null :: [a] -> Bool 會回傳一個 list 是否為 []
         let qPressed = not $ null $ filter eventIsESCPress events
         -- 利用鍵盤事件來中斷程式
         -- 也就是用 unless 來 break 出這個 mainLoop
         unless qPressed loop
   -- 利用 fix :: (a -> a) -> a 來無限地執行 mainLoop
   fix $ mainLoop
--
-- ########################################################
-- withCanvas :: Texture -> Canvas a -> IO a
showWindowBg :: SDL.Texture -> IO ()
showWindowBg tx = withCanvas tx $ do
   -- 重製背景
   background $ gray 220
   -- 繪製狀態列背景
   fill $ blue 255 !@ 64
   noStroke
   -- 繪製方塊, D 是 Dim 的 constructor
   -- 後面四個參數分別表示: X Y W H
   rect $ D 0 0 640 100
--
showPlayerInfo :: SDL.Texture -> Player -> IO ()
showPlayerInfo tx p = withCanvas tx $ do
   -- 設定 字體 大小 粗體 斜體
   textFont $ Font "Hiragino Maru Gothic ProN" 20 False False
   -- 設定顏色
   fill $ gray 0
   -- 繪製文字. P.S. (V2 30 40) 表示座標 (30,40)
   text ("HP:[" ++ (show $ hp p) ++ "]  MP:["++ (show $ mp p) ++"]")
      (V2 30 40)
   text ("X/Y:[" ++ (show $ lX p) ++ "/"++ (show $ lY p) ++"]")
      (V2 400 40)
--
-- 繪製中央文字顯示區
showConcole :: SDL.Texture -> IO ()
showConcole tx = withCanvas tx $ do
   textFont $ Font "Hiragino Maru Gothic ProN" 20 False False
   fill $ gray 0
   let lctx = take 10 ctx
       delta = 30
       initY = 150
       tab   = 25
       short = \x -> "> " ++ (take (28 `min` length x) x)
   text (short $ lctx !! 0) (V2 tab (initY + 0 * delta))
   text (short $ lctx !! 1) (V2 tab (initY + 1 * delta))
   text (short $ lctx !! 2) (V2 tab (initY + 2 * delta))
   text (short $ lctx !! 3) (V2 tab (initY + 3 * delta))
   text (short $ lctx !! 4) (V2 tab (initY + 4 * delta))
   text (short $ lctx !! 5) (V2 tab (initY + 5 * delta))
   text (short $ lctx !! 6) (V2 tab (initY + 6 * delta))
   text (short $ lctx !! 7) (V2 tab (initY + 7 * delta))
   text (short $ lctx !! 8) (V2 tab (initY + 8 * delta))
   text (short $ lctx !! 9) (V2 tab (initY + 9 * delta))
--
-- ########################################################
--
eventIsESCPress ::SDL.Event -> Bool
eventIsESCPress evt = pressKey $ SDL.eventPayload evt
--
-- 判斷是否滿足某某(離開)條件
pressKey :: SDL.EventPayload -> Bool
pressKey (SDL.KeyboardEvent kEvtData) =
   -- 檢查 KeyboardEvent 是否為 Pressed
   let kPressed = SDL.keyboardEventKeyMotion kEvtData == SDL.Pressed
   -- 判斷 KeyboardEvent 到底詳細來說是由哪個按鍵觸發的
   in case (SDL.keysymKeycode $ SDL.keyboardEventKeysym kEvtData) of
         -- SDL.KeycodeW -> True && kPressed
         -- SDL.KeycodeS -> True && kPressed
         -- SDL.KeycodeA -> True && kPressed
         -- SDL.KeycodeD -> True && kPressed
         -- 按下 ESC 會回傳 True
         SDL.KeycodeEscape -> True && kPressed
         -- 按下其他按鍵或是其他事件會回傳 false
         _ -> False
pressKey _ = False
--
-- ########################################################
--
winConfig = SDL.defaultWindow
   { SDL.windowPosition = SDL.Centered
   , SDL.windowInitialSize = V2 640 480
   }

rdrConfig = SDL.RendererConfig
   { SDL.rendererType = SDL.AcceleratedVSyncRenderer
   , SDL.rendererTargetTexture = True
   }
