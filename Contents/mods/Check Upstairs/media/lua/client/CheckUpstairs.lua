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
local CheckUpstairs = {}

CheckUpstairs.getStairTopCoordinates = function(player)
    local square = player:getSquare()

    local top_square_x
    local top_square_y
    local top_square_z
    -- Y direction
    if square:HasStairsNorth() then
        local z = player:getZ()
        top_square_x = player:getX()
        top_square_y = - 3 + player:getY() + 3*z - 0.5
        top_square_z = math.floor(z) + 1

    -- X direction
    elseif square:HasStairsWest() then
        local z = player:getZ()
        top_square_x = - 3 + player:getX() + 3*z - 0.5
        top_square_y = player:getY()
        top_square_z = math.floor(z) + 1
    end

    if top_square_x then
        return {
            x = top_square_x,
            y = top_square_y,
            z = top_square_z,
        }
    end

    return nil
end

CheckUpstairs.getZombiesUpstairs = function(player,topCoordinates)
    -- get zombieList
    local zombieList = player:getCell():getZombieList()

    -- coordinates of square top of stairs
    local x = topCoordinates.x
    local y = topCoordinates.y
    local z = topCoordinates.z

    -- Get zombies top of the stairs in the Radius
    local radius = SandboxVars.CheckUpstairs.Radius  + 0.5
    local zombies = {}
    local zombie
    for i = 0, zombieList:size() - 1 do
        -- get zombie
        zombie = zombieList:get(i)
        -- check zombie is top floor or in stairs of top floor
        if math.floor(zombie:getZ()) == z then
            -- get distance
            local d = math.sqrt( (zombie:getX() - x)^2 + (zombie:getY() - y)^2 )
            -- check if in radius of square of top stairs
            if d <= radius then
                -- add zombie to the list
                table.insert(zombies,zombie)
            end
        end
    end

    return zombies
end

CheckUpstairs.ZombieName = getText("IGUI_CheckUpstairs_zombieName")
CheckUpstairs.ZombiesName = getText("IGUI_CheckUpstairs_zombiesName")

CheckUpstairs.Voicelines_noZombies = {
    getText("IGUI_CheckUpstairs_noZombies1"),
    getText("IGUI_CheckUpstairs_noZombies2"),
    getText("IGUI_CheckUpstairs_noZombies3"),
    getText("IGUI_CheckUpstairs_noZombies4"),
    getText("IGUI_CheckUpstairs_noZombies5"),
    getText("IGUI_CheckUpstairs_noZombies6"),
    getText("IGUI_CheckUpstairs_noZombies7"),
    getText("IGUI_CheckUpstairs_noZombies8"),
    getText("IGUI_CheckUpstairs_noZombies9"),
    getText("IGUI_CheckUpstairs_noZombies10"),
    getText("IGUI_CheckUpstairs_noZombies11"),
    getText("IGUI_CheckUpstairs_noZombies12")
}

CheckUpstairs.Voicelines_zombieUpstairs = {
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
}

-- Checks if zombies are upstairs and show then or make the character say a line, if in a staircase.
CheckUpstairs.checkUpstairs = function()
    local player = getPlayer()
    local topCoordinates = CheckUpstairs.getStairTopCoordinates(player)
    if not topCoordinates then return end

    local zombies = CheckUpstairs.getZombiesUpstairs(player,topCoordinates)
    local zombiesAmount = #zombies

    if zombiesAmount > 0 then
        local voiceLine = CheckUpstairs.Voicelines_zombieUpstairs[ZombRand(1,#CheckUpstairs.Voicelines_zombieUpstairs+1)]
        if zombiesAmount == 1 then
            player:Say(string.format(voiceLine,zombiesAmount,CheckUpstairs.ZombieName))
        else
            player:Say(string.format(voiceLine,zombiesAmount,CheckUpstairs.ZombiesName))
        end

        if SandboxVars.CheckUpstairs.ShowZombie then
            for _,zombie in ipairs(zombies) do
                CheckUpstairs.ShowNametag(zombie)
            end
        end
    else
        local voiceLine = CheckUpstairs.Voicelines_noZombies[ZombRand(1,#CheckUpstairs.Voicelines_noZombies+1)]
        player:Say(string.format(voiceLine,CheckUpstairs.ZombieName))
    end
end


-- Draws the nametag of the `zombie` based on the `ticks` value.
---@param zombie IsoZombie
---@param ticks int
CheckUpstairs.DrawNameTag = function(zombie,ticks)
    local zombieModData = zombie:getModData()

    -- initialize nametag
    if not zombieModData.CheckUpstairs_nametag then
        zombieModData.CheckUpstairs_nametag = TextDrawObject.new()
    end

    -- get zombie nametag
    local nametag = zombieModData.CheckUpstairs_nametag

    -- get initial position of zombie
    local sx = IsoUtils.XToScreen(zombie:getX(), zombie:getY(), zombie:getZ(), 0)
    local sy = IsoUtils.YToScreen(zombie:getX(), zombie:getY(), zombie:getZ(), 0)

    -- apply offset
    sx = sx - IsoCamera.getOffX() - zombie:getOffsetX()
    sy = sy - IsoCamera.getOffY() - zombie:getOffsetY()

    -- apply client vertical placement
    sy = sy - 110

    -- apply zoom level
    local zoom = getCore():getZoom(0)
    sx = sx / zoom
    sy = sy / zoom
    sy = sy - nametag:getHeight()

    -- apply string with font
    nametag:ReadString(UIFont.Small, CheckUpstairs.ZombieName, -1)

    -- apply visuals
    nametag:setDefaultColors(1,1,1,ticks/100)
    -- nametag:setOutlineColors(1,1,1,ticks/100)

    -- Draw nametag
    nametag:AddBatchedDraw(sx, sy, true)
end

CheckUpstairs.ShowNametag = function(zombie)
    local zombieModData = zombie:getModData()
    zombieModData.CheckUpstairs_ticks = 200
end

CheckUpstairs.HandleNametag = function(zombie)
    local zombieModData = zombie:getModData()

    -- skip if shouldn't show nametag
    local ticks = zombieModData.CheckUpstairs_ticks
    if not ticks then return end

    -- draw nametag
    CheckUpstairs.DrawNameTag(zombie,ticks)

    -- reduce tick value or stop showing nametag
    if zombieModData.CheckUpstairs_ticks > 0 then
        zombieModData.CheckUpstairs_ticks = ticks - 1
    else
        zombieModData.CheckUpstairs_ticks = nil
        zombieModData.CheckUpstairs_nametag = nil
    end
end

Events.OnZombieUpdate.Add(CheckUpstairs.HandleNametag)


--- Add the keybinds 
if ModOptions and ModOptions.AddKeyBinding then
    local checkUpstairs_key = {
        key = Keyboard.KEY_E,  --default
        name = "checkUpstairs",  -- just id (user won't see this name)
    }

    local function CheckUpstairs_keyPress(keynum)
        if keynum == checkUpstairs_key.key then
            CheckUpstairs.checkUpstairs()
        elseif keynum == checkUpstairs_key.key then
        end
    end
    Events.OnKeyPressed.Add(CheckUpstairs_keyPress)

    ModOptions:AddKeyBinding("[Combat]",checkUpstairs_key)
end

return CheckUpstairs