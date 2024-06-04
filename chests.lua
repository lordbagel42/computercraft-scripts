-- Function to check if there's a chest in front and empty it
function emptyChest()
    local success, data = turtle.inspect()
    if success and data.name == "minecraft:chest" then
        for slot = 1, 16 do
            turtle.select(slot)
            turtle.suck()
        end
    end
end

-- Function to deposit items into the chest in front
function depositItems()
    local success, data = turtle.inspect()
    if success and data.name == "minecraft:chest" then
        for slot = 1, 16 do
            turtle.select(slot)
            turtle.drop()
        end
    end
end

-- Save the current position and orientation
local startX, startY, startZ = gps.locate()
local startDirection = turtle.getFacing()

-- Move backward twice
turtle.back()
turtle.back()

-- Move up one
turtle.up()

-- Turn right
turtle.turnRight()

-- Move forward one
turtle.forward()

-- Empty as much of the chest in front of it as possible
emptyChest()

-- Return to the starting position
turtle.back()
turtle.turnLeft()
turtle.down()
turtle.forward()
turtle.forward()

-- Deposit items into the chest in front of the starting position
depositItems()

-- Restore the initial orientation (if necessary)
while turtle.getFacing() ~= startDirection do
    turtle.turnRight()
end
