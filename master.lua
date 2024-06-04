-- Master Turtle Script

-- Function to get command-line arguments
function getArgs()
    local tArgs = { ... }
    if #tArgs ~= 8 then
        print("Usage: <program> <width> <length> <height> <startX> <startY> <startZ> <turtlesWidth> <turtlesLength>")
        return nil
    end
    local width = tonumber(tArgs[1])
    local length = tonumber(tArgs[2])
    local height = tonumber(tArgs[3])
    local startX = tonumber(tArgs[4])
    local startY = tonumber(tArgs[5])
    local startZ = tonumber(tArgs[6])
    local turtlesWidth = tonumber(tArgs[7])
    local turtlesLength = tonumber(tArgs[8])
    return width, length, height, startX, startY, startZ, turtlesWidth, turtlesLength
end

-- Function to deploy a slave turtle
function deploySlave(startX, startY, startZ, offsetX, offsetY, offsetZ, width, length, height)
    turtle.select(1) -- Assuming slave turtle is in the first slot
    turtle.place()
    local success, data = turtle.inspect()
    if success and data.name == "computercraft:turtle_advanced" then
        peripheral.call("front", "turnOn")
        os.sleep(2) -- Give the turtle some time to boot up
        peripheral.call("front", "run", string.format("slave.lua %d %d %d %d %d %d", 
            startX + offsetX, startY + offsetY, startZ + offsetZ, width, length, height))
        turtle.dig() -- Remove the turtle after it's been programmed
    else
        print("Failed to deploy slave turtle.")
    end
end

-- Function to move the master turtle to the starting location
function moveTo(x, y, z)
    local posX, posY, posZ = gps.locate()
    while posX ~= x do
        if posX < x then
            turtle.forward()
        else
            turtle.back()
        end
        posX = gps.locate()
    end
    while posY ~= y do
        if posY < y then
            turtle.up()
        else
            turtle.down()
        end
        posY = gps.locate()
    end
    while posZ ~= z do
        if posZ < z then
            turtle.turnRight()
            turtle.forward()
            turtle.turnLeft()
        else
            turtle.turnLeft()
            turtle.forward()
            turtle.turnRight()
        end
        posZ = gps.locate()
    end
end

-- Main function
function main()
    local width, length, height, startX, startY, startZ, turtlesWidth, turtlesLength = getArgs()
    if width == nil then
        return
    end

    -- Calculate the optimal size for each turtle's quarry section
    local sectionWidth = math.ceil(width / turtlesWidth)
    local sectionLength = math.ceil(length / turtlesLength)

    for i = 0, turtlesWidth - 1 do
        for j = 0, turtlesLength - 1 do
            local offsetX = i * sectionWidth
            local offsetZ = j * sectionLength
            local slaveWidth = math.min(sectionWidth, width - offsetX)
            local slaveLength = math.min(sectionLength, length - offsetZ)

            moveTo(startX + offsetX, startY, startZ + offsetZ)
            deploySlave(startX, startY, startZ, offsetX, 0, offsetZ, slaveWidth, slaveLength, height)
        end
    end
end

main()
