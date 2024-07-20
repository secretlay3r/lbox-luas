-- Based on https://github.com/DemonLoverHvH/lmaoboxluas/blob/main/tracers.lua

function RGBRainbow(frequency)
    local curtime = globals.CurTime()
    local r,g,b
    r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
    g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
    b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

    return r, g, b
end

local width, height = draw.GetScreenSize()

local function update()
    local r, g, b = RGBRainbow(0.5) -- Color change rate is in parentheses
    local players = entities.FindByClass("CTFPlayer")
    local localPlayer = entities.GetLocalPlayer()
    local myteam = localPlayer:GetTeamNumber()

    if (myteam == 0) then
        return
    else
        for i, p in ipairs(players) do
            local team = p:GetTeamNumber()
            if p:IsAlive() and p ~= localPlayer and not p:IsDormant() and myteam ~= team then
                local screenPos = client.WorldToScreen(p:GetAbsOrigin())

                draw.Color(r, g, b, 225)

                if screenPos ~= nil then
                    local lineWidth = 3
                    for i = -lineWidth, lineWidth do
                        draw.Line(width / 2 + i, height, screenPos[1] + i, screenPos[2])
                    end
                end
            end
        end
    end
end

callbacks.Register("Draw", "draw", update)