module Hoom (hoom) where

import Control.Monad (void)
import Hoom.Core (gameLoop)
import Hoom.Networking
import Hoom.Player (player)
import Raylib.Core
-- import Raylib.Core.Audio
-- import Raylib.Core.Camera
-- import Raylib.Core.Models
import Raylib.Core.Shapes
import Raylib.Core.Text
-- import Raylib.Core.Textures
import Raylib.Internal
-- import Raylib.Internal.Foreign
import Raylib.Types
-- import Raylib.Types.Core
-- import Raylib.Types.Core.Audio
-- import Raylib.Types.Core.Camera
-- import Raylib.Types.Core.Models
-- import Raylib.Types.Core.Text
-- import Raylib.Types.Core.Textures
-- import Raylib.Types.Util.GUI
-- import Raylib.Types.Util.RLGL
-- import Raylib.Util
-- import Raylib.Util.Camera
import Raylib.Util.Colors

-- import Raylib.Util.GUI
-- import Raylib.Util.GUI.Styles
-- import Raylib.Util.Lenses
-- import Raylib.Util.Math
-- import Raylib.Util.RLGL

hoom :: IO ()
hoom = do
  let windowWidth = 800
      windowHeight = 600
      title = "Hoom"
      fps = 60
  window <- initWindow windowWidth windowHeight title
  setTargetFPS fps
  pollInputEvents
  gameLoop player
  closeWindow $ Just window
