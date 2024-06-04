local chestStatus = {} -- Table to keep track of which chests are full
local startX, startY = 6, 1 -- Starting position of the turtle

local columns, rows = 6, 3

-- Function to check if a chest has empty slots
local function checkEmpty()
    local success, data = turtle.inspect()
    if success and data.name == "minecraft:chest" then
        for slot = 1, 16 do
            if turtle.getItemCount(slot) == 0 then
                return true -- Found an empty slot
            end
        end
    end
    return false -- No empty slots found or not a chest
end

-- Function to deposit items into the chests
local function depositItems()
    local success, data = turtle.inspect()
    if success and data.name == "minecraft:chest" then
        for slot = 1, 16 do
            turtle.select(slot)
            turtle.drop()
        end
    end
end

local function column()
	for c = 1, columns do
		turtle.up()
		if checkEmpty() then
			depositItems()
			chestStatus[c] = true
		else
			chestStatus[c] = false
		end
	end