local events    = require "library.events"
local query     = require "library.query"
local animation = require "library.animation"
local util      = require "library.util"
local main      = {}

function main.onStart()
    local spawnPosition = World.state["spawn_position"]
    local player = World:spawnEntity(spawnPosition, "player", Soko.Direction.Down)
    local tool = World:spawnObject(spawnPosition)
    tool.state["layer"] = 3
    tool.state["renderer"] = "SolidColor"
    tool.state["color"] = "ff0000"
    tool.tweenableScale:set(0.5)
    player.state["tool"] = tool
    local map = require "library.map"
    map.enterRoomAt(spawnPosition)
end

function main.onInput(input)
    if input.direction ~= Soko.Direction.None then
        events.onDirectionalInput(input.direction)
    end
end

function main.onMove(move)
    query.gridlingsAt(move:targetPosition(), function(gridling)
        if gridling:checkTrait("BlocksMovement", "Block") then
            move:stop()
        end

        if gridling.state["resource"] and move:movingEntity():templateName() == "player" then
            animation.bumpResource(move:movingEntity(), gridling, move.direction)
        end
    end)

    if move.wasAllowed() then
        events.onMoveSuccess(move)
    end
end

function main.onEntityDestroyed(entity)

end

function main.onUpdate(dt)
    query.entitiesWithTemplate("player", function(player)
        if not player.state["is_animating"] then
            player.state["tool"].tweenablePosition:set(util.soko.getWorldPositionOfEntity(player))
        end
    end)
end

return main
