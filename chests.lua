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

-- Function to turn the turtle to face a specific direction
local function turnTo(direction)
    local currentDirection = "south"  -- Assuming the turtle starts facing south
    local directions = {"north", "east", "south", "west"}
    local dirMap = {north=0, east=1, south=2, west=3}
    
    local function turnLeft()
        turtle.turnLeft()
        currentDirection = directions[(dirMap[currentDirection] - 1) % 4 + 1]
    end
    
    local function turnRight()
        turtle.turnRight()
        currentDirection = directions[(dirMap[currentDirection] + 1) % 4 + 1]
    end
    
    while currentDirection ~= direction do
        turnRight()
    end
end

-- Function to move the turtle to the specified coordinates
local function moveTo(targetX, targetY, targetZ)
    local currentX, currentY, currentZ = getCurrentPosition()
    if currentX == nil then
        return
    end

    -- Move in the X direction
    while currentX ~= targetX do
        if currentX < targetX then
            turnTo("east
