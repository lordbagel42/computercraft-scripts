dirString = { north=0, east=1, south=2, west=3}
-- South= +z, East= +x

fuelSlot = 16
x=0
y=0
z=0
f=-1

local function saveAll()
    save = fs.open(".persistLoc","w")
    save.write(textutils.serialize({x,y,z,f,fuelSlot}))
    save.close()
end

local function loadAll()
    if fs.exists(".persistLoc") then
       load = fs.open(".persistLoc","r")
       x,y,z,f,fuelSlot = unpack(textutils.unserialize(load.readAll()))
       load.close()
    end
end

function findFuel()
    for i=1,16 do
        if i ~= fuelSlot then
            turtle.select(i)
            if turtle.refuel(0) then
                return i
            end
        end
    end
end

function checkFuel()
    if turtle.getFuelLevel() <= math.abs(2 * (100 - y)) then
    	turtle.select(fuelSlot)
        if turtle.getItemCount(fuelSlot) == 0 or turtle.refuel(0) == false then
            newFuel = findFuel()
            if newFuel then
                turtle.select(newFuel)
            else
                return false
            end
        end
		turtle.refuel(1)
        return true
	end
end

function setFuelSlot(slot)
    if slot >= 1 and slot <= 16 then
        fuelSlot = slot
    else
        error("Invalid slot designation: " .. slot, 2)
    end
end

function updateLoc(backward)
	backward = backward or false
	if backward then
		factor = -1
	else
		factor = 1
	end
	
	if f==0 then
		z=z-factor
	elseif f==1 then
		x=x+factor
	elseif f==2 then
		z=z+factor
	elseif f==3 then
		x=x-factor
	else
		error("What direction again?")
	end
    saveAll()
end

function initFacing()
	fd(1)
	fx,fy,fz = gps.locate(3)
	if fx ~= nil then
		if x ~= fx then
			if fx > x then
				f = 1
			else
				f = 3
			end
		elseif z ~= fz then
			if fz > z then
				f = 2
			else
				f = 0
			end
		end
	end
	bk(1)
end

function initLoc()
	rednet.open("right")
	ix,iy,iz = gps.locate(3)
    if ix ~= nil then
        x,y,z = ix,iy,iz
    else
        print("t: Failed to get coordinates from GPS.")
    end
    if f == -1 then
		initFacing()
	end
	saveAll()
	rednet.close("right")
end

function getLoc()
	return x,y,z
end

function getX()
	return x
end

function getY()
	return y
end

function getZ()
	return z
end

function rt(ct)
	ct = ct or 1
	for i=1,ct do
		turtle.turnRight()
		f = (f+1)%4
        saveAll()
	end
	return true
end

function lt(ct)
	ct = ct or 1
	for i=1,ct do
		turtle.turnLeft()
		f = (f+3)%4
        saveAll()
	end
	return true
end

function up(ct,force)
	ct = ct or 1
    force = force or false
    local wait = 0
	for i=1,ct do
		checkFuel()
		while not turtle.up() do
            if wait == 5 then
                return i - 1
            end
            if force then
                turtle.digUp()
                turtle.attackUp()
                sleep(0.5)
                turtle.attackUp()
            end
            wait = wait + 1
            sleep(3)
		end
        y = y + 1
        saveAll()
	end
	return ct
end

function dn(ct,force)
	ct = ct or 1
    force = force or false
    local wait = 0
	for i=1,ct do
		checkFuel()
    	while not turtle.down() do
            if wait == 5 then
                return i - 1
            end
            if force then
                turtle.digDown()
                turtle.attackDown()
                sleep(0.5)
                turtle.attackDown()
            end
            wait = wait + 1
            sleep(3)
		end
        y = y - 1
        saveAll()
	end
	return ct
end

function fd(ct,force)
	ct = ct or 1
    force = force or false
    local wait = 0
	for i=1,ct do
		checkFuel()
        while not turtle.forward() do
            if wait == 5 then
                return i - 1
            end
            if force then
                turtle.dig()
                turtle.attack()
                sleep(0.5)
                turtle.attack()
            end
            wait = wait + 1
            sleep(3)
		end
		updateLoc()
	end
	return ct
end

function bk(ct,force)
	ct = ct or 1
    force = force or false
    local wait = 0
	for i=1,ct do
		checkFuel()
        while not turtle.back() do
            if wait == 5 then
                return i - 1
            end
            if force then
                rt(2)
                turtle.dig()
                turtle.attack()
                sleep(0.5)
                turtle.attack()
                rt(2)
            end
            wait = wait + 1
            sleep(3)
    	end
		updateLoc(true)
	end
	return ct
end

function face(d)
    if type(d) == "string" then
        dirs = {north=0, east=1, south=2, west=3}
        d = dirs[d]
    elseif type(d) == "number" then
        if d < 0 or d > 4 then
            error("Directional number out of range (0-3).",2)
        end
    end
    if d == nil then error("No direction specified.",2) end
-- F 0=North, 1=East, 2=South, 3=West
-- South= +z, East= +x
	local dir = -1
	if dirString[d] ~= nil then
		dir = dirString[d]
	else 
		dir = d
	end

	if dir == 0 and f == 3 then
		rt()
	elseif dir == 3 and f == 0 then
		lt()
	elseif dir > f then
		rt(dir - f)
	elseif dir < f then
		lt(f - dir)
	end
end

function gotoX(toX,force)
    if toX == nil then error("No coordinate specified.",2) end
    force = force or false
	if x < toX then
		face("east")
	elseif x > toX then
		face("west")
	end
	
	while x ~= toX do
        fd(1,force)
	end
end

function gotoY(toY,force)
    if toY == nil then error("No coordinate specified.",2) end
    force = force or false
	if y < toY then
		move = up
		dig = turtle.digUp
	elseif y > toY then
		move = dn
		dig = turtle.digDown
	end
	
	while y ~= toY do
        move(1,force)
	end
end

function gotoZ(toZ,force)
    if toZ == nil then error("No coordinate specified.",2) end
    force = force or false
	if z < toZ then
		face("south")
	elseif z > toZ then
		face("north")
	end
	
	while z ~= toZ do
        fd(1,force)
	end
end

function goto(toX, toY, toZ)
    toX = toX or x
    toY = toY or y
    toZ = toZ or z
    
	gotoX(toX)
	gotoZ(toZ)
	gotoY(toY)
end

loadAll()
initLoc()
print("Loaded t API. ID:" .. os.getComputerID())