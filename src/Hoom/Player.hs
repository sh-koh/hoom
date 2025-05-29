module Hoom.Player where

import Control.Monad (unless)
import Raylib.Core
import Raylib.Core.Shapes
import Raylib.Core.Text
import Raylib.Internal
import Raylib.Types
import Raylib.Util.Math

data Keybindings = Keybindings
  { moveUp :: KeyboardKey,
    moveDown :: KeyboardKey,
    moveLeft :: KeyboardKey,
    moveRight :: KeyboardKey,
    quitGame :: KeyboardKey
  }

defaultKeybindings :: Keybindings
defaultKeybindings =
  Keybindings
    { moveUp = KeyW,
      moveDown = KeyS,
      moveLeft = KeyA,
      moveRight = KeyD,
      quitGame = KeyEscape
    }

data Player = Player
  { name :: String,
    position :: Vector2,
    velocity :: Vector2,
    speed :: Float,
    acceleration :: Float,
    friction :: Float,
    speedCap :: Float,
    sprite :: Rectangle
  }

player :: Player
player =
  Player
    { name = "Shakoh",
      position = Vector2 100 100,
      velocity = Vector2 0 0,
      speed = 5.0,
      acceleration = 0.2,
      friction = 0.9,
      speedCap = 10.0,
      sprite =
        Rectangle
          { rectangle'x = 100,
            rectangle'y = 100,
            rectangle'width = 50,
            rectangle'height = 50
          }
    }

movePlayer :: Keybindings -> Player -> IO Player
movePlayer Keybindings {..} (Player {..}) = do
  [up, down, left, right] <- mapM isKeyDown [moveUp, moveDown, moveLeft, moveRight]
  let dx = (if right then speed else 0) - (if left then speed else 0)
      dy = (if down then speed else 0) - (if up then speed else 0)
      direction = Vector2 dx dy
      dLen = vecLength direction
      movement =
        if dLen /= 0
          then direction |/ dLen |* speed
          else Vector2 0 0
      cappedVelocity = clampVectorLength speedCap ((velocity |+| (direction |* acceleration)) |* friction)
  return $
    case position of
      Vector2 _ _ ->
        Player
          { name = name,
            position = position |+| movement |+| cappedVelocity,
            velocity = cappedVelocity,
            speed = speed,
            acceleration = acceleration,
            friction = friction,
            speedCap = speedCap,
            sprite = sprite
          }
  where
    vecLength (Vector2 x y) = sqrt (x * x + y * y)
    clampVectorLength maxLen v =
      let len' = vecLength v
       in if len' > maxLen
            then (v |/ len') |* maxLen
            else v
