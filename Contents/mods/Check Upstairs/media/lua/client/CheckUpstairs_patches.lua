--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

This file handles the patches to CheckUpstairs with other mods.

DON'T RELOAD SINGLE FILE

]]--
--[[ ================================================ ]]--

-- requirements
local CheckUpstairs = require "CheckUpstairs_module"
local CheckUpstairsModOptions = require "CheckUpstairs_ModOptions"
CheckUpstairsModOptions = CheckUpstairsModOptions.options_data
require "CheckUpstairs"

-- check for activated mods for patches
local activatedMods_BB_SporeZones = getActivatedMods():contains("BB_SporeZones")

-- patch Cordyceps Spore Zones
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


-- patch controllers for checking upstairs

local Vanilla = {}

Vanilla.onPressButtonNoFocus = JoypadControllerData.onPressButtonNoFocus

local mainButtons = {
    "AButton",
    "BButton",
    "XButton",
    "YButton",
    "LBumper",
    "RBumper",
    "Back",
    "Start",
    "LStickButton",
    "RStickButton",
    "Other",
    "DPadLeft",
    "DPadRight",
    "DPadUp",
    "DPadDown",
}

local secondaryButtons = {
    nil,
    "RT",
    "LT",
    "RB",
    "LB",
}

local secondaryButtons_functions = {
    ["RT"] = isJoypadRTPressed,
    ["LT"] = isJoypadLTPressed,
    ["RB"] = isJoypadRBPressed,
    ["LB"] = isJoypadLBPressed,
}

-- code by Burryaga for adding keybinds for controllers
function JoypadControllerData:onPressButtonNoFocus(button)
    -- retrieve player
    local playerIndex = self.joypad.player or 0
    local player = getSpecificPlayer(playerIndex)

    -- check if my keybind
    local validConditions
    if player and player:isAlive() then
        -- check if secondary necessary and if pressed
        local secondaryButton = secondaryButtons[CheckUpstairsModOptions.CheckUpstairsDownstairs_secondary.value]
        if not secondaryButton or secondaryButtons_functions[secondaryButton](playerIndex) then
            -- check for main key
            local mainButton = mainButtons[CheckUpstairsModOptions.CheckUpstairsDownstairs_main.value]
            if button == Joypad[mainButton] then
                -- check upstairs
                validConditions = true
            end
        end
    end

    if not validConditions then return Vanilla.onPressButtonNoFocus(self, button) end

    CheckUpstairs.checkForZombies(player)
end