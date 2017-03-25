local example = require("example")
local exampleClass = require("exampleClasses")

local objectExample

function love.load()
	objectExample = exampleClass.new()
	example.someUsefulThing()
	objectExample:sayHi()
end

function love.draw()
	love.graphics.print("Overload")
end

-- dt is time passed since last frame in seconds
function love.update(dt)
	
end
