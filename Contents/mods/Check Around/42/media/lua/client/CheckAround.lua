--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

This file handles the mod CheckAround and adds the custom keybinds.

]]--
--[[ ================================================ ]]--

-- requirements
local CheckAround = require "CheckAround_module"
require "CheckAround_patches"
local CheckAround_Options = require "CheckAround_ModOptions"
-- local ISCheckBehindObject = require "CheckAroundTimedActions/ISCheckBehindObject"
local FindersTools = require "DoggyTools/FindersTools"

CheckAround.UpdateZombieName = function()
    CheckAround.ZombieName = SandboxVars.CheckAround.loreNameSingular ~= "" and SandboxVars.CheckAround.loreNameSingular or CheckAround.defaultZombieName
    CheckAround.ZombiesName = SandboxVars.CheckAround.loreNamePlurial ~= "" and SandboxVars.CheckAround.loreNamePlurial or CheckAround.defaultZombiesName
end

CheckAround.KeyPress = function(keynum)
    if keynum == CheckAround_Options.CheckUpstairs:getValue() then
        CheckAround.checkForZombies()
    end
end

-- Apply the voiceline based on the amount of `zombies` and the given voicelines.
---@param player IsoPlayer
---@param zombiesAmount integer
---@param voicelines_noZombies table
---@param voicelines_zombies table
CheckAround.ApplyVoiceline = function(player,zombiesAmount,voicelines_noZombies,voicelines_zombies)
    if zombiesAmount > 0 then
        local voiceLine = voicelines_zombies[ZombRand(1,#voicelines_zombies+1)]
        if zombiesAmount == 1 then
            player:Say(string.format(voiceLine,zombiesAmount,CheckAround.ZombieName))
        else
            player:Say(string.format(voiceLine,zombiesAmount,CheckAround.ZombiesName))
        end
    else
        local voiceLine = voicelines_noZombies[ZombRand(1,#voicelines_noZombies+1)]
        player:Say(string.format(voiceLine,CheckAround.ZombieName))
    end
end

CheckAround.ShowZombiesNametags = function(zombies)
    if SandboxVars.CheckAround.ShowZombieNametag then
        for i = 1,#zombies do
            CheckAround.ShowNametag(zombies[i])
        end
    end
end



--#region Check for zombies stairs

-- Retrieves coordinates of the square at the top of the stairs, if the player is positioned on the stairs
-- or at the square at the bottom.
---@param player IsoPlayer
---@return table|nil
CheckAround.getStairTopCoordinates = function(player)
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
            top_square_x = x
            top_square_y = - 4 + y + 3*(z - math.floor(z))
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
CheckAround.getStairBottomCoordinates = function(player)
    -- player coordinates
    local x = player:getX()
    local y = player:getY()
    local z = player:getZ()

    -- prepare variables
    local top_square_x
    local top_square_y
    local top_square_z

    -- floor below height
    local z_below = z-1

    -- skip if on stairs
    if z_below%1 ~= 0 then return nil end

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

CheckAround.checkForZombies_upstairs = function(player)
    -- retrieve top coordinates of the stair
    local topCoordinates = CheckAround.getStairTopCoordinates(player)
    if topCoordinates then
        local zombies = FindersTools.getZombiesInRadius(player,topCoordinates,SandboxVars.CheckAround.Radius)
        CheckAround.ApplyVoiceline(player,#zombies,CheckAround.Voicelines_CheckAroundNoZombies,CheckAround.Voicelines_zombieUpstairs)
        CheckAround.ShowZombiesNametags(zombies)
    end
end

CheckAround.checkForZombies_downstairs = function(player)
    -- retrieve top coordinates of the stair
    local bottomCoordinates = CheckAround.getStairBottomCoordinates(player)
    if bottomCoordinates then
        local zombies = FindersTools.getZombiesInRadius(player,bottomCoordinates,SandboxVars.CheckAround.Radius)
        CheckAround.ApplyVoiceline(player,#zombies,CheckAround.Voicelines_CheckDownstairsNoZombies,CheckAround.Voicelines_zombieDownstairs)
        CheckAround.ShowZombiesNametags(zombies)
    end
end

-- Checks if zombies are upstairs and show then or make the character say a line, if in a staircase.
CheckAround.checkForZombies = function(player)
    player = player or getPlayer()

    CheckAround.checkForZombies_upstairs(player)
    CheckAround.checkForZombies_downstairs(player)
end

--#endregion



--#region Check for zombies window and doors


---Look through window or door for zombies
---@param player IsoPlayer
---@param object IsoThumpable|IsoWindow|IsoDoor
CheckAround.CheckWindowOrDoor = function(player, object)
    local square = object:getSquare()

    if not player:isBlockMovement() and luautils.walkAdjWindowOrDoor(player, square, object) then
        ISTimedActionQueue.add(ISCheckBehindObject:new(player, object))
    end
end

-- Checks for zombies behind the window.
---@param player IsoPlayer
---@param door IsoThumpable|IsoDoor
CheckAround.CheckDoor = function(player, door)
    local square = door:getSquare()

    if not player:isBlockMovement() and luautils.walkAdjWindowOrDoor(player, square, door) then
        ISTimedActionQueue.add(ISCheckBehindObject:new(player, door))
    end
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
CheckAround.GetIsoThumpableInformations = function(object)
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
                return CheckAround.GetIsoWindowInformations(getObject)
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
                return CheckAround.GetIsoDoorInformations(getObject)
            elseif instanceof(getObject,"IsoThumpable") and getObject:getNorth() == object:getNorth() then
                if getObject:isDoor() then
                    return CheckAround.GetIsoDoorInformations(getObject)
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
CheckAround.GetIsoDoorInformations = function(object)
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
CheckAround.GetIsoWindowInformations = function(object)
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
CheckAround.IsWindowOrDoor = function(object)
    if instanceof(object,"IsoWindow") then
        return CheckAround.GetIsoWindowInformations(object)
    elseif instanceof(object,"IsoDoor") then
        return CheckAround.GetIsoDoorInformations(object)
    elseif instanceof(object,"IsoThumpable") then
        return CheckAround.GetIsoThumpableInformations(object)
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
CheckAround.OnFillWorldObjectContextMenu = function(playerIndex, context, worldObjects, test)
    local player = getSpecificPlayer(playerIndex)

    -- objects can be in duplicate in the `worldObjects` for some reasons
    local objects = {}
    for i = 1,#worldObjects do
        objects[worldObjects[i]] = true
    end

    -- iterate through every objects
    for object,_ in pairs(objects) do
        -- check if window and get other states of object
        local isWindow,isOpen,hasCurtainClosed,isDoor,isBarricaded = CheckAround.IsWindowOrDoor(object)

        -- object is window
        if isWindow then
            -- add new option to check behind window
            local option = context:addOption(getText("ContextMenu_CheckThroughWindow"), player, CheckAround.CheckWindowOrDoor, object)
            option.iconTexture = Texture.trygetTexture("CheckAround_contextMenu")

            -- curtains are blocking vision
            if hasCurtainClosed then
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
            -- add new option to check behind door or peek it if not open
            local option = context:addOption(getText("ContextMenu_CheckBehindDoor"), player, CheckAround.CheckWindowOrDoor, object)
            option.iconTexture = Texture.trygetTexture("CheckAround_contextMenu")

            -- verify open
            if not isOpen then
                option.name = getText("ContextMenu_PeekDoor")
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip.description = getText("Tooltip_PeekBehindDoor")
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
---@param ticks integer
CheckAround.DrawNameTag = function(zombie,ticks)
    local zombieModData = zombie:getModData()

    -- get zombie nametag
    local nametag = zombieModData.CheckAround_nametag

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
    -- nametag:ReadString(UIFont.Small, CheckAround.ZombieName, -1)

    -- apply visuals
    nametag:setDefaultColors(1,1,1,ticks/100)
    -- nametag:setOutlineColors(1,1,1,ticks/100)

    -- Draw nametag
    nametag:AddBatchedDraw(sx, sy, true)
end

CheckAround.ShowNametag = function(zombie)
    local zombieModData = zombie:getModData()

    zombieModData.CheckAround_ticks = 200
    zombieModData.CheckAround_nametag = TextDrawObject.new()
    zombieModData.CheckAround_nametag:ReadString(UIFont.Small, CheckAround.ZombieName, -1)
end

-- Update visuals of zombies, their nametags
CheckAround.HandleVisuals = function(ticks)
    local zombieList = getCell():getZombieList()

    for i = 0, zombieList:size() - 1 do repeat
        local zombie = zombieList:get(i)
        local zombieModData = zombie:getModData()

        -- skip if shouldn't show nametag
        local ticks = zombieModData.CheckAround_ticks
        if not ticks then break end

        -- draw nametag
        CheckAround.DrawNameTag(zombie,ticks)

        -- reduce tick value or stop showing nametag
        if zombieModData.CheckAround_ticks > 0 then
            zombieModData.CheckAround_ticks = ticks - 1
        else
            zombieModData.CheckAround_ticks = nil
            zombieModData.CheckAround_nametag = nil
        end
    until true end

    SquareNametags = SquareNametags or {}
    for square, nametag in pairs(SquareNametags) do
        local sx = IsoUtils.XToScreen(square:getX()+0.5, square:getY()+0.5, square:getZ(), 0)
        local sy = IsoUtils.YToScreen(square:getX()+0.5, square:getY()+0.5, square:getZ(), 0)

        sx = sx - IsoCamera.getOffX()-- - square:getOffsetX()
        sy = sy - IsoCamera.getOffY()-- - square:getOffsetY()

        local zoom = getCore():getZoom(0)
        sx = sx / zoom
        sy = sy / zoom
        sy = sy - nametag:getHeight()

        nametag:setDefaultColors(1,1,1,1)
        nametag:AddBatchedDraw(sx, sy, true)
    end

    UniqueMarker = UniqueMarker or {}
    for _,marker in pairs(UniqueMarker) do
        local sx = IsoUtils.XToScreen(marker.x, marker.y, marker.z, 0)
        local sy = IsoUtils.YToScreen(marker.x, marker.y, marker.z, 0)

        sx = sx - IsoCamera.getOffX()-- - square:getOffsetX()
        sy = sy - IsoCamera.getOffY()-- - square:getOffsetY()

        sy = sy - marker.y_offset

        local zoom = getCore():getZoom(0)
        sx = sx / zoom
        sy = sy / zoom
        sy = sy - marker.nametag:getHeight()

        marker.nametag:setDefaultColors(marker.r,marker.g,marker.b,marker.a)
        marker.nametag:AddBatchedDraw(sx, sy, true)
    end

    -- local vector1 = Vector2.new(getPlayer():getX(), getPlayer():getY())
	-- local vector2 = Vector2.new(getPlayer():getX()+3, getPlayer():getY()+3)
	-- getPlayer():drawLine(vector1, vector2, 1, 0, 0,1)
end

CheckAround.OnRenderTick = function()
    local player = getPlayer()
    if not player then return end

    DrawingLines = DrawingLines or {}
    for _,line in pairs(DrawingLines) do
        player:drawDirectionLine(line.vector, line.length,line.r,line.g,line.b)
    end


end

--#endregion