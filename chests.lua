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
function isChestEmpty()
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

-- Initial steps: move backward twice, up one, turn right, move forward one
turtle.back()
turtle.back()
turtle.up()
turtle.turnRight()
turtle.forward()
local chest1 = isChestEmpty()
if not chest1 then
	emptyChest()
end

turtle.back()
turtle.down()
turtle.turnLeft()
for i = 1, 2 do turtle.forward() end
depositItems() -- needs replaced with a chestFiller function set