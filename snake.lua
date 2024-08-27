-- Preview https://imgur.com/a/VtwCtbf

-----------Main config-----------
local cellSize = 20
local gridW, gridH = 30, 30
local windowX, windowY = 100, 100
local snakeSpeed = 0.1
local snakeColor = {0, 200, 0, 255}
local foodColor = {255, 66, 55, 255}
local gameSpaceColor = {0, 0, 0, 50}
local textColor = {255, 255, 255, 255}
---------------------------------

-- Snake
local snake = {}
local direction = {x = 1, y = 0}
local food = {x = math.random(1, gridW), y = math.random(1, gridH)}
local lastUpdateTime = 0
local gameOver = false
local score = 0

-- Controls
local KEY_W = 33
local KEY_A = 11
local KEY_S = 29
local KEY_D = 14
local KEY_R = 28

local function snakeGame()
    snake = {
        {x = math.floor(gridW / 2), y = math.floor(gridH / 2)}
    }
    direction = {x = 1, y = 0}
    food = {x = math.random(1, gridW), y = math.random(1, gridH)}
    gameOver = false
    score = 0
end

local function checkCollision(newHead)
    -- Checking self collision
    for _, segment in ipairs(snake) do
        if segment.x == newHead.x and segment.y == newHead.y then
            return true
        end
    end
    return false
end

local function spawnFood()
    food.x = math.random(1, gridW)
    food.y = math.random(1, gridH)
end

local function updatePos()
    -- New head pos
    local newHead = {
        x = (snake[1].x + direction.x - 1) % gridW + 1,
        y = (snake[1].y + direction.y - 1) % gridH + 1
    }
    
    if checkCollision(newHead) then
        gameOver = true
        return
    end
    
    -- Adding new head
    table.insert(snake, 1, newHead)
    
    if newHead.x == food.x and newHead.y == food.y then
        spawnFood()
        score = score + 1
    else
        table.remove(snake)
    end
end

local function drawGame()
    -- Active field
    draw.Color(gameSpaceColor[1], gameSpaceColor[2], gameSpaceColor[3], gameSpaceColor[4])
    draw.OutlinedRect(windowX, windowY, windowX + gridW * cellSize, windowY + gridH * cellSize)
    
    -- Snake
    draw.Color(snakeColor[1], snakeColor[2], snakeColor[3], snakeColor[4])
    for _, segment in ipairs(snake) do
        draw.FilledRect(windowX + (segment.x - 1) * cellSize, windowY + (segment.y - 1) * cellSize, windowX + segment.x * cellSize, windowY + segment.y * cellSize)
    end
    
    -- Apples
    draw.Color(foodColor[1], foodColor[2], foodColor[3], foodColor[4])
    draw.FilledRect(windowX + (food.x - 1) * cellSize, windowY + (food.y - 1) * cellSize, windowX + food.x * cellSize, windowY + food.y * cellSize)
    
    -- Game Over
    if gameOver then
        draw.Color(textColor[1], textColor[2], textColor[3], textColor[4])
        local centerX = windowX + gridW * cellSize / 2
        local centerY = windowY + gridH * cellSize / 2
        
        draw.Text(centerX - 50, centerY - 40, "     Game Over!")
        draw.Text(centerX - 50, centerY - 10, "       Score: " .. score)
        draw.Text(centerX - 50, centerY + 20, "Press R to Restart")
    end
end

local function controls()
    if input.IsButtonDown(KEY_W) and direction.y == 0 then
        direction.x, direction.y = 0, -1
    elseif input.IsButtonDown(KEY_A) and direction.x == 0 then
        direction.x, direction.y = -1, 0
    elseif input.IsButtonDown(KEY_S) and direction.y == 0 then
        direction.x, direction.y = 0, 1
    elseif input.IsButtonDown(KEY_D) and direction.x == 0 then
        direction.x, direction.y = 1, 0
    end
end

local function restartGame()
    if input.IsButtonDown(KEY_R) then
        snakeGame()
    end
end

-- Main function
callbacks.Register("Draw", function()
    local currentTime = globals.RealTime()
    if currentTime - lastUpdateTime > snakeSpeed then
        if not gameOver then
            controls()
            updatePos()
        end
        lastUpdateTime = currentTime
    end
    restartGame()
    drawGame()
end)

snakeGame()