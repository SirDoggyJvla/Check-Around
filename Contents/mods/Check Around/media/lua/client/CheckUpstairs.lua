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

-- requirements
local CheckUpstairs = require "CheckUpstairs_module"
require "CheckUpstairs_patches"

-- check for activated mods for patches
local activatedMods_BB_SporeZones = getActivatedMods():contains("BB_SporeZones")

CheckUpstairs.UpdateZombieName = function()
    CheckUpstairs.ZombieName = SandboxVars.CheckUpstairs.loreNameSingular ~= "" and SandboxVars.CheckUpstairs.loreNameSingular or CheckUpstairs.defaultZombieName
    CheckUpstairs.ZombiesName = SandboxVars.CheckUpstairs.loreNamePlurial ~= "" and SandboxVars.CheckUpstairs.loreNamePlurial or CheckUpstairs.defaultZombiesName
end

-- Apply the voiceline based on the amount of `zombies` and the given voicelines.
---@param player IsoPlayer
---@param zombies table
---@param voicelines_noZombies table
---@param voicelines_zombies table
CheckUpstairs.applyVoiceline = function(player,zombies,voicelines_noZombies,voicelines_zombies)
    local zombiesAmount = #zombies

    if zombiesAmount > 0 then
        local voiceLine = voicelines_zombies[ZombRand(1,#voicelines_zombies+1)]
        if zombiesAmount == 1 then
            player:Say(string.format(voiceLine,zombiesAmount,CheckUpstairs.ZombieName))
        else
            player:Say(string.format(voiceLine,zombiesAmount,CheckUpstairs.ZombiesName))
        end

        if SandboxVars.CheckUpstairs.ShowZombieNametag then
            for _,zombie in ipairs(zombies) do
                CheckUpstairs.ShowNametag(zombie)
            end
        end
    else
        local voiceLine = voicelines_noZombies[ZombRand(1,#voicelines_noZombies+1)]
        player:Say(string.format(voiceLine,CheckUpstairs.ZombieName))
    end
end

-- Retrieves zombies upstairs and adds them to a table.
---@param player IsoPlayer
---@param coordinates table 
---@return table
CheckUpstairs.getZombiesInRadius = function(player,coordinates)
    -- get zombieList
    local zombieList = player:getCell():getZombieList()

    -- coordinates of square top of stairs
    local x = coordinates.x
    local y = coordinates.y
    local z = coordinates.z

    -- Get zombies top of the stairs in the Radius
    local radius = SandboxVars.CheckUpstairs.Radius  + 0.5
    local zombies = {}
    local zombie, z_z
    for i = 0, zombieList:size() - 1 do
        -- get zombie
        zombie = zombieList:get(i)

        -- get zombie coordinates
        z_z = zombie:getZ()

        -- check zombie is top floor or in stairs of top floor
        if z_z - z_z%1 == z then
            -- get distance
            local d = math.sqrt( (zombie:getX() - x)^2 + (zombie:getY() - y)^2 )
            -- check if in radius of square of top stairs
            if d <= radius then
                -- add zombie to the table
                table.insert(zombies,zombie)
            end
        end
    end

    return zombies
end



--#region Check for zombies stairs

-- Retrieves coordinates of the square at the top of the stairs, if the player is positioned on the stairs
-- or at the square at the bottom.
---@param player IsoPlayer
---@return table|nil
CheckUpstairs.getStairTopCoordinates = function(player)
    -- get player coordinates and square
    local x = player:getX()
    local y = player:getY()
    local z = player:getZ()
    local square = player:getSquare()
    -- player is probably in the air
    if not square then return nil end

    local top_square_x
    local top_square_y
    local top_square_z
    -- Y direction
    if square:HasStairsNorth() then
        top_square_x = x
        top_square_y = - 3 + y + 3*(z - math.floor(z)) - 0.5
        top_square_z = math.floor(z) + 1

    -- X direction
    elseif square:HasStairsWest() then
        top_square_x = - 3 + x + 3*(z - math.floor(z)) - 0.5
        top_square_y = y
        top_square_z = math.floor(z) + 1

    -- check if square adjacent is stairs
    else
        -- check X direction
        square = getSquare(x-1,y,z)
        if square and square:HasStairsWest() then
            top_square_x = - 4 + x + 3*(z - math.floor(z))
            top_square_y = y
            top_square_z = math.floor(z) + 1
        end

        -- check Y direction
        square = getSquare(x,y-1,z)
        if square and square:HasStairsNorth() then
            top_square_x = - 4 + x + 3*(z - math.floor(z))
            top_square_y = y
            top_square_z = math.floor(z) + 1
        end
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

-- Retrieves coordinates of the square at the bottom of the stairs, if the player is positioned at the top
-- square.
---@param player IsoPlayer
---@return table|nil
CheckUpstairs.getStairBottomCoordinates = function(player)
    -- player coordinates
    local x = player:getX()
    local y = player:getY()
    local z = player:getZ()

    -- prepare variables
    local top_square_x
    local top_square_y
    local top_square_z

    -- verify floor below exists (until B42 release at least)
    local z_below = z-1
    if z_below < 0 then return nil end

    -- check Y direction
    local square = getSquare(x,y+1,z_below)
    if square and square:HasStairsNorth() then
        top_square_x = x
        top_square_y =  4 + y + 3*(z - math.floor(z))
        top_square_z = math.floor(z) - 1
    end

    -- check X direction
    square = getSquare(x+1,y,z_below)
    if square and square:HasStairsWest() then
        top_square_x =  4 + x + 3*(z - math.floor(z))
        top_square_y = y
        top_square_z = math.floor(z) - 1
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

CheckUpstairs.checkForZombies_upstairs = function(player)
    -- retrieve top coordinates of the stair
    local topCoordinates = CheckUpstairs.getStairTopCoordinates(player)
    if topCoordinates then
        local zombies = CheckUpstairs.getZombiesInRadius(player,topCoordinates)
        CheckUpstairs.applyVoiceline(player,zombies,CheckUpstairs.Voicelines_CheckUpstairsNoZombies,CheckUpstairs.Voicelines_zombieUpstairs)
    end
end

CheckUpstairs.checkForZombies_downstairs = function(player)
    -- retrieve top coordinates of the stair
    local bottomCoordinates = CheckUpstairs.getStairBottomCoordinates(player)
    if bottomCoordinates then
        local zombies = CheckUpstairs.getZombiesInRadius(player,bottomCoordinates)
        CheckUpstairs.applyVoiceline(player,zombies,CheckUpstairs.Voicelines_CheckDownstairsNoZombies,CheckUpstairs.Voicelines_zombieDownstairs)
    end
end

-- Checks if zombies are upstairs and show then or make the character say a line, if in a staircase.
CheckUpstairs.checkForZombies = function(player)
    player = player or getPlayer()

    CheckUpstairs.checkForZombies_upstairs(player)
    CheckUpstairs.checkForZombies_downstairs(player)
end

--#endregion



--#region Check for zombies window and doors

-- Checks for zombies behind the window.
---@param _ any
---@param playerIndex int
---@param window IsoThumpable|IsoWindow
CheckUpstairs.CheckWindow = function(_, playerIndex, window)
    local square = window:getSquare()

    local player = getSpecificPlayer(playerIndex)
    if not player then return end

    local x = player:getX()
    local y = player:getY()

    local x_square = square:getX()
    local y_square = square:getY()

    local square_opposite = window:getOppositeSquare()

    local north = window:getNorth()
    local square_check = square
    if north then
        if math.floor(y) == y_square then
            square_check = square_opposite
        end
    else
        if math.floor(x) == x_square then
            square_check = square_opposite
        end
    end

    -- retrieve zombies in radius
    local zombies = CheckUpstairs.getZombiesInRadius(player,{x = square_check:getX(),y = square_check:getY(),z = square_check:getZ()})
    CheckUpstairs.applyVoiceline(player,zombies,CheckUpstairs.Voicelines_BehindWindowsNoZombies,CheckUpstairs.Voicelines_zombiesBehindWindow)

    -- Cordyceps Spore Zone compatibility
    if activatedMods_BB_SporeZones then
        CheckUpstairs.CheckForSporeZone(player,square_check)
    end
end

-- Checks for zombies behind the window.
---@param _ any
---@param playerIndex int
---@param door IsoThumpable|IsoDoor
CheckUpstairs.CheckDoor = function(_, playerIndex, door)
    local square = door:getSquare()

    local player = getSpecificPlayer(playerIndex)
    if not player then return end

    local x = player:getX()
    local y = player:getY()

    local x_square = square:getX()
    local y_square = square:getY()

    local square_opposite = door:getOppositeSquare()

    local north = door:getNorth()
    local square_check = square
    if north then
        if math.floor(y) == y_square then
            square_check = square_opposite
        end
    else
        if math.floor(x) == x_square then
            square_check = square_opposite
        end
    end

    -- retrieve zombies in radius
    local zombies = CheckUpstairs.getZombiesInRadius(player,{x = square_check:getX(),y = square_check:getY(),z = square_check:getZ()})
    CheckUpstairs.applyVoiceline(player,zombies,CheckUpstairs.Voicelines_BehindDoorNoZombies,CheckUpstairs.Voicelines_zombiesBehindDoor)

    -- Cordyceps Spore Zone compatibility
    if activatedMods_BB_SporeZones then
        CheckUpstairs.CheckForSporeZone(player,square_check)
    end
end

-- Checks for zombies behind the window.
---@param _ any
---@param playerIndex int
---@param door IsoThumpable|IsoDoor
CheckUpstairs.PeekDoor = function(_, playerIndex, door)
    local player = getSpecificPlayer(playerIndex)

    -- get player stats
    local Lightfoot = player:getPerkLevel(Perks.Lightfoot)
    local Nimble = player:getPerkLevel(Perks.Nimble)
    local Sneak = player:getPerkLevel(Perks.Sneak)
    local Graceful = player:HasTrait("Graceful") and 10 or 0
    local Inconspicuous = player:HasTrait("Inconspicuous") and 10 or 0
    local Conspicuous = player:HasTrait("Conspicuous") and 10 or 0
    local Clumsy = player:HasTrait("Clumsy") and 10 or 0

    -- get default value for success chance which is normalized door health
    local doorHealth = door:getHealth()/door:getMaxHealth() * 100

    -- calculate success chance
    local successChance = doorHealth + Lightfoot + Nimble + Sneak + Graceful + Inconspicuous - Conspicuous - Clumsy

    -- if not success, play a sound
    local success = successChance <= 0 or successChance >= 100 or successChance >= ZombRand(100)
    if not success then
        local emitter = getWorld():getFreeEmitter()
        local square = door:getSquare()
        emitter:playSoundImpl("DoorCreek"..tostring(ZombRand(1,16)),square)
        local radius = SandboxVars.CheckUpstairs.Radius + 1
        addSound(nil, square:getX(), square:getY(), square:getZ(), radius, radius)
    end

    CheckUpstairs.CheckDoor(_, playerIndex, door)
end

-- Retrieve informations of `object`, an `IsoThumpable`:
-- - `isWindow`
-- - `isOpen`
-- - `hasCurtainClosed`
-- - `isDoor`
---@param object IsoThumpable
---@return boolean|nil -- isWindow
---@return boolean|nil -- isOpen
---@return boolean|nil -- hasCurtainClosed
---@return boolean|nil -- isDoor
---@return boolean|nil -- isBarricaded (for doors)
CheckUpstairs.GetIsoThumpableInformations = function(object)
    local isWindow
    local isOpen
    local hasCurtainClosed
    local isDoor
    local isBarricaded = object:isBarricaded()

    local isDoorFrame = object:isDoorFrame()

    -- to iterate through objects on the same square
    local objects
    local getObject

    -- object is a window
    if object:isWindow() then
        isWindow = true
        isOpen = true

        -- check if window is on IsoThumpable and check for that window stats instead
        objects = object:getSquare():getObjects()
        for i = 0, objects:size() - 1 do
            getObject = objects:get(i)
            if instanceof(getObject,"IsoWindow") and getObject:getNorth() == object:getNorth() then
                return CheckUpstairs.GetIsoWindowInformations(getObject)
            end
        end

        -- check for curtains
        local curtains = object:HasCurtains()
        hasCurtainClosed = curtains and not curtains:IsOpen()

        -- check for barricades to make sure window is open
        if isBarricaded then
            local barricades = object:getBarricadeOnSameSquare()
            local blockVision = barricades and barricades:isBlockVision()

            if blockVision then
                isOpen = false
            else
                barricades = object:getBarricadeOnOppositeSquare()
                if barricades and barricades:isBlockVision() then
                    isOpen = false
                end
            end
        end

    -- object is a door
    elseif object:isDoor() or isDoorFrame then
        isDoor = true
        isOpen = object:IsOpen() or object:isDestroyed() or isDoorFrame

        -- check if door is on IsoThumpable and check for that door stats instead
        objects = object:getSquare():getObjects()
        for i = 0, objects:size() - 1 do
            getObject = objects:get(i)
            if instanceof(getObject,"IsoDoor") and getObject:getNorth() == object:getNorth() then
                return CheckUpstairs.GetIsoDoorInformations(getObject)
            elseif instanceof(getObject,"IsoThumpable") and getObject:getNorth() == object:getNorth() then
                print(getObject)
                if getObject:isDoor() then
                    return CheckUpstairs.GetIsoDoorInformations(getObject)
                end
            end
        end
    end

    return isWindow, isOpen, hasCurtainClosed, isDoor, isBarricaded
end

-- Retrieve informations of `object`, an `IsoDoor`:
-- - `isWindow`
-- - `isOpen`
-- - `hasCurtainClosed`
-- - `isDoor`
---@param object IsoWindow
---@return nil -- not a window
---@return boolean|nil -- isOpen
---@return nil -- don't care about curtains
---@return boolean|nil -- isDoor
---@return boolean|nil -- isBarricaded (for doors)
CheckUpstairs.GetIsoDoorInformations = function(object)
    local isDoor = true
    local isOpen = object:IsOpen() or object:isDestroyed()
    local isBarricaded = object:isBarricaded()

    return nil, isOpen, nil, isDoor, isBarricaded
end

-- Retrieve informations of `object`, an `IsoWindow`:
-- - `isWindow`
-- - `isOpen`
-- - `hasCurtainClosed`
-- - `isDoor`
---@param object IsoWindow
---@return boolean|nil -- isWindow
---@return boolean|nil -- isOpen
---@return boolean|nil -- hasCurtainClosed
---@return nil -- not a door
---@return boolean|nil -- isBarricaded (for doors)
CheckUpstairs.GetIsoWindowInformations = function(object)
    local isWindow = true
    local isOpen = object:IsOpen() or object:isDestroyed()
    local hasCurtainClosed
    local isBarricaded = object:isBarricaded()

    local curtains = object:HasCurtains()
    hasCurtainClosed = curtains and not curtains:IsOpen()

    -- check for barricades to make sure window is open
    if isOpen and isBarricaded then
        local barricades = object:getBarricadeOnSameSquare()
        local blockVision = barricades and barricades:isBlockVision()

        if blockVision then
            isOpen = false
        else
            barricades = object:getBarricadeOnOppositeSquare()
            if barricades and barricades:isBlockVision() then
                isOpen = false
            end
        end
    end

    return isWindow, isOpen, hasCurtainClosed, nil, isBarricaded
end

-- Check if `object` is a window and it's various states.
---@param object any
---@return boolean|nil -- isWindow
---@return boolean|nil -- isOpen
---@return boolean|nil -- hasCurtainClosed
---@return boolean|nil -- isDoor
---@return boolean|nil -- isBarricaded (for doors)
CheckUpstairs.IsWindowOrDoor = function(object)
    if instanceof(object,"IsoWindow") then
        return CheckUpstairs.GetIsoWindowInformations(object)
    elseif instanceof(object,"IsoDoor") then
        return CheckUpstairs.GetIsoDoorInformations(object)
    elseif instanceof(object,"IsoThumpable") then
        return CheckUpstairs.GetIsoThumpableInformations(object)
    end

    -- IF ISOBOJECT, YOU CAN CHECK FOR DOOR FRAME THIS WAY
    -- BUT IT NEEDS A WAY TO GET THE OPPOSITE SQUARE TO THE PLAYER
    -- local prop = object:getSprite():getProperties()
    -- if prop:Is(IsoFlagType.DoorWallW) or prop:Is(IsoFlagType.DoorWallN) then
    --     print("door frame")

    --     return nil, true, nil, true, nil
    -- end

    return nil, nil, nil, nil,nil
end

-- Check if there is a window
CheckUpstairs.OnFillWorldObjectContextMenu = function(playerIndex, context, worldObjects, test)
    local player = getSpecificPlayer(playerIndex)

    -- objects can be in duplicate in the `worldObjects` for some reasons
    local objects = {}
    for i = 1,#worldObjects do
        objects[worldObjects[i]] = true
    end

    -- iterate through every objects
    local isWindow,isOpen,hasCurtainClosed,isDoor,isBarricaded,square,dist,option
    for object,_ in pairs(objects) do
        -- check if window and get other states of object
        isWindow,isOpen,hasCurtainClosed,isDoor,isBarricaded = CheckUpstairs.IsWindowOrDoor(object)

        -- object is window
        if isWindow then
            -- add new option to check behind window
            option = context:addOption(getText("ContextMenu_CheckThroughWindow"), objects, CheckUpstairs.CheckWindow, playerIndex, object)

            -- check distance from window or door
            square = object:getSquare()
            dist = IsoUtils.DistanceTo(
                square:getX(),square:getY(),square:getZ(),
                player:getX(),player:getY(),player:getZ()
            )

            -- window is too far to check through
            if dist > 1.5 then
                option.notAvailable = true
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip.description = getText("Tooltip_CantCheckThroughWindow_tooFar")
                option.toolTip = tooltip

            -- curtains are blocking vision
            elseif hasCurtainClosed then
                option.notAvailable = true
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip.description = getText("Tooltip_CantCheckThroughWindow_curtain")
                option.toolTip = tooltip

            -- window needs to be open to peek through
            elseif not isOpen then
                option.notAvailable = true
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip.description = getText("Tooltip_CantCheckThroughWindow_notOpen")
                option.toolTip = tooltip
            end

            -- window found, no point in checking other objects
            break

        -- object is door
        elseif isDoor then
            -- check distance from window or door
            square = object:getSquare()
            dist = IsoUtils.DistanceTo(
                square:getX(),square:getY(),square:getZ(),
                player:getX(),player:getY(),player:getZ()
            )

            -- add new option to check behind door or peek it if not open
            if not isOpen then
                option = context:addOption(getText("ContextMenu_PeekDoor"), objects, CheckUpstairs.PeekDoor, playerIndex, object)
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip.description = getText("Tooltip_PeekBehindDoor")
                option.toolTip = tooltip
            else
                option = context:addOption(getText("ContextMenu_CheckBehindDoor"), objects, CheckUpstairs.CheckDoor, playerIndex, object)
            end

            -- door is too far to check it
            if dist > 1.5 then
                option.notAvailable = true
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip.description = getText("Tooltip_CantCheckThroughDoor_tooFar")
                option.toolTip = tooltip

            -- barricaded means we can't peek it
            elseif isBarricaded then
                option.notAvailable = true
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip.description = getText("Tooltip_CantCheckThroughDoor_barricaded")
                option.toolTip = tooltip
            end

            -- door found, no point in checking other objects
            break
        end
    end
end

--#endregion



--#region Visual handling

-- Draws the nametag of the `zombie` based on the `ticks` value.
---@param zombie IsoZombie
---@param ticks int
CheckUpstairs.DrawNameTag = function(zombie,ticks)
    local zombieModData = zombie:getModData()

    -- get zombie nametag
    local nametag = zombieModData.CheckUpstairs_nametag

    -- skip if no nametag
    if not nametag then
        return
    end

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
    -- nametag:ReadString(UIFont.Small, CheckUpstairs.ZombieName, -1)

    -- apply visuals
    nametag:setDefaultColors(1,1,1,ticks/100)
    -- nametag:setOutlineColors(1,1,1,ticks/100)

    -- Draw nametag
    nametag:AddBatchedDraw(sx, sy, true)
end

-- Update visuals of zombies, their nametags
CheckUpstairs.HandleVisuals = function(zombie)
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

--#endregion