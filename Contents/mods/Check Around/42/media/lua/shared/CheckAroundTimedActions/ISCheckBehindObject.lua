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
local RayBeam2D = require "DoggyObjects/RayBeam2D"
local CheckAround = require "CheckAround_module"
local VisualMarkers = require "DoggyDebugTools/VisualMarkers"
local GENERAL_RANDOM = newrandom()

ISCheckBehindObject = ISBaseTimedAction:derive("ISCheckBehindObject")

function ISCheckBehindObject:isValid()
	return true
end

function ISCheckBehindObject:waitToStart()
	self.character:faceThisObject(self.object)
	return self.character:shouldBeTurning()
end

function ISCheckBehindObject:update()
    -- instance info
    local delta = self.action:getJobDelta()
    delta = delta * 100
    delta = delta - delta % 1
    delta = delta / 100
    if delta == self.previousDelta then return end

    -- update beam direction
    local beamVector = self.beamVector
    beamVector:setDirection(self.a*delta + self.b)
    local beamObject = self.beamObject
    beamObject:setBeam(beamVector)

    local squares  = beamObject:castRay()

    for square, _ in pairs(squares) do repeat
        local movingObjects = square:getMovingObjects()
        for i=0, movingObjects:size()-1 do
            local zombie = movingObjects:get(i)
            if instanceof(zombie, "IsoZombie") then
                self.zombies[zombie] = true
                if self.showNametags then
                    CheckAround.ShowNametag(zombie)
                end
            end
        end
    until true end
end

function ISCheckBehindObject:setVoicelines()
    local object = self.object
    if instanceof(object, "IsoDoor") or instanceof(object, "IsoThumpable") and object:isDoor() then
        if not object:IsOpen() then
            self:rollCreek()
        end
        self.voiceLine_noZombies = CheckAround.Voicelines_BehindDoorNoZombies
        self.voiceLine_zombies = CheckAround.Voicelines_zombiesBehindDoor
    elseif instanceof(object, "IsoWindow") or instanceof(object, "IsoThumpable") and object:isWindow() then
        self.voiceLine_noZombies = CheckAround.Voicelines_BehindWindowsNoZombies
        self.voiceLine_zombies = CheckAround.Voicelines_zombiesBehindWindow
    end
end

function ISCheckBehindObject:setStartingBeam()
    local object = self.object
    local fovAngle = self.fovAngle
    local beta = math.pi/2 - fovAngle / 2 -- offset to main axis

    local initialAngle = 0
    if not object:getNorth() then
        self.rotateDirection = -self.rotateDirection
        initialAngle = math.pi/2
    end

    -- setup initial beam
    local beamVector = Vector2.new()
    beamVector:setLengthAndDirection(initialAngle + beta * self.rotateDirection, 20)
    self.beamVector = beamVector

    -- coefficients for the beam rotation (dir = rot * delta + offset)
    self.a = fovAngle * self.rotateDirection -- total rotation to achieve
    self.b = beamVector:getDirection() -- initial offset
end

function ISCheckBehindObject:setSquares()
    local character = self.character
    local object = self.object

    -- retrieve various squares of the object
    local square = object:getSquare()
    local square_opposite = object:getOppositeSquare()
    local square_door = square

    local square_character = character:getSquare()
    if square_character ~= square then
        square_door = square_opposite
        square_opposite = square

        self.rotateDirection = -self.rotateDirection -- inverse rotation
    end

    self.square_opposite = square_opposite
    self.square_door = square_door
end

function ISCheckBehindObject:start()
	self:setActionAnim("Welding")
    self:setOverrideHandModelsString(nil,nil)

    -- retrieve voicelines
    self:setVoicelines()

    -- inverse squares to find out which one is truly behind the object relative to the character
    self:setSquares()

    -- get start beam and rotation direction
    self:setStartingBeam()

    -- center point of beam rotation
    local playerVector = self.character:getForwardDirection()
    local square_opposite = self.square_opposite
    local pointOfCheck = {
        x = square_opposite:getX() + 0.5 - playerVector:getX() * 0.4,
        y = square_opposite:getY() + 0.5 - playerVector:getY() * 0.4,
        z = square_opposite:getZ(),
    }

    self.beamObject = RayBeam2D:new(pointOfCheck, self.beamVector, self.ignoredObjects)
end

function ISCheckBehindObject:rollCreek()
    local object = self.object
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

    -- get default value for success chance which is normalized object health
    local doorHealth = object:getHealth()/object:getMaxHealth() * 100

    -- calculate success chance
    local successChance = doorHealth + Lightfoot + Nimble + Sneak + Graceful + Inconspicuous + Crouching - Conspicuous - Clumsy - panic - stress - pain

    -- if not success, play a sound
    local success = successChance >= GENERAL_RANDOM:random(0,100)
    if not success then
        local square = object:getSquare()
        getWorld():getFreeEmitter():playSoundImpl("DoorCreek",square)
        local radius = SandboxVars.CheckAround.Radius + 1
        addSound(nil, square:getX(), square:getY(), square:getZ(), radius, radius)
        -- self:stop()
    end
end

function ISCheckBehindObject:stop()
	ISBaseTimedAction.stop(self);
end

function ISCheckBehindObject:perform()
    -- count zombies
    local zombieCount = 0
    for _, _ in pairs(self.zombies) do
        zombieCount = zombieCount + 1
    end

    -- retrieve zombies in radius
    CheckAround.ApplyVoiceline(self.character,zombieCount,self.voiceLine_noZombies,self.voiceLine_zombies)

    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISCheckBehindObject:new(character, object, _fovAngle)
    -- VisualMarkers.ResetMarkers()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = 200

	-- custom fields
    o.object = object
    o.zombies = {}
    local _fovAngle = _fovAngle or 180
    o.fovAngle = math.rad(_fovAngle)

    o.previousDelta = -1
    o.rotateDirection = -1
    o.checkedSquares = {}
    o.showNametags = SandboxVars.CheckAround.ShowZombieNametag
    o.ignoredObjects = {
        [object] = true,
    }

	return o
end

return ISCheckBehindObject