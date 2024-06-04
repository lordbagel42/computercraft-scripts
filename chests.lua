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

-- Function to move the turtle back to its starting position and orientation
function returnToStart()
    -- Move back to the starting position
    turtle.back()
    turtle.turnLeft()
    turtle.down()
    turtle.forward()
    turtle.forward()
    turtle.turnRight()
end

-- Initial steps: move backward twice, up one, turn right, move forward one
turtle.back()
turtle.back()
turtle.up()
turtle.turnRight()
turtle.forward()

-- Empty as much of the chest in front of it as possible
emptyChest()

-- Return to the starting position
returnToStart()

-- Deposit items into the chest in front of the starting position
depositItems()
