-- Define the array of points
local points = {
    {x = 100, y = 71, z = -31},
    {x = 99, y = 72, z = -33},
    {x = 99, y = 72, z = -41},
	{x = 99, y = 72, z = -49},
	{x = 99, y = 72, z = -57},
    -- Add more points as needed
}

-- Function to get the turtle's current position
function getCurrentPosition()
    local x, y, z = gps.locate()
    if not x then
        error("GPS signal not found")
    end
    return {x = x, y = y, z = z}
end

-- Function to face the turtle in a specific direction
-- 0 = north, 1 = east, 2 = south, 3 = west
function faceDirection(direction)
    local currentDirection = 0 -- Assume turtle starts facing north
    while currentDirection ~= direction do
        turtle.turnRight()
        currentDirection = (currentDirection + 1) % 4
    end
end

-- Function to move the turtle in the x direction
function moveX(targetX, currentPos)
    if targetX > currentPos.x then
        faceDirection(1) -- face east
        for i = currentPos.x + 1, targetX do
            turtle.forward()
        end
    elseif targetX < currentPos.x then
        faceDirection(3) -- face west
        for i = targetX, currentPos.x - 1 do
            turtle.forward()
        end
    end
end

-- Function to move the turtle in the y direction (vertical)
function moveY(targetY, currentPos)
    if targetY > currentPos.y then
        for i = currentPos.y + 1, targetY do
            turtle.up()
        end
    elseif targetY < currentPos.y then
        for i = targetY, currentPos.y - 1 do
            turtle.down()
        end
    end
end

-- Function to move the turtle in the z direction
function moveZ(targetZ, currentPos)
    if targetZ > currentPos.z then
        faceDirection(0) -- face north
        for i = currentPos.z + 1, targetZ do
            turtle.forward()
        end
    elseif targetZ < currentPos.z then
        faceDirection(2) -- face south
        for i = targetZ, currentPos.z - 1 do
            turtle.forward()
        end
    end
end

-- Function to move the turtle to a specific point
function moveToPoint(target)
    local currentPos = getCurrentPosition()

    -- Move in x direction
    moveX(target.x, currentPos)
    currentPos.x = target.x
    
    -- Move in y direction (vertical)
    moveY(target.y, currentPos)
    currentPos.y = target.y
    
    -- Move in z direction
    moveZ(target.z, currentPos)
    currentPos.z = target.z
end

-- Main program loop
for i, point in ipairs(points) do
    moveToPoint(point)
end
