--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

This file handles the mod CheckAround and adds the custom keybinds.

]]--
--[[ ================================================ ]]--
local CheckAround = {
    -- for debug purposes
    highlightsSquares = {},

    -- lore names of the zombies
    defaultZombieName = getText("IGUI_CheckAround_zombieName"),
    defaultZombiesName = getText("IGUI_CheckAround_zombieName"),

    -- Voicelines when no zombies behind window
    Voicelines_BehindWindowsNoZombies = {
        getText("IGUI_CheckAround_BehindWindowsNoZombies1"),
        getText("IGUI_CheckAround_BehindWindowsNoZombies2"),
        getText("IGUI_CheckAround_BehindWindowsNoZombies3"),
        getText("IGUI_CheckAround_BehindWindowsNoZombies4"),
        getText("IGUI_CheckAround_BehindWindowsNoZombies5"),
        getText("IGUI_CheckAround_BehindWindowsNoZombies6"),
        getText("IGUI_CheckAround_BehindWindowsNoZombies7"),
        getText("IGUI_CheckAround_BehindWindowsNoZombies8"),
        getText("IGUI_CheckAround_BehindWindowsNoZombies9"),
        getText("IGUI_CheckAround_BehindWindowsNoZombies10"),
        getText("IGUI_CheckAround_BehindWindowsNoZombies11"),
        getText("IGUI_CheckAround_BehindWindowsNoZombies12")
    },

    -- Voicelines when zombies behind window
    Voicelines_zombiesBehindWindow = {
        getText("IGUI_CheckAround_zombiesBehindWindow1"),
        getText("IGUI_CheckAround_zombiesBehindWindow2"),
        getText("IGUI_CheckAround_zombiesBehindWindow3"),
        getText("IGUI_CheckAround_zombiesBehindWindow4"),
        getText("IGUI_CheckAround_zombiesBehindWindow5"),
        getText("IGUI_CheckAround_zombiesBehindWindow6"),
        getText("IGUI_CheckAround_zombiesBehindWindow7"),
        getText("IGUI_CheckAround_zombiesBehindWindow8"),
        getText("IGUI_CheckAround_zombiesBehindWindow9"),
        getText("IGUI_CheckAround_zombiesBehindWindow10"),
        getText("IGUI_CheckAround_zombiesBehindWindow11"),
        getText("IGUI_CheckAround_zombiesBehindWindow12")
    },

    -- Voicelines when no zombies behind door
    Voicelines_BehindDoorNoZombies = {
        getText("IGUI_CheckAround_BehindDoorNoZombies1"),
        getText("IGUI_CheckAround_BehindDoorNoZombies2"),
        getText("IGUI_CheckAround_BehindDoorNoZombies3"),
        getText("IGUI_CheckAround_BehindDoorNoZombies4"),
        getText("IGUI_CheckAround_BehindDoorNoZombies5"),
        getText("IGUI_CheckAround_BehindDoorNoZombies6"),
        getText("IGUI_CheckAround_BehindDoorNoZombies7"),
        getText("IGUI_CheckAround_BehindDoorNoZombies8"),
        getText("IGUI_CheckAround_BehindDoorNoZombies9"),
        getText("IGUI_CheckAround_BehindDoorNoZombies10"),
        getText("IGUI_CheckAround_BehindDoorNoZombies11"),
        getText("IGUI_CheckAround_BehindDoorNoZombies12")
    },

    -- Voicelines when zombies behind window
    Voicelines_zombiesBehindDoor = {
        getText("IGUI_CheckAround_zombiesBehindDoor1"),
        getText("IGUI_CheckAround_zombiesBehindDoor2"),
        getText("IGUI_CheckAround_zombiesBehindDoor3"),
        getText("IGUI_CheckAround_zombiesBehindDoor4"),
        getText("IGUI_CheckAround_zombiesBehindDoor5"),
        getText("IGUI_CheckAround_zombiesBehindDoor6"),
        getText("IGUI_CheckAround_zombiesBehindDoor7"),
        getText("IGUI_CheckAround_zombiesBehindDoor8"),
        getText("IGUI_CheckAround_zombiesBehindDoor9"),
        getText("IGUI_CheckAround_zombiesBehindDoor10"),
        getText("IGUI_CheckAround_zombiesBehindDoor11"),
        getText("IGUI_CheckAround_zombiesBehindDoor12")
    },

    -- Voicelines when no zombies upstairs
    Voicelines_CheckAroundNoZombies = {
        getText("IGUI_CheckAround_CheckAroundNoZombies1"),
        getText("IGUI_CheckAround_CheckAroundNoZombies2"),
        getText("IGUI_CheckAround_CheckAroundNoZombies3"),
        getText("IGUI_CheckAround_CheckAroundNoZombies4"),
        getText("IGUI_CheckAround_CheckAroundNoZombies5"),
        getText("IGUI_CheckAround_CheckAroundNoZombies6"),
        getText("IGUI_CheckAround_CheckAroundNoZombies7"),
        getText("IGUI_CheckAround_CheckAroundNoZombies8"),
        getText("IGUI_CheckAround_CheckAroundNoZombies9"),
        getText("IGUI_CheckAround_CheckAroundNoZombies10"),
        getText("IGUI_CheckAround_CheckAroundNoZombies11"),
        getText("IGUI_CheckAround_CheckAroundNoZombies12")
    },

    -- Voicelines when zombies upstairs
    Voicelines_zombieUpstairs = {
        getText("IGUI_CheckAround_zombiesUpstairs1"),
        getText("IGUI_CheckAround_zombiesUpstairs2"),
        getText("IGUI_CheckAround_zombiesUpstairs3"),
        getText("IGUI_CheckAround_zombiesUpstairs4"),
        getText("IGUI_CheckAround_zombiesUpstairs5"),
        getText("IGUI_CheckAround_zombiesUpstairs6"),
        getText("IGUI_CheckAround_zombiesUpstairs7"),
        getText("IGUI_CheckAround_zombiesUpstairs8"),
        getText("IGUI_CheckAround_zombiesUpstairs9"),
        getText("IGUI_CheckAround_zombiesUpstairs10"),
        getText("IGUI_CheckAround_zombiesUpstairs11"),
        getText("IGUI_CheckAround_zombiesUpstairs12")
    },

    -- Voicelines when no zombies downstairs
    Voicelines_CheckDownstairsNoZombies = {
        getText("IGUI_CheckAround_CheckDownstairsNoZombies1"),
        getText("IGUI_CheckAround_CheckDownstairsNoZombies2"),
        getText("IGUI_CheckAround_CheckDownstairsNoZombies3"),
        getText("IGUI_CheckAround_CheckDownstairsNoZombies4"),
        getText("IGUI_CheckAround_CheckDownstairsNoZombies5"),
        getText("IGUI_CheckAround_CheckDownstairsNoZombies6"),
        getText("IGUI_CheckAround_CheckDownstairsNoZombies7"),
        getText("IGUI_CheckAround_CheckDownstairsNoZombies8"),
        getText("IGUI_CheckAround_CheckDownstairsNoZombies9"),
        getText("IGUI_CheckAround_CheckDownstairsNoZombies10"),
        getText("IGUI_CheckAround_CheckDownstairsNoZombies11"),
        getText("IGUI_CheckAround_CheckDownstairsNoZombies12")
    },

    -- Voicelines when zombies downstairs
    Voicelines_zombieDownstairs = {
        getText("IGUI_CheckAround_zombiesDownstairs1"),
        getText("IGUI_CheckAround_zombiesDownstairs2"),
        getText("IGUI_CheckAround_zombiesDownstairs3"),
        getText("IGUI_CheckAround_zombiesDownstairs4"),
        getText("IGUI_CheckAround_zombiesDownstairs5"),
        getText("IGUI_CheckAround_zombiesDownstairs6"),
        getText("IGUI_CheckAround_zombiesDownstairs7"),
        getText("IGUI_CheckAround_zombiesDownstairs8"),
        getText("IGUI_CheckAround_zombiesDownstairs9"),
        getText("IGUI_CheckAround_zombiesDownstairs10"),
        getText("IGUI_CheckAround_zombiesDownstairs11"),
        getText("IGUI_CheckAround_zombiesDownstairs12")
    },

    -- Voicelines when zombies downstairs
    Voicelines_sporeZone = {
        getText("IGUI_CheckAround_sporeZone1"),
        getText("IGUI_CheckAround_sporeZone2"),
        getText("IGUI_CheckAround_sporeZone3"),
        getText("IGUI_CheckAround_sporeZone4"),
        getText("IGUI_CheckAround_sporeZone5"),
        getText("IGUI_CheckAround_sporeZone6"),
        getText("IGUI_CheckAround_sporeZone7"),
        getText("IGUI_CheckAround_sporeZone8"),
        getText("IGUI_CheckAround_sporeZone9"),
        getText("IGUI_CheckAround_sporeZone10"),
        getText("IGUI_CheckAround_sporeZone11"),
        getText("IGUI_CheckAround_sporeZone12")
    },
}

--#region Debug functions to highlight squares
-- Code by Rodriguo

if isDebugEnabled() then
    local enabled = true

    CheckAround.AddHighlightSquare = function(square, ISColors, priority)
        if not square or not ISColors then return end
        local existingSquare = CheckAround.highlightsSquares[square]
        if existingSquare and existingSquare.priority >= priority then return end

        CheckAround.highlightsSquares[square] = {color = ISColors, priority = priority}
    end

    CheckAround.RenderHighLights = function()
        if not enabled then return end

        -- if #CheckAround.highlightsSquares == 0 then return end
        for square, highlight in pairs(CheckAround.highlightsSquares) do
            local x,y,z = square:getX(), square:getY(), square:getZ()
            local color = highlight.color
            local r,g,b,a = color.r, color.g, color.b, color.a

            local floorSprite = IsoSprite.new()
            floorSprite:LoadFramesNoDirPageSimple('media/ui/FloorTileCursor.png')
            floorSprite:RenderGhostTileColor(x, y, z, r, g, b, a)
        end
    end
end

--#endregion

return CheckAround