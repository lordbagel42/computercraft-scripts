local chestStatus = {} -- Table to keep track of which chests are full
local startX, startY = 6, 1 -- Starting position of the turtle

local size = {} -- Table to keep track of the size of chest gride
size[x], size[y] = 6, 3

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

local function setChest(x, y)
	chests[x][y] = math.random(0, 1) == 1
end

-- random boolean generator
local function randomBool()
	return math.random(0, 1) == 1
end

thingX, thingY = 1, 1
setChest(thingX, thingY)
print(thingX, thingY)