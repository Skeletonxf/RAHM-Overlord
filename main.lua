local typewriter = require("typewriter")
local game = require("game")
local car = require("car")
local inspect = require "inspect"
local cars = {}
local screenY = 900

local player = {x=1000,h=150,w=80,y=300,dy=0}

local background
local startGameWriter
local motionImages = {}

local function addImage(file)
  local i = love.graphics.newImage(file)
  motionImages[#motionImages+1] = {i=i,iw=i:getWidth(),ih=i:getHeight()}
end
addImage("images/mountainVanBScaled.png")
addImage("images/skyscaperTall.png")
addImage("images/skyscaperWide.png")
addImage("images/cactus.png")
addImage("images/cactusBig.png")
addImage("images/cuart.png")
addImage("images/cuart.png") -- for flipped
addImage("images/car.png")

local hurt = {}
-- add a rectangle with x and y being bottom left position in screen
function hurt.add(xPos,yPos,width,height)
  hurt[#hurt+1] = {x=xPos,y=screenY-yPos-height-100,w=width,h=height}
end

local collisions = {}
function collisions.add(xPos,yPos,width,height)
  collisions[#collisions+1] = {x=xPos,y=screenY-yPos-height-100,w=width,h=height}
end
function collisions.addF(xPos,yPos,width,height)
  collisions[#collisions+1] = {x=xPos,y=screenY-yPos-height-100,w=width,h=height,f=true}
end
local visuals = {}

local backgrounds = {}
backgrounds[1] = love.graphics.newImage("images/VanB.png")
backgrounds[2] = love.graphics.newImage("images/SanFranB.png")
backgrounds[3] = love.graphics.newImage("images/ArizonaB.png")
backgrounds[4] = love.graphics.newImage("images/tunnel.png")
backgrounds[5] = love.graphics.newImage("images/NewMexicoB.png")
backgrounds[6] = love.graphics.newImage("images/ArizonaB.png")
local current = 1
function backgrounds.nextBackground()
  current = current + 1
  background = backgrounds[current]
end

function love.load()
  love.window.setMode(1500, screenY)
  love.graphics.setLineWidth(5)
  love.window.setTitle("Tour of the Americas")
  startGameWriter = typewriter.new(require("gametext"))
  startGameWriter.specialDelays={["."]=0.12,["-"]=0.08}
  startGameWriter.defaultTime = 0.03
  love.graphics.setNewFont(28)
  game.giveTables(collisions, player, backgrounds, hurt, cars)
  current = game.jumps or 1
  background = backgrounds[current]
  game.softReset()
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
  if i == 4 or i == 5 then
    visuals[#visuals+1] = {i=motionImages[i],x=x,y=screenY-y-h-100,w=w,h=h}
    hurt.add(x+((5*w)/12),y,w/4,(23*h)/24)
    hurt.add(x+(w/12),y+((15*h)/48),(4*w)/5,h/18)
    hurt.add(x+((59*w)/72),y+((5*h)/24),w/12,h/8)
    hurt.add(x+((w)/18),y+((5*h)/12),w/5,h/5)
  end
  if i == 6 then
    visuals[#visuals+1] = {i=motionImages[i],x=x,y=screenY-y-h-100,w=w,h=h}
    collisions.add(x,y+(h/15),w/20,h/10)
    collisions.add(x+(w/15),y+((2*h)/20),w/20,h/10)
    collisions.add(x+((2*w)/15),y+((3*h)/20),w/20,h/10)
    collisions.add(x+((3*w)/15),y+((4*h)/20),w/20,h/10)
    collisions.add(x+((4*w)/15),y+((5*h)/20),w/20,h/10)
    collisions.add(x+((5*w)/15),y+((6*h)/20),w/20,h/10)
    collisions.add(x+((6*w)/15),y+((1*h)/20),w/20,h/10+((5*h)/20))
    collisions.add(x+((7*w)/15),y+((2*h)/20),w/20,h/10+((5*h)/20))
    collisions.add(x+((8*w)/15),y+((3*h)/20),w/20,h/10+((5*h)/20))
    collisions.add(x+((9*w)/15),y+((4*h)/20),w/20,h/10+((5*h)/20))
    collisions.add(x+((10*w)/15),y+((5*h)/20),w/20,h/10+((5*h)/20))
    collisions.add(x+((11*w)/15),y+((6*h)/20),w/20,h/10+((5*h)/20))
    collisions.add(x+((12*w)/15),y+((7*h)/20),w/20,h/10+((5*h)/20))
    collisions.add(x+((13*w)/15),y+((8*h)/20),w/20,h/10+((5*h)/20))
    collisions.add(x+((14*w)/15),y+((9*h)/20),w/20,h/10+((5*h)/20))
  end
  if i == 7 then
    visuals[#visuals+1] = {f=true,i=motionImages[i],x=x,y=screenY-y-h-100,w=w,h=h}
    collisions.addF(x-(w/15),y+(h/15),w/20,h/10)
    collisions.addF(x-((2*w)/15),y+((2*h)/20),w/20,h/10)
    collisions.addF(x-((3*w)/15),y+((3*h)/20),w/20,h/10)
    collisions.addF(x-((4*w)/15),y+((4*h)/20),w/20,h/10)
    collisions.addF(x-((5*w)/15),y+((5*h)/20),w/20,h/10)
    collisions.addF(x-((6*w)/15),y+((6*h)/20),w/20,h/10)
    collisions.addF(x-((7*w)/15),y+((1*h)/20),w/20,h/10+((5*h)/20))
    collisions.addF(x-((8*w)/15),y+((2*h)/20),w/20,h/10+((5*h)/20))
    collisions.addF(x-((9*w)/15),y+((3*h)/20),w/20,h/10+((5*h)/20))
    collisions.addF(x-((10*w)/15),y+((4*h)/20),w/20,h/10+((5*h)/20))
    collisions.addF(x-((11*w)/15),y+((5*h)/20),w/20,h/10+((5*h)/20))
    collisions.addF(x-((12*w)/15),y+((6*h)/20),w/20,h/10+((5*h)/20))
    collisions.addF(x-((13*w)/15),y+((7*h)/20),w/20,h/10+((5*h)/20))
    collisions.addF(x-((14*w)/15),y+((8*h)/20),w/20,h/10+((5*h)/20))
    collisions.addF(x-((15*w)/15),y+((9*h)/20),w/20,h/10+((5*h)/20))
  end
  if i == 8 then
    visuals[#visuals+1] = {i=motionImages[i],x=x,y=screenY-y-h-100,w=w,h=h}
  end
end

local function addCar(x,y,w,h,s)
  cars[#cars+1] = car.new(collisions, hurt, visuals, x, y, w, h, s)
end
love.math.setRandomSeed(12345)
for i = 1, 10 do
  local h = math.floor(50*love.math.random(2,7))
  local w = math.floor(50*love.math.random(3,9))
  local x = -800 + i*300 + w
  collisions.addImage(1,x,0,w,h)
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
collisions.addImage(3,5400,0,250,200)
collisions.addImage(3,5700,0,150,500)
collisions.addImage(3,6000,0,150,800)
collisions.addImage(2,6300,0,100,1100)
collisions.addImage(3,6500,0,115,300)
collisions.addImage(2,6850,0,150,400)
collisions.addImage(3,7005,0,400,150)
collisions.addImage(3,7005,0,400,150)
for i = 1, 25 do
  local w = math.floor(50*love.math.random(2,3))
  local x = 7500 + i*550 + love.math.random(-50,50) + w
  local h = math.floor(50*love.math.random(1,4))
  collisions.addImage(4,x,0,w,h)
end
local h = 250
local w = 100
collisions.addImage(4,12400,0,w,200)
collisions.addImage(5,14150,0,w,h)
collisions.addImage(5,14800,0,w,h)
collisions.addImage(5,17850,0,w,h)
collisions.addImage(5,19400,0,w,h)
collisions.addImage(4,21250,0,w,h)
collisions.addImage(6,26500,0,600,200)
collisions.addImage(4,27250,0,100,400)
collisions.addImage(4,27650,0,50,200)
collisions.addImage(6,28150,0,500,200)
collisions.addImage(4,29000,0,50,300)
collisions.addImage(6,28700,0,150,50)
collisions.addImage(6,29300,0,400,200)
collisions.addImage(4,29150,0,50,300)
collisions.addImage(6,30550,0,350,150)
collisions.addImage(7,30550,0,350,150)
collisions.addImage(5,30500,0,50,450)
collisions.addImage(6,31300,0,450,150)
collisions.addImage(4,31850,0,50,150)
collisions.addImage(5,31950,0,50,200)
collisions.addImage(5,32050,0,50,250)
collisions.addImage(5,32400,0,100,350)
local runGame = true
local alive = true
for i = 1, 50 do
  collisions.addImage(4,33000+i*50,0,25,100)
end
addCar(33000,-25,400,200,800)
addCar(33500,-25,300,150,300)
addCar(34500,-25,400,250,500)

function love.draw()
  -- motionless drawing
  love.graphics.setColor(255,255,255)
  love.graphics.draw(background)
  love.graphics.setColor(0,0,0)
  love.graphics.printf(startGameWriter:getText() or "",0,22,1500)

  love.graphics.print(math.floor(player.x) .. " " .. tostring(alive),0,-2)

  -- moving screen drawing
  love.graphics.push()
  love.graphics.translate(-game.scroll,0)
  -- ipairs skips the hash parts of the table and just does the numerical indexes
  love.graphics.setColor(255,255,255,255)
  for key, image in ipairs(visuals) do
    if image.x > game.scroll-750 and image.x < game.scroll+2250 then
      if image.f then
        love.graphics.draw(image.i.i,image.x,image.y,0,
          -image.w/image.i.iw, image.h/image.i.ih)
      else
           love.graphics.draw(image.i.i,image.x,image.y,0,
          image.w/image.i.iw, image.h/image.i.ih)
      end
    end
  end
  love.graphics.setColor(0,0,0,50)
  for key, rectangle in ipairs(collisions) do
    if rectangle.x > game.scroll-750 and rectangle.x < game.scroll+2250 then
      love.graphics.rectangle("line",rectangle.x,rectangle.y,rectangle.w,rectangle.h)
    end
  end
  love.graphics.setColor(255,0,0,25)
  for key, rectangle in ipairs(hurt) do
    if rectangle.x > game.scroll-750 and rectangle.x < game.scroll+2250 then
      love.graphics.rectangle("line",rectangle.x,rectangle.y,rectangle.w,rectangle.h)
    end
  end
  love.graphics.setColor(0,0,0,255)
  love.graphics.rectangle("line",player.x,player.y,player.w,player.h)
  love.graphics.pop()
end
-- dt is time passed since last frame in seconds
function love.update(dt)
  if dt > 0.5 then return end
  if runGame then
    startGameWriter:update(dt)
    alive = game.update(dt)
    if alive == nil then alive = true end
    if (alive == "YOU DIED") or (alive == "CACTI EVEN HURT OVERLOARDS") then
      --runGame = false
      love.load()
    end
  end
  if love.keyboard.isDown("i") then
    runGame = true
  end
  if not alive then
    runGame = false
  end
end
