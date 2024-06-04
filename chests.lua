local x, y, z = gps.locate()
local startX, startY, startZ = x, y, z
local chests = {
	{ name = "chest1", x = 99, y = 72, z = -33 },
	{ name = "chest2", x = 99, y = 72, z = -41 },
	{ name = "chest3", x = 99, y = 72, z = -49 },
	{ name = "chest4", x = 99, y = 72, z = -57 }
}

-- north = 0, east = 1, south = 2, west = 3
local heading = 2

local startHeading = heading

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

local function goTo(targetX, targetY, targetZ)
	if z < targetZ then
		turnTo(2) -- north
		while z < targetZ do
			turtle.forward()
			x, y, z = gps.locate()
		end
	elseif z > targetZ then
		turnTo(0) -- south
		while z > targetZ do
			turtle.forward()
			x, y, z = gps.locate()
		end
	end

	local x, y, z = gps.locate()
	if x < targetX then
		turnTo(1) -- east
		while x < targetX do
			turtle.forward()
			x, y, z = gps.locate()
		end
	elseif x > targetX then
		turnTo(3) -- west
		while x > targetX do
			turtle.forward()
			x, y, z = gps.locate()
		end
	end

	if y < targetY then
		-- no turning
		while y < targetY do
			turtle.up()
			x, y, z = gps.locate()
		end
	elseif y > targetY then
		-- no turning
		while y > targetY do
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

-- move next to quarry array
local function setup()
	goTo(100, 72, -33)
end

setup()
goTo(99, 72, -33)
goTo(startX, startY, startZ)
turnTo(startHeading)