--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

This file handles the mod CheckAround.

]]--
--[[ ================================================ ]]--
local CheckAround = require "CheckAround_module"
require "CheckAround"

-- set zombie lore name
Events.OnGameStart.Add(CheckAround.UpdateZombieName)

-- update visuals like nametags
Events.OnTick.Add(CheckAround.HandleVisuals)

-- key pressed
Events.OnKeyPressed.Add(CheckAround.KeyPress)

-- check context menu
Events.OnFillWorldObjectContextMenu.Add(CheckAround.OnFillWorldObjectContextMenu)
