-- Coordinates of the output chests relative to the starting position
local outputChests = {
    {-1, 1, -3},
    {-9, 1, -3},
    {-17, 1, -3},
    {-25, 1, -3}
}

-- Function to move the turtle to specific coordinates
function moveTo(x, y, z)
    -- Move along the x-axis
    if x > 0 then
        turtle.turnRight()
    else
        turtle.turnLeft()
    end
    for i = 1, math.abs(x) do
        turtle.forward()
    end
    if x > 0 then
        turtle.turnLeft()
    else
        turtle.turnRight()
    end

    -- Move along the z-axis
    for i = 1, math.abs(z) do
        turtle.forward()
    end

    -- Move along the y-axis
    if y > 0 then
        for i = 1, y do
            turtle.up()
        end
    else
        for i = 1, -y do
            turtle.down()
        end
    end
end

-- Function to return to the starting position
function returnToStart()
    moveTo(0, 0, 0) -- Move to origin
end

-- Function to collect items from the output chest
function collectItems()
    for slot = 1, 16 do
        turtle.select(slot)
        turtle.suck()
    end
end

-- Function to deposit items into the storage chests
function depositItems()
    for slot = 1, 16 do
        turtle.select(slot)
        turtle.drop()
    end
end

-- Main program loop
while true do
    for _, chest in ipairs(outputChests) do
        -- Move to the output chest
        moveTo(table.unpack(chest))
        -- Collect items
        collectItems()
        -- Return to the storage chests
        returnToStart()
        -- Deposit items
        depositItems()
    end
    -- Wait for a short period before checking the chests again
    os.sleep(30)
end
