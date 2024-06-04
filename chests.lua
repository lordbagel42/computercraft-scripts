-- Function to check if there's a chest in front and empty it
local function emptyChest()
    local success, data = turtle.inspect()
    if success and data.name == "minecraft:chest" then
        for slot = 1, 16 do
            turtle.select(slot)
            turtle.suck()
        end
    end
end

local function checkEmpty()
	local success, data = turtle.inspect()
	if success and data.name == "minecraft:chest" then
		for slot = 1, 32 do
			if turtle.getItemCount(slot) > 0 then
				return false -- Found a non-empty slot
			end
		end
		return true -- All slots are empty
	end
	return false -- No chest found
end

-- Function to deposit items into the chest in front
local function depositItems()
    local success, data = turtle.inspect()
    if success and data.name == "minecraft:chest" then
        for slot = 1, 16 do
            turtle.select(slot)
            turtle.drop()
        end
    end
end

-- Initial steps: move backward twice, up one, turn right, move forward one
turtle.back()
turtle.back()
turtle.up()
turtle.turnRight()
turtle.forward()
local chest1 = checkEmpty()
if not chest1 then
	emptyChest()
end

turtle.back()
turtle.down()
turtle.turnLeft()
for i = 1, 2 do turtle.forward() end
depositItems() -- needs replaced with a chestFiller function set