-- Requires alib library (https://github.com/uosq/lbox-alib)
-- Based on https://github.com/Muqa1/Muqa-LBOX-pastas/blob/main/Binds.lua
-- Preview https://imgur.com/a/Mwa4yQU

local alib = require('alib')

local font_name = 'Consolas'
local font_size = 16

-- Window theme
local window_theme = alib.theme:new(
    font_name,
    alib.rgba(20, 20, 20, 200), -- Bg
    nil,
    nil,
    alib.rgba(255, 0, 120, 130) -- Border
)

-- Creating window
local window = alib.window:create(
    'Binds Window',
    5, 500, 160, 100, -- xy and size of the window
    window_theme,
    1,
    nil
)

-- Text theme
local txt_theme = alib.theme:new(
    font_name,
    nil, -- Bg
    nil, -- Border
    alib.rgba(255, 255, 255, 255), -- White text
    nil -- Selection
)

local function create_text(name, x, y, text, color)
    local text_element = alib.text:new(name, x, y, window, txt_theme, text)
    text_element.color = color
    return text_element
end

local function update_text()
    -- Getting GUI values
    local FLvalue = gui.GetValue("Fake Lag Value (ms)") + 15
    local DTticks = warp.GetChargedTicks()
    local Fake_latency = gui.GetValue("Fake Latency Value (ms)")


    local antiaim_status = gui.GetValue("Anti Aim") == 1 and "ON" or "OFF"
    local antiaim_color = antiaim_status == "ON" and alib.rgba(0, 255, 0) or alib.rgba(255, 0, 0)

    local fakelag_status = gui.GetValue("Fake Lag") == 1 and tostring(FLvalue) or "OFF"
    local fakelag_color = fakelag_status ~= "OFF" and alib.rgba(0, 255, 0) or alib.rgba(255, 0, 0)

    local doubletap_ticks = DTticks >= 1 and tostring(DTticks + 1) or tostring(DTticks)
    local fake_latency = gui.GetValue("Fake Latency") >= 1 and tostring(Fake_latency / 1000) or "OFF"
    local fake_latency_color = fake_latency ~= "OFF" and alib.rgba(0, 255, 0) or alib.rgba(255, 0, 0)

    -- Creating text
    local texts = {
        create_text("Anti Aim", 10, 10, "Anti Aim: " .. antiaim_status, antiaim_color),
        create_text("Fake Lag", 10, 30, "Fake Lag: " .. fakelag_status, fakelag_color),
        create_text("Double Tap Ticks", 10, 50, "Double Tap Ticks: " .. doubletap_ticks, alib.rgba(255, 255, 255)),
        create_text("Fake Latency", 10, 70, "Fake Latency: " .. fake_latency, fake_latency_color)
    }

    return texts
end

local texts = update_text()

callbacks.Register("Draw", 'render', function()
    window:render()
    for _, text in ipairs(texts) do
        text:render()
    end
end)

callbacks.Register("Draw", "UpdateText", function()
    texts = update_text()
end)

-- Removing stuff on unload
callbacks.Register("Unload", function()
    for _, text in ipairs(texts) do
        text.visible = false
    end
    callbacks.Unregister("Draw", 'render')
    callbacks.Unregister("Draw", "UpdateText")
end)
