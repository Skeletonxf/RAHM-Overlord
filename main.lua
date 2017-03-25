local typewriter = require("typewriter")
local game = require("game")
local screenY = 900

local player = {x=100,h=150,w=80,y=300,dy=0}

local background
local startGameWriter
local motionImages = {}
local i = love.graphics.newImage("mountainVanBScaled.png")
motionImages[1] = {i=i,iw=i:getWidth(),ih=i:getHeight()}

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
  game.giveTables(collisions, player)
end


function collisions.addImage(i,x,y,w,h)
  if i == 1 then
    visuals[#visuals+1] = {i=motionImages[i],x=x,y=screenY-y-h-100,w=w,h=h}
    collisions.add(x,y,w,h/3)
    collisions.add(x+(w/5),y+(h/3),3*w/5,h/3)
    collisions.add(x+(w/3),y+(2*h/3),w/3,h/3)
  end
end
collisions.addImage(1,1050,0,200,200)

function love.draw()
  -- motionless drawing
  love.graphics.setColor(255,255,255)
  love.graphics.draw(background)
  love.graphics.setColor(0,0,0)
  love.graphics.printf(startGameWriter:getText() or "",0,0,1500)

  -- moving screen drawing
  love.graphics.push()
  love.graphics.translate(-game.scroll,0)
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

  game.update(dt)
end
