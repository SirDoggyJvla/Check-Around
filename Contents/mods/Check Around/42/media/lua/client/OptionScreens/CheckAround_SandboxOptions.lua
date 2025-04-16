--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Patch SandboxOptions.lua to connect to the TLOU Spores panel and add new buttons to it.

]]--
--[[ ================================================ ]]--

--- CACHING
-- module
local CustomizeSandboxOptionPanel = require "DoggyTools/CustomizeSandboxOptionPanel"

local CheckAround_OnCreateSandboxOptions = function(CheckAround_panel)
    CustomizeSandboxOptionPanel.SetPanelColor(CheckAround_panel, {r=1,g=0,b=0,a=1}, {r=0.1,g=0,b=0,a=0.9})
end

local OnCreateSandboxOptions = require "DoggyEvents/OnCreateSandboxOptions"
OnCreateSandboxOptions.addListener(getText("Sandbox_CheckAround"),CheckAround_OnCreateSandboxOptions)
