local chestStatus = {} -- Table to keep track of which chests are full
local startX, startY = 6, 1 -- Starting position of the turtle

local size = {} -- Table to keep track of the size of chest gride

local row, col = 6, 3 -- Number of rows and columns in the chest grid

local chests = {}

-- Function to check if a chest has open space
local function hasSpace()
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

-- random boolean generator
local f

for i = 1, row do
	chests[i] = {}
	for j = 1, col do
		chests[i][j] = randomBool
	end
end

for i,line in ipairs(chests) do
	for j,chest in ipairs(line) do
		print(chest)
	end
end