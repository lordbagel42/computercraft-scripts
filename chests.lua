-- Function to parse command-line arguments
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

-- Function to get the current position using GPS
local function getCurrentPosition()
    local x, y, z = gps.locate()
    if x == nil or y == nil or z == nil then
        print("Unable to determine current position. Make sure you're in range of GPS.")
        return nil
    end
    return x, y, z
end

-- Function to face a specific direction
local function faceDirection(targetDir)
    local directions = {north = 0, east = 1, south = 2, west = 3}
    local currentDir = turtle.getHeading()

    while currentDir ~= targetDir do
        turtle.turnRight()
        currentDir = (currentDir + 1) % 4
    end
end

-- Function to move the turtle to the specified coordinates
local function moveTo(targetX, targetY, targetZ)
    local currentX, currentY, currentZ = getCurrentPosition()
    if currentX == nil then
        return
    end

    -- Move in the X direction
    if currentX < targetX then
        faceDirection(1)  -- East
    else
        faceDirection(3)  -- West
    end
    while currentX ~= targetX do
        if currentX < targetX then
            turtle.forward()
            currentX = currentX + 1
        else
            turtle.back()
            currentX = currentX - 1
        end
    end

    -- Move in the Z direction
    if currentZ < targetZ then
        faceDirection(0)  -- North
    else
        faceDirection(2)  -- South
    end
    while currentZ ~= targetZ do
        if currentZ < targetZ then
            turtle.forward()
            currentZ = currentZ + 1
        else
            turtle.back()
            currentZ = currentZ - 1
        end
    end

    -- Move in the Y direction
    while currentY ~= targetY do
        if currentY < targetY then
            turtle.up()
            currentY = currentY + 1
        else
            turtle.down()
            currentY = currentY - 1
        end
    end

    print("Arrived at destination!")
end

-- Main program
local targetX, targetY, targetZ = parseArgs()
if targetX and targetY and targetZ then
    moveTo(targetX, targetY, targetZ)
end
