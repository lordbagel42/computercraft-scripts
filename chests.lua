-- Define the turtle's starting position
local startX, startY, startZ = 0, 0, 0

-- Output chest positions relative to the starting position
local outputChests = {
    {x = 2, y = 1, z = 2},
    {x = 10, y = 1, z = 2},
    {x = 18, y = 1, z = 2},
    {x = 26, y = 1, z = 2}
}

-- Function to move the turtle to a specified position
function moveTo(x, y, z)
    local currentX, currentY, currentZ = gps.locate()

    -- Move along the x-axis
    while currentX < x do
        turtle.forward()
        currentX = currentX + 1
    end
    while currentX > x do
        turtle.back()
        currentX = currentX - 1
    end

    -- Move along the y-axis (up and down)
    while currentY < y do
        turtle.up()
        currentY = currentY + 1
    end
    while currentY > y do
        turtle.down()
        currentY = currentY - 1
    end

    -- Move along the z-axis
    while currentZ < z do
        turtle.forward()
        currentZ = currentZ + 1
    end
    while currentZ > z do
        turtle.back()
        currentZ = currentZ - 1
    end
end

-- Function to collect items from an output chest
function collectItemsFromChest()
    for i = 1, 16 do
        turtle.suck()
    end
end

-- Function to deposit items into storage chests
function depositItemsToStorage()
    for i = 1, 16 do
        turtle.select(i)
        turtle.drop()
    end
end

-- Main program loop
while true do
    for _, chestPos in ipairs(outputChests) do
        -- Move to the output chest
        moveTo(chestPos.x, chestPos.y, chestPos.z)

        -- Collect items from the chest
        collectItemsFromChest()

        -- Return to the starting position
        moveTo(startX, startY, startZ)

        -- Deposit items into the storage chests
        depositItemsToStorage()
    end

    -- Wait for a while before collecting items again
    os.sleep(60) -- Wait for 60 seconds
end
