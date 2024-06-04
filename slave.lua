-- Slave Turtle Script (slave.lua)
local tArgs = { ... }
if #tArgs ~= 6 then
    print("Usage: slave <startX> <startY> <startZ> <width> <length> <height>")
    return
end

local startX = tonumber(tArgs[1])
local startY = tonumber(tArgs[2])
local startZ = tonumber(tArgs[3])
local width = tonumber(tArgs[4])
local length = tonumber(tArgs[5])
local height = tonumber(tArgs[6])

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

function quarry(width, length, height)
    for h = 1, height do
		turtle.digDown()
		turtle.down()
	end
	for h = 1, height do
		turtle.up()
	end
end

moveTo(startX, startY, startZ)
quarry(width, length, height)
