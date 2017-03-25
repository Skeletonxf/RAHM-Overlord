local typewriter = require("typewriter")
local screenY = 900

local background
local startGameWriter
local motionImages = {}
local i = love.graphics.newImage("mountainVanBScaled.png")
motionImages[1] = {i=i,iw=i:getWidth(),ih=i:getHeight()}
function love.load()
  love.window.setMode(1500, screenY)
  -- zerobrane debugging
  background = love.graphics.newImage("VanB.png")
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setLineWidth(5)
  love.window.setTitle("Tour of the Americas")
  startGameWriter = typewriter.new[[
  You are an overlord from the planet It's the year 2050. Memes have become the world currency, Donald Trump has entered his fifth term as president. There is snow way you can let this happen so you try taking over the world.

You want drugs. And you want them now.

Tis The Ski-Son To Be Jolly, Fa La La La La...
  ]]
  startGameWriter.specialDelays={["."]=0.12,["-"]=0.08}

  love.graphics.setNewFont(28)
end

local hurt = {}
-- add a rectangle with x and y being bottom left position in screen
function hurt.add(xPos,yPos,width,height)
  hurt[#hurt+1] = {x=xPos,y=screenY-yPos-height-100,w=width,h=height}
end
hurt.add(550,0,200,400)

local collisions = {}
function collisions.add(xPos,yPos,width,height)
  collisions[#collisions+1] = {x=xPos,y=screenY-yPos-height-100,w=width,h=height}
end
--collisions.add(750,0,200,200)

local visuals = {}

function collisions.addImage(i,x,y,w,h)
  if i == 1 then
    visuals[#visuals+1] = {i=motionImages[i],x=x,y=screenY-y-h-100,w=w,h=h}
    collisions.add(x,y,w,h/3)
    collisions.add(x+(w/5),y+(h/3),3*w/5,h/3)
    collisions.add(x+(w/3),y+(2*h/3),w/3,h/3)
  end
end
collisions.addImage(1,1050,0,200,200)

local scroll = 0

local player = {x=100,h=150,w=80,y=300,dy=0}

function love.draw()
  -- motionless drawing
  love.graphics.setColor(255,255,255)
  love.graphics.draw(background)
  love.graphics.setColor(0,0,0)
  love.graphics.printf(startGameWriter:getText() or "",0,0,1500)

  -- moving screen drawing
  love.graphics.push()
  love.graphics.translate(-scroll,0)
  -- ipairs skips the hash parts of the table and just does the numerical indexes
  love.graphics.setColor(255,0,0)
  for key, rectangle in ipairs(hurt) do
    love.graphics.rectangle("line",rectangle.x,rectangle.y,rectangle.w,rectangle.h)
  end
  for key, image in ipairs(visuals) do
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(image.i.i,image.x,image.y,0,
      image.w/motionImages[1].iw, image.h/motionImages[1].ih)
  end
  for key, rectangle in ipairs(collisions) do
    love.graphics.setColor(0,0,0,50)
    love.graphics.rectangle("line",rectangle.x,rectangle.y,rectangle.w,rectangle.h)
  end
  love.graphics.setColor(0,0,0,255)
  love.graphics.rectangle("line",player.x,player.y,player.w,player.h)
  love.graphics.pop()
end

-- dt is time passed since last frame in seconds
function love.update(dt)
  startGameWriter:update(dt)

  if dt > 0.5 then return end

  if love.keyboard.isDown(",") then
    scroll = scroll + 175*dt
  elseif love.keyboard.isDown(".") then
    scroll = scroll - 175*dt
  else
    scroll = scroll + 50*dt
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

  local playerIsJumping = false

  local left = love.keyboard.isDown("a")
  local right = love.keyboard.isDown("d")
  if left and right then
    left = false
    right = false
  end
  if left then
    player.x = player.x - 450*dt
  end
  if right then
    player.x = player.x + 450*dt
  end

  if player.y <= 650 and (not playerCanJump) and (not playerOnRectangle) then
    player.dy = player.dy - 250*dt
  else
    if not playerOnRectangle then
      player.y = 650
    end
    player.dy = 0
  end

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
          if gapOnLeftSide < 10 then
            player.x = collision.x - player.w
          elseif gapOnRightSide < 10 then
            player.x = collision.x + collision.w
          end
        end
      end
    end
  end

  if love.keyboard.isDown("w") and playerCanJump then
    player.dy = 70
    playerIsJumping = true
  end

  player.y = player.y - player.dy
  player.dy = player.dy * 0.95
end
