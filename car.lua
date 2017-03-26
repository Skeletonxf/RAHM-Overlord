local inspect = require "inspect"

local carMetaTable = {}
-- some lua magic
carMetaTable.__index = carMetaTable

-- using : instead of . means there is an implicit self named
-- variable passed as the first argument to this function
-- which will be the object/table that is invoking
-- this method
function carMetaTable:update(dt, onScreen, offLeft)
  if onScreen then
    self.x = self.x + -800*dt
  elseif offLeft then
    self.x = self.startX
  end
  self.collisions[self.bodyIndex].x = self.x
  self.collisions[self.roofIndex].x = self.x
  self.visuals[self.imageIndex].x = self.x
end

function carMetaTable:reset()
  self.x = self.startX
end  

local carTable = {}

function carTable.new(collisions, hurt, visuals, x, y, w, h)
  local car = {}
  setmetatable(car,carMetaTable)
  car.x = x
  car.startX = x
  car.y = y
  car.w = w
  car.h = h
  collisions.add(x,y,w,(3*h)/4)
  car.bodyIndex = #collisions
  collisions.add(x+(w/3),y,(2*w)/3,h)
  car.roofIndex = #collisions
  car.collisions = collisions
  collisions.addImage(8,x,y,w,h)
  car.imageIndex = #visuals
  car.visuals = visuals
  return car
end

return carTable