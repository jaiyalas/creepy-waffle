module Config where
--
import qualified SDL as SDL
import Linear.V2 (V2(..))
--
--
winW  = 640
winH  = 480
winV2 = V2 winW winH
--
winConfig = SDL.defaultWindow
   { SDL.windowPosition = SDL.Centered
   , SDL.windowInitialSize = V2 winW winH
   }

rdrConfig = SDL.RendererConfig
   { SDL.rendererType = SDL.AcceleratedVSyncRenderer
   , SDL.rendererTargetTexture = True
   }
