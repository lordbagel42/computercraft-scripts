local chestStatus = {} -- Table to keep track of which chests are full

-- Function to check if a chest has empty slots
local function chestHasEmptySlots()
    local success, data = turtle.inspect()
    if success and data.name == "minecraft:chest" then
        for slot = 1, 16 do
            if turtle.getItemCount(slot) == 0 then
                return true -- Found an empty slot
            end
        end
    end
    return false -- No empty slots found or not a chest
end

-- Function to deposit items into the chests
local function depositItems()
    local success, data = turtle.inspect()
    if success and data.name == "minecraft:chest" then
        for slot = 1, 16 do
            turtle.select(slot)
            turtle.drop()
        end
    end
end

-- Function to print the status
local function printStatus(chest)
    term.clear()
    term.setCursorPos(1, 1)
    print("Attempting to fill chest: " .. chest)
    print("Chests known to be full:")
    for chest, isFull in pairs(chestStatus) do
        if isFull then
            print("- " .. chest)
        end
    end
end

-- Main function to iterate through each column, check chest status, and deposit items
local function depositInventoryInColumns()
    for col = 1, 6 do
        -- Assuming the turtle is initially facing towards the grid of chests
        turtle.turnLeft() -- Turn left to face the chests in the column
        for row = 1, 3 do
            local chest = col .. "," .. row -- Format chest position
            printStatus(chest) -- Print the current status
            if not chestStatus[chest] then -- If chest is not known to be full
                if chestHasEmptySlots() then
                    depositItems()
                else
                    chestStatus[chest] = true -- Mark chest as full
                end
            end
            -- Move up to the next row
            if row < 3 then
                turtle.up()
            end
        end
        -- Return to the starting position for the next column
        for i = 1, 2 do
            turtle.down()
        end
        turtle.turnRight() -- Turn right to face the next column
    end
    printStatus("Completed") -- Print completion status
end

-- Call the main function to start depositing inventory in columns
depositInventoryInColumns()
