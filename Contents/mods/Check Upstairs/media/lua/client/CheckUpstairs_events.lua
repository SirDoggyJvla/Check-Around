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
local CheckUpstairs = require "CheckUpstairs_module"
require "CheckUpstairs"

-- render debug highlight squares
-- Events.OnPostRender.Add(CheckUpstairs.RenderHighLights)

-- set zombie lore name
Events.OnGameStart.Add(CheckUpstairs.UpdateZombieName)

-- update visuals like nametags
Events.OnZombieUpdate.Add(CheckUpstairs.HandleVisuals)

-- check context menu
Events.OnFillWorldObjectContextMenu.Add(CheckUpstairs.OnFillWorldObjectContextMenu)


-- Add the keybinds with Mod Options
if ModOptions and ModOptions.AddKeyBinding then
    local checkUpstairs_key = {
        key = Keyboard.KEY_E,  --default
        name = "checkUpstairs",  -- just id (user won't see this name)
    }

    local function CheckUpstairs_keyPress(keynum)
        if keynum == checkUpstairs_key.key then
            CheckUpstairs.checkForZombies()
        end
    end
    Events.OnKeyPressed.Add(CheckUpstairs_keyPress)

    ModOptions:AddKeyBinding("[Combat]",checkUpstairs_key)
end