--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

This file handles the mod CheckUpstairs.

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
