local game = {}

local collisions
local player
local backgrounds
local hurt
local cars

function game.giveTables(c, p, b, h, ca)
  collisions = c
  player = p
  backgrounds = b
  hurt = h
  cars = ca
end

local scroll = 0
local scrollRate = 50

local jumpPhases = {500,3000,7500,22500,25500,30050,10000000000000000000}
local jumps = 1

function game.softReset()
  scroll = jumpPhases[jumps] - 500
  player.x = scroll + 300
  for k, car in ipairs(cars) do
    car:reset()
  end
end

function game.update(dt)
  if love.keyboard.isDown(".") then
    scroll = scroll + 600*dt
  elseif love.keyboard.isDown(",") then
    scroll = scroll - 600*dt
  elseif love.keyboard.isDown("l") then
    scroll = scroll + 4800*dt
  elseif love.keyboard.isDown("k") then
    scroll = scroll - 4800*dt
  else
    if not love.keyboard.isDown("o") then
      scrollRate = (300+(((scroll^(1/2))+100)))*dt
      scroll = scroll + scrollRate
    end
  end

  if love.keyboard.isDown("o") and love.keyboard.isDown("4") then
    scroll = 30000
  end

  game.scroll = scroll

  if scroll > jumpPhases[jumps+1]-750 then  
    jumps = jumps + 1
    backgrounds.nextBackground()
  end

  game.jumps = jumps

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
    for key, car in ipairs(cars) do
      car:update(dt,(car.x > game.scroll-750) and (car.x < game.scroll+2250), (car.x > game.scroll-750))
    end
  end

  if not love.keyboard.isDown("o") then
    for key, collision in ipairs(collisions) do
      if ((player.y + player.h) > collision.y) then
        -- player vertically in line with a collision
        if ((player.x + player.w) > collision.x and player.x < (collision.x + collision.w)) then
          -- player inside a collision
          local differenceBetweenTopOfRectangle = math.abs((player.y + player.h) - collision.y)

          local gapOnLeftSide = (player.x + player.w) - collision.x
          local gapOnRightSide = player.x - (collision.x + collision.w)

          if collision.f then
            local swap = gapOnLeftSide
            gapOnLeftSide = gapOnRightSide
            gapOnRightSide = swap
          end

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