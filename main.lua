local typewriter = require("typewriter")
local game = require("game")
local screenY = 900

local player = {x=1000,h=150,w=80,y=300,dy=0}

local background
local startGameWriter
local motionImages = {}
local i = love.graphics.newImage("mountainVanBScaled.png")
motionImages[1] = {i=i,iw=i:getWidth(),ih=i:getHeight()}
i = love.graphics.newImage("skyscaperTall.png")
motionImages[2] = {i=i,iw=i:getWidth(),ih=i:getHeight()}
i = love.graphics.newImage("skyscaperWide.png")
motionImages[3] = {i=i,iw=i:getWidth(),ih=i:getHeight()}

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
local visuals = {}

local backgrounds = {}
function backgrounds.nextBackground()
  background = love.graphics.newImage("SanFranB.png")
end

function love.load()
  love.window.setMode(1500, screenY)
  -- zerobrane debugging
  background = love.graphics.newImage("VanB.png")
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  love.graphics.setLineWidth(5)
  love.window.setTitle("Tour of the Americas")
  startGameWriter = typewriter.new(require("gametext"))
  startGameWriter.specialDelays={["."]=0.12,["-"]=0.08}
  love.graphics.setNewFont(28)
  game.giveTables(collisions, player, backgrounds)
end


function collisions.addImage(i,x,y,w,h)
  if i == 1 then
    visuals[#visuals+1] = {i=motionImages[i],x=x,y=screenY-y-h-100,w=w,h=h}
    collisions.add(x,y,w,h/3)
    collisions.add(x+(w/5),y+(h/3),3*w/5,h/3)
    collisions.add(x+(w/3),y+(2*h/3),w/3,h/3)
  end
  if i == 2 or i == 3 then
    visuals[#visuals+1] = {i=motionImages[i],x=x,y=screenY-y-h-100,w=w,h=h}
    collisions.add(x,y,w,h)
  end
end
collisions.addImage(1,1050,0,200,200)
collisions.addImage(1,1350,0,100,150)
collisions.addImage(1,1550,0,250,450)
collisions.addImage(1,1700,0,100,350)
collisions.addImage(1,1950,0,200,550)
collisions.addImage(1,2450,0,250,550)
collisions.addImage(1,2650,0,100,350)
collisions.addImage(1,2750,0,150,250)
collisions.addImage(2,3000,0,100,400)
collisions.addImage(3,3300,0,100,200)
collisions.addImage(2,3500,0,100,400)
collisions.addImage(3,3800,0,300,300)
collisions.addImage(2,4300,0,100,600)
collisions.addImage(3,4600,0,300,200)
collisions.addImage(2,5100,0,100,500)

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
      image.w/image.i.iw, image.h/image.i.ih)
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
