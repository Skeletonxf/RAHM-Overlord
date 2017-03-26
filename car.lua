local carMetaTable = {}
-- some lua magic
carMetaTable.__index = carMetaTable

-- using : instead of . means there is an implicit self named
-- variable passed as the first argument to this function
-- which will be the object/table that is invoking
-- this method
function carMetaTable:update(dt)
	print("hello" .. tostring(self))
end

local carTable = {}

function carTable.new(collisions, hurt, x, y, w, h)
	local car = {}
	setmetatable(object,carMetaTable)
  car.x = x
  car.y = y
  car.w = w
  car.h = h
  collisions.add(x,y,w,h)
  car.bodyIndex = #collisions
	return car
end

return carTable