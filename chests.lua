local x, y, z = gps.locate()

-- north = 0, east = 1, south = 2, west = 3
local currentDirection = 2 -- south

local function parseArgs()
    if #arg < 3 then
        print("Usage: goTo <x> <y> <z>")
        return nil
    end

    local targetX = tonumber(arg[1])
    local targetY = tonumber(arg[2])
    local targetZ = tonumber(arg[3])

    if targetX == nil or targetY == nil or targetZ == nil then
        print("Invalid coordinates provided")
        return nil
    end

    return targetX, targetY, targetZ
end

local function turnTo(targetHeading) -- takes in a number
    while targetHeading < currentDirection do
        turtle.turnLeft()
        currentDirection = currentDirection - 1
        if currentDirection == targetHeading then
            currentDirection = targetHeading
        end
    end
end

local function moveTo(targetX, targetY, targetZ)
end

local targetX, targetY, targetZ = parseArgs()
