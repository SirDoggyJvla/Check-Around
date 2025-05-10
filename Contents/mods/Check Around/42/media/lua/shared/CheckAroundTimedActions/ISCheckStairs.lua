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

ISCheckStairs = ISBaseTimedAction:derive("ISCheckStairs")


function ISCheckStairs:isValid()
	return true
end

function ISCheckStairs:waitToStart()
	self.character:faceThisObject(self.object)
	return self.character:shouldBeTurning()
end

function ISCheckStairs:update()
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

    -- cast ray
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

function ISCheckStairs:setVoicelines()
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

function ISCheckStairs:setStartingBeam()
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

function ISCheckStairs:setSquares()
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

function ISCheckStairs:start()

end

function ISCheckStairs:stop()
	ISBaseTimedAction.stop(self);
end

function ISCheckStairs:perform()
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

function ISCheckStairs:new(character, object, _fovAngle)
    VisualMarkers.ResetMarkers()
    VisualMarkers.ResetHighlightSquares()
    VisualMarkers.ResetLines()
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

return ISCheckStairs