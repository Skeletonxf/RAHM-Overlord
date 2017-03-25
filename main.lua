local example = require("example")
local exampleClass = require("exampleClasses")

local objectExample

local screenY = 900

function love.load()
	objectExample = exampleClass.new()
	example.someUsefulThing()
	objectExample:sayHi()
	love.window.setMode(1500, screenY)
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
collisions.add(750,0,200,200)

local scroll = 0

local player = {x=100,h=150,w=100,y=500,dy=0}

function love.draw()
	-- motionless drawing
	love.graphics.print("Overlord")

	-- moving screen drawing
	love.graphics.push()
	love.graphics.translate(-scroll,0)
	-- ipairs skips the hash parts of the table and just does the numerical indexes
  love.graphics.setColor(255,0,0)
	for key, rectangle in ipairs(hurt) do
		love.graphics.rectangle("line",rectangle.x,rectangle.y,rectangle.w,rectangle.h)
	end
  love.graphics.setColor(255,255,255)
  for key, rectangle in ipairs(collisions) do
		love.graphics.rectangle("line",rectangle.x,rectangle.y,rectangle.w,rectangle.h)
	end
  love.graphics.rectangle("line",player.x,player.y,200,300)
	love.graphics.pop()
end

-- dt is time passed since last frame in seconds
function love.update(dt)
	if love.keyboard.isDown(",") then
		scroll = scroll + 75*dt
	elseif love.keyboard.isDown(".") then
		scroll = scroll - 75*dt
	else
		scroll = scroll + 50*dt
	end
    
  if love.keyboard.isDown("w") and player.y == 500 then
      player.dy = 100
  end
  
  player.y = player.y - player.dy
  player.dy = player.dy * 0.8
  if player.y <= 500 then
      player.dy = player.dy - 500*dt
  else
      player.y = 500
      player.dy = 0
  end

end
