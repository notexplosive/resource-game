local events    = require "library.events"
local query     = require "library.query"
local animation = require "library.animation"
local main      = {}

function main.onStart()
    local spawnPosition = World.state["spawn_position"]
    World:spawnEntity(spawnPosition, "player", Soko.Direction.Down)

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

        if gridling.state["resource"] then
            animation.bumpResource(gridling, move.direction)
        end
    end)

    if move.wasAllowed() then
        events.onMoveSuccess(move)
    end
end

function main.onEntityDestroyed(entity)

end

function main.onUpdate(dt)

end

return main
