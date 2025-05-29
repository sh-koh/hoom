module Hoom.Core where

import Control.Monad (unless)
import Hoom.Player
import Raylib.Core
import Raylib.Core.Shapes
import Raylib.Core.Text
import Raylib.Types
import Raylib.Util.Colors

gameLoop :: Player -> IO ()
gameLoop plr = do
  shouldClose <- windowShouldClose
  quit <- isKeyDown (quitGame defaultKeybindings)

  unless (shouldClose || quit) $ do
    clearBackground white
    beginDrawing

    plr' <- movePlayer defaultKeybindings plr

    -- "UI"
    drawText "Esc to quit." 10 10 20 black
    drawText "WASD to move." 10 40 20 black
    drawText "Shift to dash." 10 70 20 black

    -- Debug
    drawText "Debug:" 10 470 20 black
    drawText ("pos=" ++ show plr.position) 10 500 15 black
    drawText ("vel=" ++ show plr.velocity) 10 515 15 black
    drawText ("spd=" ++ show plr.speed) 10 530 15 black
    drawText ("accel=" ++ show plr.acceleration) 10 545 15 black
    drawText ("spd_cap=" ++ show plr.speedCap) 10 560 15 black
    drawText ("fric=" ++ show plr.friction) 10 575 15 black

    let Vector2 px py = position plr'
    drawText plr.name (round px - 28) (round py - 45) 16 blue
    drawCircle (round px) (round py) 20 red

    endDrawing

    gameLoop plr'
