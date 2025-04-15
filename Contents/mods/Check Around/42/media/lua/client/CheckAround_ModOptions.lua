--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

This file adds the custom keybinds.

]]--
--[[ ================================================ ]]--

local options = PZAPI.ModOptions:create("CheckAround", "Check Around")
options:addTitle("Check Around")
options:addDescription("Check Around your surrondings for threats (windows, doors, stairs...)")
options:addSeparator()
local OPTION_CHECKUPSTAIRS = options:addKeyBind("Check_Around", "Check Upstairs", Keyboard.KEY_NONE)

return {
    CheckUpstairs = OPTION_CHECKUPSTAIRS,
}