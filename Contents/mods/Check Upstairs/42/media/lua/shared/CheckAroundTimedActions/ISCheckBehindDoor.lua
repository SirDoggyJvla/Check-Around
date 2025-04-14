--[[ ================================================ ]]--
--[[  /~~\'      |~~\                  ~~|~    |      ]]--
--[[  '--.||/~\  |   |/~\/~~|/~~|\  /    | \  /|/~~|  ]]--
--[[  \__/||     |__/ \_/\__|\__| \/   \_|  \/ |\__|  ]]--
--[[                     \__|\__|_/                   ]]--
--[[ ================================================ ]]--
--[[

Custom TimedAction to check behind doors.

]]--
--[[ ================================================ ]]--

-- requirements
require "TimedActions/ISBaseTimedAction"
local FindersTools = require "DoggyTools/FindersTools"
local CheckAround = require "CheckAround_module"
local GENERAL_RANDOM = newrandom()

ISCheckBehindDoor = ISBaseTimedAction:derive("ISCheckBehindDoor")

function ISCheckBehindDoor:isValid()
	return true
end

function ISCheckBehindDoor:waitToStart()
	self.character:faceThisObject(self.door)
	return self.character:shouldBeTurning()
end

function ISCheckBehindDoor:update()
    -- instance info
    local delta = self.action:getJobDelta()
    delta = delta * 100
    delta = delta - delta % 1
    delta = delta / 100
    if delta == self.previousDelta then return end

    local freshVector = Vector2.new(self.startBeam)
    freshVector:rotate(delta * self.rotateDirection)

    local squares = FindersTools.CastVisionRay(self.pointOfCheck, freshVector, 10, self.ignoredObjects)
    for square, wall in pairs(squares) do repeat
        -- if self.checkedSquares[square] then break end

        local movingObjects = square:getMovingObjects()
        for i=0, movingObjects:size()-1 do
            local zombie = movingObjects:get(i)
            if instanceof(zombie, "IsoZombie") then
                if self.showNametags then
                    CheckAround.ShowNametag(zombie)
                end
            end
        end


        if not wall then
            CheckAround.AddHighlightSquare(square, {r=1,g=0,b=0,a=0.5},0)
        else
            self.checkedSquares[square] = true
            CheckAround.AddHighlightSquare(square, {r=1,g=1,b=0,a=1}, 30)

            -- local nametag = TextDrawObject.new()
            -- nametag:ReadString(UIFont.Small, tostring(square), -1)

            -- SquareNametags[square] = nametag
        end
    until true end
end
-- print(getPlayer():getX(), getPlayer():getY())

AddHighlightSquare = CheckAround.AddHighlightSquare

function ISCheckBehindDoor:start()
	self:setActionAnim("Craft")

    -- instance info
    local character = self.character
    local door = self.door

    if instanceof(door, "IsoDoor") then
        self:rollCreek()
    end

    -- get start beam and rotation direction
    local door_north = door:getNorth()
    if door_north then
        self.startBeam = Vector2.new(1,0)
        self.rotateDirection = -math.pi
    else
        self.startBeam = Vector2.new(0,1)
        self.rotateDirection = math.pi
    end

    -- retrieve various squares of the door
    local square = door:getSquare()
    local square_opposite = door:getOppositeSquare()
    local square_door = square

    -- inverse squares to find out which one is truly behind the door relative to the character
    local square_character = character:getSquare()
    if square_character ~= square then
        square_door = square_opposite
        square_opposite = square

        self.rotateDirection = -self.rotateDirection
    end

    self.square_opposite = square_opposite
    self.square_door = square_door

    -- center point of beam rotation
    local playerVector = character:getForwardDirection()
    self.pointOfCheck = {
        x = square_opposite:getX() + 0.5 - playerVector:getX() * 0.4,
        y = square_opposite:getY() + 0.5 - playerVector:getY() * 0.4,
        z = square_opposite:getZ(),
    }

    SquareNametags = {}
    CheckAround.highlightsSquares = {}
    UniqueMarker = {}
    DrawingLines = {}
    CheckAround.AddHighlightSquare(square_door, {r=0,g=1,b=0,a=0.5}, 100)
    CheckAround.AddHighlightSquare(square_opposite, {r=0,g=0,b=1,a=0.5}, 100)
end

function ISCheckBehindDoor:rollCreek()
    local door = self.door
    local character = self.character

    -- get character stats
    local Lightfoot = character:getPerkLevel(Perks.Lightfoot) -- max 10
    local Nimble = character:getPerkLevel(Perks.Nimble) -- max 10
    local Sneak = character:getPerkLevel(Perks.Sneak) -- max 10
    local Graceful = character:HasTrait("Graceful") and 10 or 0
    local Inconspicuous = character:HasTrait("Inconspicuous") and 10 or 0
    local Conspicuous = character:HasTrait("Conspicuous") and 10 or 0
    local Clumsy = character:HasTrait("Clumsy") and 10 or 0
    local Crouching = character:isSneaking() and 20 or 0

    -- get character moodles
    local stats = character:getStats()
    local panic = stats:getPanic()/2
    local stress = stats:getStress()*100/2
    local pain = stats:getPain()/2

    -- get default value for success chance which is normalized door health
    local doorHealth = door:getHealth()/door:getMaxHealth() * 100

    -- calculate success chance
    local successChance = doorHealth + Lightfoot + Nimble + Sneak + Graceful + Inconspicuous + Crouching - Conspicuous - Clumsy - panic - stress - pain

    -- if not success, play a sound
    local success = successChance >= GENERAL_RANDOM:random(0,100)
    if not success then
        local square = door:getSquare()
        getWorld():getFreeEmitter():playSoundImpl("DoorCreek",square)
        local radius = SandboxVars.CheckAround.Radius + 1
        addSound(nil, square:getX(), square:getY(), square:getZ(), radius, radius)
        -- self:stop()
    end
end

function ISCheckBehindDoor:stop()
	ISBaseTimedAction.stop(self);
end

function ISCheckBehindDoor:perform()
    local square_door = self.square_door
    local character = self.character

    -- retrieve zombies in radius


    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISCheckBehindDoor:new(character, door)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.stopOnWalk = false
	o.stopOnRun = true
	o.maxTime = 200

	-- custom fields
    o.door = door

    o.previousDelta = -1
    o.checkedSquares = {}
    o.showNametags = SandboxVars.CheckAround.ShowZombieNametag
    o.ignoredObjects = {
        [door] = true,
    }

	return o
end

return ISCheckBehindDoor