local game = {}

local collisions
local player
local backgrounds
local hurt

function game.giveTables(c, p, b, h)
  collisions = c
  player = p
  backgrounds = b
  hurt = h
end

local scroll = 0
local scrollRate = 50

local jumpPhases = {3000,7500,10000000000000000000}
local jumps = 0

function game.update(dt)
  if love.keyboard.isDown(",") then
    scroll = scroll + 600*dt
  elseif love.keyboard.isDown(".") then
    scroll = scroll - 600*dt
  else
    if not love.keyboard.isDown("o") then
      scrollRate = (300+(((scroll^(1/2))+100)))*dt
      scroll = scroll + scrollRate --Rate*dt
    end
  end
  game.scroll = scroll

  if scroll > jumpPhases[jumps+1]-750 then
    jumps = jumps + 1
    backgrounds.nextBackground()
  end

  local playerCanJump = player.y == 650
  local playerOnRectangle = false

  for key, collision in ipairs(collisions) do
    if ((player.y + player.h) > collision.y) then
      -- player vertically in line with a collision
      if ((player.x + player.w) > collision.x and player.x < (collision.x + collision.w)) then
        -- player inside a collision
        local differenceBetweenTopOfRectangle = math.abs((player.y + player.h) - collision.y)
        if differenceBetweenTopOfRectangle < 20 then
          playerCanJump = true
          playerOnRectangle = true
        end
      end
    end
  end

  if not love.keyboard.isDown("o") then
    for key, hurt in ipairs(hurt) do
      if ((player.y + player.h) > hurt.y) then
        -- player vertically in line with a collision
        if ((player.x + player.w) > hurt.x and player.x < (hurt.x + hurt.w)) then
          return "CACTI EVEN HURT OVERLOARDS"
        end
      end
    end
  end

  local playerIsJumping = false

  local left = love.keyboard.isDown("a")
  local right = love.keyboard.isDown("d")
  if left and right then
    left = false
    right = false
  end
  if left then
    player.x = player.x - 550*dt
  end
  if right then
    player.x = player.x + 550*dt
  end

  if player.y <= 650 and (not playerCanJump) and (not playerOnRectangle) then
    player.dy = player.dy - 250*dt
  else
    if not playerOnRectangle then
      player.y = 650
    end
    player.dy = 0
  end

  local canMovePlayerRight = true

  if not love.keyboard.isDown("o") then
    for key, collision in ipairs(collisions) do
      if ((player.y + player.h) > collision.y) then
        -- player vertically in line with a collision
        if ((player.x + player.w) > collision.x and player.x < (collision.x + collision.w)) then
          -- player inside a collision
          local differenceBetweenTopOfRectangle = math.abs((player.y + player.h) - collision.y)

          local gapOnLeftSide = (player.x + player.w) - collision.x
          local gapOnRightSide = player.x - (collision.x + collision.w)

          if gapOnLeftSide > 0 then
            -- player in left wall
          end
          if gapOnRightSide < 0 then
            -- player in right wall
          end

          if differenceBetweenTopOfRectangle < 60 then
            player.y = collision.y - player.h + 1
            player.dy = 0
            -- TODO fix jerking
          else
            if gapOnLeftSide < collision.w/2 then
              player.x = collision.x - player.w
              canMovePlayerRight = false
            elseif gapOnRightSide < collision.w/2 then
              player.x = collision.x + collision.w
              canMovePlayerRight = false
            end
          end
        end
      end
    end
  end

  if canMovePlayerRight and (not left) then
    player.x = player.x + scrollRate
  end

  if love.keyboard.isDown("w") and playerCanJump then
    player.dy = 70
    playerIsJumping = true
  end

  player.y = player.y - player.dy
  player.dy = player.dy * 0.95

  if love.keyboard.isDown("o") then
    player.x = scroll + 750
  end

  if player.x < scroll then
    return "YOU DIED"
  end
end
return game