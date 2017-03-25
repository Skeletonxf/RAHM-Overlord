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

local rectangles = {}
-- add a rectangle with x and y being bottom left position in screen
function rectangles.add(xPos,yPos,width,height)
	rectangles[#rectangles+1] = {x=xPos,y=screenY-yPos-height,w=width,h=height}
end
rectangles.add(150,0,50,100)

local scroll = 0

function love.draw()
	-- motionless drawing
	love.graphics.print("Overload")
	
	-- moving screen drawing
	love.graphics.push()
	love.graphics.translate(-scroll,0)
	-- ipairs skips the hash parts of the table and just does the numerical indexes
	for key, rectangle in ipairs(rectangles) do
		love.graphics.rectangle("line",rectangle.x,rectangle.y,rectangle.w,rectangle.h)
	end
	love.graphics.pop()
end

-- dt is time passed since last frame in seconds
function love.update(dt)
	scroll = scroll + dt*50
end
