-- BuildAnywhere
-- Lets you landscape, paint terrain, paint foliage, plant trees, build fences,
-- place buildings and cut trees on ALL land, also farmland you do not own.
--
-- The game only checks land ownership in a few places:
--   - ConstructionBrush:verifyAccess          (client, every build menu brush)
--   - Landscaping.isModificationAreaOnOwnedLand (server, sculpt/paint/foliage validation)
--   - Chainsaw:isCuttingAllowed              (chainsaw)
-- Store spawn places, restricted zones and farm permissions keep working as normal.

BuildAnywhere = {}
BuildAnywhere.ALLOW_CHAINSAW = true

local function allowAllLand()
    return true
end

-- Runs func while AccessHandler:canFarmAccessLand always returns true, so only the
-- ownership part of a check is skipped and every other check still runs.
local function withLandAccess(func, ...)
    local handler = g_currentMission ~= nil and g_currentMission.accessHandler or nil
    if handler == nil then
        return func(...)
    end

    local instanceFunc = rawget(handler, "canFarmAccessLand")
    handler.canFarmAccessLand = allowAllLand
    local ok, result = pcall(func, ...)
    handler.canFarmAccessLand = instanceFunc

    if not ok then
        error(result, 0)
    end
    return result
end

-- Build menu brushes (sculpt, paint, foliage, trees, fences, placeables)
ConstructionBrush.verifyAccess = Utils.overwrittenFunction(ConstructionBrush.verifyAccess, function(self, superFunc, x, y, z)
    return withLandAccess(superFunc, self, x, y, z)
end)

-- Terrain deformation / painting validation, runs on the server in multiplayer
Landscaping.isModificationAreaOnOwnedLand = function(x, z, radius, smoothingDistance, farmlandManager, farmId)
    return true
end

-- Chainsaw (the "cutTrees" farm permission is still required)
if BuildAnywhere.ALLOW_CHAINSAW and Chainsaw ~= nil and Chainsaw.isCuttingAllowed ~= nil then
    Chainsaw.isCuttingAllowed = Utils.overwrittenFunction(Chainsaw.isCuttingAllowed, function(self, superFunc, x, y, z, shape)
        return withLandAccess(superFunc, self, x, y, z, shape)
    end)
end

print("BuildAnywhere: build, landscape and paint on all land enabled")
