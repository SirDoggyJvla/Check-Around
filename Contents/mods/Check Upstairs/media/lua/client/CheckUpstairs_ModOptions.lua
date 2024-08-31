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

local CheckUpstairs = require "CheckUpstairs_module"
require "CheckUpstairs"


-- keybind for checking upstairs or downstairs
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


-- Mod options such as Joypad controls
local name = getText("IGUI_CheckUpstairs")
local CheckUpstairsModOptions = {
    options_data = {
        -- main button for joypad users
		CheckUpstairsDownstairs_main = {
			-- choices
            getText("IGUI_CheckUpstairs_AButton"),
            getText("IGUI_CheckUpstairs_BButton"),
            getText("IGUI_CheckUpstairs_XButton"),
            getText("IGUI_CheckUpstairs_YButton"),
            getText("IGUI_CheckUpstairs_LBumper"),
            getText("IGUI_CheckUpstairs_RBumper"),
            getText("IGUI_CheckUpstairs_Back"),
            getText("IGUI_CheckUpstairs_Start"),
            getText("IGUI_CheckUpstairs_LStickButton"),
            getText("IGUI_CheckUpstairs_RStickButton"),
            getText("IGUI_CheckUpstairs_Other"),
            getText("IGUI_CheckUpstairs_DPadLeft"),
            getText("IGUI_CheckUpstairs_DPadRight"),
            getText("IGUI_CheckUpstairs_DPadUp"),
            getText("IGUI_CheckUpstairs_DPadDown"),

			-- properties
			name = getText("IGUI_CheckUpstairs_mainJoypad"),
			tooltip = getText("IGUI_CheckUpstairs_mainJoypad_tooltip"),
			default = 1,
		},

        -- secondary button for joypad users
		CheckUpstairsDownstairs_secondary = {
			-- choices
            getText("IGUI_CheckUpstairs_None"),
            getText("IGUI_CheckUpstairs_RT"),
            getText("IGUI_CheckUpstairs_LT"),
            getText("IGUI_CheckUpstairs_RB"),
            getText("IGUI_CheckUpstairs_LB"),

			-- properties
			name = getText("IGUI_CheckUpstairs_secondaryJoypad"),
			tooltip = getText("IGUI_CheckUpstairs_secondaryJoypad_tooltip"),
			default = 4,
		},
    },


    -- option informations
    mod_id = 'CheckUpstairs',
    mod_shortname = name,
    mod_fullname = name,
}

-- adds the options
ModOptions:getInstance(CheckUpstairsModOptions)

return CheckUpstairsModOptions