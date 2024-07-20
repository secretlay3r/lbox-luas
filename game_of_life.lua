-----------Main config-----------
local cellSize = 10
local gridW, gridH = 50, 50
local updateInterval = 0.2
local windowX, windowY = 120, 120
---------------------------------

-- Making grid with random states
local grid = {}
for x = 1, gridW do
    grid[x] = {}
    for y = 1, gridH do
        grid[x][y] = math.random() > 0.5 and 1 or 0
    end
end

-- Function to count live neighbors
local function countNeighbors(grid, x, y)
    local count = 0
    for dx = -1, 1 do
        for dy = -1, 1 do
            if dx ~= 0 or dy ~= 0 then
                local nx, ny = x + dx, y + dy
                if nx > 0 and nx <= gridW and ny > 0 and ny <= gridH then
                    count = count + grid[nx][ny]
                end
            end
        end
    end
    return count
end

-- Updating grid
local function updateGrid(grid)
    local newGrid = {}
    for x = 1, gridW do
        newGrid[x] = {}
        for y = 1, gridH do
            local liveNeighbors = countNeighbors(grid, x, y)
            if grid[x][y] == 1 then
                newGrid[x][y] = (liveNeighbors == 2 or liveNeighbors == 3) and 1 or 0
            else
                newGrid[x][y] = (liveNeighbors == 3) and 1 or 0
            end
        end
    end
    return newGrid
end

-- Drawing the grid
local function drawGrid(grid)
    for x = 1, gridW do
        for y = 1, gridH do
            if grid[x][y] == 1 then
                draw.Color(10, 10, 10, 255)  -- Alive cells
                draw.FilledRect(windowX + (x - 1) * cellSize, windowY + (y - 1) * cellSize, windowX + x * cellSize, windowY + y * cellSize)
            else
                draw.Color(235, 235, 235, 255)  -- Dead cells
                draw.FilledRect(windowX + (x - 1) * cellSize, windowY + (y - 1) * cellSize, windowX + x * cellSize, windowY + y * cellSize)
            end
            draw.Color(161, 161, 161, 255)  -- Grid lines
            draw.OutlinedRect(windowX + (x - 1) * cellSize, windowY + (y - 1) * cellSize, windowX + x * cellSize, windowY + y * cellSize)
        end
    end
end

-- Main function
local lastUpdateTime = 0
callbacks.Register("Draw", function()
    local currentTime = globals.RealTime()
    if currentTime - lastUpdateTime > updateInterval then
        grid = updateGrid(grid)
        lastUpdateTime = currentTime
    end
    drawGrid(grid)
end)
