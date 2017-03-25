local classMetaTable = {}
-- some lua magic
classMetaTable.__index = classMetaTable

-- using : instead of . means there is an implicit self named
-- variable passed as the first argument to this function
-- which will be the object/table that is invoking
-- this method
function classMetaTable:sayHi()
	print("hello" .. tostring(self))
end

local classTable = {}

function classTable.new()
	local object = {}
	setmetatable(object,classMetaTable)
	return object
end

return classTable
