--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

This file handles the mod CheckUpstairs and adds the custom keybinds.

]]--
--[[ ================================================ ]]--
local CheckUpstairs = {
    -- for debug purposes
    highlightsSquares = {},

    -- lore names of the zombies
    defaultZombieName = getText("IGUI_CheckUpstairs_zombieName"),
    defaultZombiesName = getText("IGUI_CheckUpstairs_zombieName"),

    -- Voicelines when no zombies behind window
    Voicelines_BehindWindowsNoZombies = {
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies1"),
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies2"),
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies3"),
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies4"),
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies5"),
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies6"),
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies7"),
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies8"),
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies9"),
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies10"),
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies11"),
        getText("IGUI_CheckUpstairs_BehindWindowsNoZombies12")
    },

    -- Voicelines when zombies behind window
    Voicelines_zombiesBehindWindow = {
        getText("IGUI_CheckUpstairs_zombiesBehindWindow1"),
        getText("IGUI_CheckUpstairs_zombiesBehindWindow2"),
        getText("IGUI_CheckUpstairs_zombiesBehindWindow3"),
        getText("IGUI_CheckUpstairs_zombiesBehindWindow4"),
        getText("IGUI_CheckUpstairs_zombiesBehindWindow5"),
        getText("IGUI_CheckUpstairs_zombiesBehindWindow6"),
        getText("IGUI_CheckUpstairs_zombiesBehindWindow7"),
        getText("IGUI_CheckUpstairs_zombiesBehindWindow8"),
        getText("IGUI_CheckUpstairs_zombiesBehindWindow9"),
        getText("IGUI_CheckUpstairs_zombiesBehindWindow10"),
        getText("IGUI_CheckUpstairs_zombiesBehindWindow11"),
        getText("IGUI_CheckUpstairs_zombiesBehindWindow12")
    },

    -- Voicelines when no zombies upstairs
    Voicelines_CheckUpstairsNoZombies = {
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies1"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies2"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies3"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies4"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies5"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies6"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies7"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies8"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies9"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies10"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies11"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies12")
    },

    -- Voicelines when zombies upstairs
    Voicelines_zombieUpstairs = {
        getText("IGUI_CheckUpstairs_zombiesUpstairs1"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs2"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs3"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs4"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs5"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs6"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs7"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs8"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs9"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs10"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs11"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs12")
    },

    -- Voicelines when no zombies downstairs
    Voicelines_CheckDownstairsNoZombies = {
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies1"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies2"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies3"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies4"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies5"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies6"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies7"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies8"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies9"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies10"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies11"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies12")
    },

    -- Voicelines when zombies downstairs
    Voicelines_zombieDownstairs = {
        getText("IGUI_CheckUpstairs_zombiesDownstairs1"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs2"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs3"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs4"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs5"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs6"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs7"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs8"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs9"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs10"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs11"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs12")
    },
}

CheckUpstairs.ShowNametag = function(zombie)
    local zombieModData = zombie:getModData()
    zombieModData.CheckUpstairs_ticks = 200
    zombieModData.CheckUpstairs_nametag = TextDrawObject.new()
    zombieModData.CheckUpstairs_nametag:ReadString(UIFont.Small, CheckUpstairs.ZombieName, -1)
end

--#region Debug functions to highlight squares
-- Code by Rodriguo

local enabled = true

CheckUpstairs.AddHighlightSquare = function(square, ISColors)
    if not square or not ISColors then return end
    table.insert(CheckUpstairs.highlightsSquares, {square = square, color = ISColors})
end

CheckUpstairs.RenderHighLights = function()
    if not enabled then return end

    if #CheckUpstairs.highlightsSquares == 0 then return end
    for _, highlight in ipairs(CheckUpstairs.highlightsSquares) do
        if highlight.square ~= nil and instanceof(highlight.square, "IsoGridSquare") then
            local x,y,z = highlight.square:getX(), highlight.square:getY(), highlight.square:getZ()
            local r,g,b,a = highlight.color.r, highlight.color.g, highlight.color.b, 0.8

            local floorSprite = IsoSprite.new()
            floorSprite:LoadFramesNoDirPageSimple('media/ui/FloorTileCursor.png')
            floorSprite:RenderGhostTileColor(x, y, z, r, g, b, a)
        else
            print("Invalid square")
        end
    end
end

--#endregion

return CheckUpstairs