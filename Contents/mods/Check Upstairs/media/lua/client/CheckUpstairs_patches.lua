--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

This file handles the patches to CheckUpstairs with other mods.

]]--
--[[ ================================================ ]]--

-- requirements
local CheckUpstairs = require "CheckUpstairs_module"

-- check for activated mods for patches
local activatedMods_BB_SporeZones = getActivatedMods():contains("BB_SporeZones")

if activatedMods_BB_SporeZones then

    CheckUpstairs.CheckForSporeZone = function(player,square)
        local isSporeZone = false

        -- retrieve building if any
        local building = square:getBuilding()
        if building then
            -- retrieve building reference square for spore zone
            local buildingDef = building:getDef()
            local zCoord = (buildingDef:getFirstRoom() and buildingDef:getFirstRoom():getZ()) or 0
            local buildingSq = player:getCell():getGridSquare(buildingDef:getX(), buildingDef:getY(), zCoord)

            if buildingSq then
                -- check if spore zone
                isSporeZone = buildingSq:getModData().isSporeZone
                if isSporeZone then
                    -- retrieve voice line
                    local voiceLines = CheckUpstairs.Voicelines_sporeZone
                    local voiceLine = voiceLines[ZombRand(1,#voiceLines+1)]

                    -- apply voiceline
                    player:Say(voiceLine)
                end
            end
        end
    end

end