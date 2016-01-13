# SDL2 Examples

以 [sdl2 的 haskell binding](https://hackage.haskell.org/package/sdl2) 實作 [lazyfoo.net](http://lazyfoo.net/tutorials/SDL/) 中之課程題目。  
(其中部分在 sdl2 自己的 [examples/lazyfoo](https://github.com/haskell-game/sdl2/tree/master/examples/lazyfoo) 中已經有實作。)

## 目標

+ 共計有 55 個課程 (lessions)，目標僅練習其中 34 個
+ 優先針對繪製 (render) 和顯示 (display) 的部分實作

## 執行方式

```bash
> cabal configure
> cabal build
> cabal run #n
```

其中 `#n` 是 lesson 的代號。

## 課程清單

### 視覺/基礎

+ [X] Lesson 01 - Hello SDL
+ [X] Lesson 02 - Getting an Image on the Screen
+ [X] Lesson 03 - Event Driven Programming
+ [X] Lesson 04 - Key Presses
+ [X] Lesson 05 - Optimized Surface Loading and Soft Stretching
+ [ ] Lesson 07 - Texture Loading and Rendering
+ [ ] Lesson 08 - Geometry Rendering
+ [ ] Lesson 09 - The Viewport
+ [ ] Lesson 10 - Color Keying
+ [ ] Lesson 11 - Clip Rendering and Sprite Sheets
+ [ ] Lesson 12 - Color Modulation
+ [ ] Lesson 13 - Alpha Blending
+ [ ] Lesson 14 - Animated Sprites and Vsync
+ [ ] Lesson 15 - Rotation and Flipping
+ [ ] Lesson 16 - True Type Fonts
+ [ ] Lesson 17 - Mouse Events
+ [ ] Lesson 18 - Key States
+ [ ] Lesson 30 - Scrolling
+ [ ] Lesson 31 - Scrolling Backgrounds
+ [ ] Lesson 38 - Particle Engines
+ [ ] Lesson 39 - Tiling
+ [ ] Lesson 40 - Texture Manipulation
+ [ ] Lesson 41 - Bitmap Fonts
+ [ ] Lesson 42 - Texture Streaming
+ [ ] Lesson 43 - Render to Texture

### 進階/其他

+ [ ] Lesson 21 - Sound Effects and Music
+ [ ] Lesson 22 - Timing
+ [ ] Lesson 23 - Advanced Timers
+ [ ] Lesson 24 - Calculating Frame Rate
+ [ ] Lesson 25 - Capping Frame Rate
+ [ ] Lesson 26 - Motion
+ [ ] Lesson 27 - Collision Detection
+ [ ] Lesson 28 - Per-pixel Collision Detection
+ [ ] Lesson 29 - Circular Collision Detection

### 不打算做

+ Lesson 06 - Extension Libraries and Loading Other Image Formats
+ Lesson 19 - Gamepads and Joysticks
+ Lesson 20 - Force Feedback
+ Lesson 32 - Text Input and Clipboard Handling
+ Lesson 33 - File Reading and Writing
+ Lesson 34 - Audio Recording
+ Lesson 35 - Window Events
+ Lesson 36 - Multiple Windows
+ Lesson 37 - Multiple Displays
+ Lesson 44 - Frame Independent Movement
+ Lesson 45 - Timer Callbacks
+ Lesson 46 - Multithreading
+ Lesson 47 - Semaphores
+ Lesson 48 - Atomic Operations
+ Lesson 49 - Mutexes and Conditions
+ Lesson 50 - SDL and OpenGL 2
+ Lesson 51 - SDL and Modern OpenGL
+ Lesson 52 - Hello Mobile
+ Lesson 53 - Extensions and Changing Orientation
+ Lesson 54 - Touches
+ Lesson 55 - Multitouch
