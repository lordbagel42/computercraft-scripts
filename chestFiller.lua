local chestStatus = {} -- Table to keep track of which chests are full
local startX, startY = 6, 1 -- Starting position of the turtle

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
	local currentX, currentY = startX, startY -- Set the current position to the starting position
	for col = 1, 6 do
		-- Assuming the turtle is initially facing towards the grid of chests
		turtle.turnRight() -- Turn right to face the chests in the column
		for row = 1, 3 do
			local chest = currentX .. "," .. currentY -- Format chest position
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
				currentY = currentY + 1 -- Update the current Y position
			end
		end
		-- Return to the starting position for the next column
		for i = 1, 2 do
			turtle.down()
			currentY = currentY - 1 -- Update the current Y position
		end
		turtle.turnLeft() -- Turn left to face the next column
		turtle.forward() -- Move to the next column
		currentX = currentX - 1 -- Update the current X position
	end
	printStatus("Completed") -- Print completion status
end

-- Call the main function to start depositing inventory in columns
depositInventoryInColumns()
