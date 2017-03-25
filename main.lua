local example = require("example")
local exampleClass = require("exampleClasses")

local objectExample

function love.load()
	objectExample = exampleClass.new()
	example.someUsefulThing()
	objectExample:sayHi()
	love.window.setMode(1500, 900)
end

local rectangles = {}
rectangles[1] = {x1=150,y1=150,w=50,h=50}

local scroll = 0

function love.draw()
	-- motionless drawing
	love.graphics.print("Overload")
	
	-- moving screen drawing
	love.graphics.push()
	love.graphics.translate(-scroll,0)
	for key, rectangle in pairs(rectangles) do
		love.graphics.rectangle("line",rectangle.x1,rectangle.y1,rectangle.w,rectangle.h)
	end
	love.graphics.pop()
end

-- dt is time passed since last frame in seconds
function love.update(dt)
	scroll = scroll + dt*50
end
