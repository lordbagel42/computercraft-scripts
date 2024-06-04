-- Get the first argument passed to the script
local fileName = ...

if not fileName then
    print("Usage: <script> <filename>")
    return
end

-- Run rm [first arg]
local deleteSuccess = shell.run("rm " .. fileName)
if deleteSuccess then
    print(fileName .. " deleted successfully.")
else
    print("Failed to delete " .. fileName)
    return
end

-- Run wget to download the file
local url = "https://raw.githubusercontent.com/lordbagel42/computercraft-scripts/main/" .. fileName
local downloadSuccess = shell.run("wget " .. url .. " " .. fileName)

if downloadSuccess then
    print(fileName .. " downloaded successfully.")
else
    print("Failed to download " .. fileName)
end
