local x, y, z = gps.locate()
local startX, startY, startZ = 100, 71, -31
local quarryChests = {{
    name = "chest1",
    x = 99,
    y = 72,
    z = -33,
    empty = false
}, {
    name = "chest2",
    x = 99,
    y = 72,
    z = -41,
    empty = false
}, {
    name = "chest3",
    x = 99,
    y = 72,
    z = -49,
    empty = false
}, {
    name = "chest4",
    x = 99,
    y = 72,
    z = -57,
    empty = false
}}

local heading = 2 -- north = 0, east = 1, south = 2, west = 3
local chestDirection = 3 -- Direction to face the chests
local storageDirection = 2 -- Direction to face the storage
local chestStatus = {} -- Table to keep track of which chests are full
local storageStartX, storageStartZ = 6, 1 -- Starting position of the turtle
local row, col = 6, 3 -- Number of rows and columns in the chest grid
local storageX, storageY, storageZ = startX + row, startY - 1, startZ -- Coordinates of the bottom left corner: 1, 1
local chests = {} -- Table to keep track of the size/status of chest grid

local startHeading = heading

-- Function to turn towards a specific heading
local function turnTo(targetHeading)
    local diff = targetHeading - heading
    if diff < 0 then
        diff = diff + 4
    end
    if diff == 1 then
        turtle.turnRight()
    elseif diff == 2 then
        turtle.turnRight()
        turtle.turnRight()
    elseif diff == 3 then
        turtle.turnLeft()
    end
    heading = targetHeading
end

-- Function to move the turtle to a specific location
local function goTo(targetX, targetY, targetZ)
    local x, y, z = gps.locate()
    if z < targetZ then
        turnTo(2) -- north
        while z < targetZ do
            print("Target Z: " .. targetZ .. " Current Z: " .. z)
            turtle.forward()
            x, y, z = gps.locate()
        end
    elseif z > targetZ then
        turnTo(0) -- south
        while z > targetZ do
            print("Target Z: " .. targetZ .. " Current Z: " .. z)
            turtle.forward()
            x, y, z = gps.locate()
        end
    end

    if x < targetX then
        turnTo(1) -- east
        while x < targetX do
            print("Target X: " .. targetX .. " Current X: " .. x)
            turtle.forward()
            x, y, z = gps.locate()
        end
    elseif x > targetX then
        turnTo(3) -- west
        while x > targetX do
            print("Target X: " .. targetX .. " Current X: " .. x)
            turtle.forward()
            x, y, z = gps.locate()
        end
    end

    if y < targetY then
        -- no turning
        while y < targetY do
            print("Target Y: " .. targetY .. " Current Y: " .. y)
            turtle.up()
            x, y, z = gps.locate()
        end
    elseif y > targetY then
        -- no turning
        while y > targetY do
            print("Target Y: " .. targetY .. " Current Y: " .. y)
            turtle.down()
            x, y, z = gps.locate()
        end
    end
end

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

-- Function to check if the chest in front of the turtle is empty
local function isChestEmpty()
    -- Select the first slot to ensure we can use it
    turtle.select(1)

    -- Check if there is a chest in front
    if turtle.detect() then
        -- Attempt to suck an item from the chest
        if turtle.suck() then
            -- If an item was successfully sucked, the chest is not empty
            -- Put the item back into the chest
            turtle.drop()
            return false
        else
            -- If no item was sucked, the chest is empty
            return true
        end
    else
        -- No chest in front
        print("No chest in front")
        return false
    end
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

local function home()
    goTo(startX, startY, startZ)
    turnTo(startHeading)
end

-- Function to go to a quarry chest and empty it. Mark if it has stuff or no.
local function emptyQuarryChest(chest)
    goTo(quarryChests[chest].x, quarryChests[chest].y, quarryChests[chest].z)
    turnTo(chestDirection)
    quarryChests[chest].empty = isChestEmpty()
    if not quarryChests[chest].empty then
        print("Chest " .. chest .. " still has items")
        emptyChest()
        home()
        depositItems()
		goTo(100, 72, -33)
		emptyQuarryChest(chest)
    end
end

-- Function to deposit items into chest directly in front of the turtle
local function depositItems()
    local success, data = turtle.inspect()
    if success and data.name == "minecraft:chest" then
        for slot = 1, 16 do
            turtle.select(slot)
            turtle.drop()
        end
    end
end

-- Function to move to a specific chest in the grid
local function getChestPos(chestX, chestY)
	if chestX > row or chestY > col then
		error("Out of bounds: " .. chestX .. ", " .. chestY)
	end

	local actualX = storageX - chestX -- left to right
	local actualY = storageY + chestY -- up and down
	local actualZ = storageZ -- z of in front of the chests
	return actualX, actualY, actualZ
end

local function moveToChest(chestX, chestY)
	actualX, actualY, actualZ = getChestPos(chestX, chestY)
	goTo(actualX, actualY, actualZ)
	turnTo(storageDirection)
end

local function depositStorage()
	for i = 1, row do
		for j = 1, col do
			if chests[i][j].empty then
				moveToChest(i, j)
				depositItems()
				print("Chest " .. i .. ", " .. j .. " has available space")
			end
			print("Chest " .. i .. ", " .. j .. " is full")
		end
	end
end

-- setup functions
local function setup()
    for i = 1, row do
        chests[i] = {}
        for j = 1, col do
            chests[i][j] = randomBool
        end
    end
    print("Table Initialized")
    goTo(100, 72, -33)
end

setup()

for i = 1, #quarryChests do
    emptyQuarryChest(i)
end

goTo(startX, startY, startZ)
turnTo(startHeading)
