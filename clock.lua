-- Based on FPS Counter https://lmaobox.net/lua/#top-examples

function RGBRainbow(frequency)
    local curtime = globals.CurTime()
    local r, g, b
    r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
    g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
    b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

    return r, g, b
end

local consolas = draw.CreateFont("Consolas", 17, 500)

local function drawClock()
    draw.SetFont(consolas)

    local r, g, b = RGBRainbow(0.5) -- Color change rate is in parentheses

    -- Set color (for white version: uncomment next line and comment draw.Color(r, g, b, 255))
    --draw.Color(255, 255, 255, 255)
    draw.Color(r, g, b, 255)

    -- Get the current time
    local currTime = os.time()

    -- Format time in 12-hour format
    local time = os.date("%I:%M:%S %p", currTime)
    -- Uncomment for time in 24-hour format and comment 12-hour format
    --local time = os.date("%H:%M:%S", currTime)

    draw.Text(8, 8, "[Local Time: " .. time .. "]")
end

callbacks.Register("Draw", "drawClock", drawClock)
