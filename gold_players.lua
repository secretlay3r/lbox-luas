-- Based on https://lmaobox.net/lua/Lua_Classes/DrawModelContext/#examples
-- Preview https://imgur.com/a/vGh4ajn

local newTexture = materials.Find("models/effects/muzzleflash/brightmuzzle")

local function onDrawModel(drawModelContext)
    local entity = drawModelContext:GetEntity()

    if entity:IsPlayer() then
        drawModelContext:ForcedMaterialOverride(newTexture)
    end
end

callbacks.Register("DrawModel", onDrawModel)
