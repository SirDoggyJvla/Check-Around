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

-- render debug highlight squares
-- Events.OnPostRender.Add(CheckAround.RenderHighLights)

-- set zombie lore name
Events.OnGameStart.Add(CheckAround.UpdateZombieName)

-- update visuals like nametags
Events.OnZombieUpdate.Add(CheckAround.HandleVisuals)

-- key pressed
Events.OnKeyPressed.Add(CheckAround.KeyPress)

-- check context menu
Events.OnFillWorldObjectContextMenu.Add(CheckAround.OnFillWorldObjectContextMenu)
