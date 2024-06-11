local query     = require "library.query"
local map       = require "library.map"
local animation = require "library.animation"
local events    = {}

function events.onMoveSuccess(move)
    if move:movingEntity():templateName() == "player" then
        animation.characterMove(move)
        map.enterRoomAt(move:targetPosition())
    end
end

function events.onDirectionalInput(direction)
    query.entitiesWithTemplate("player", function(entity)
        local move = entity:makeDirectionalMove(direction)
        move:execute()
    end)
end

function events.onExitRoom(room)
    query.entitiesWithStateKey("resource", function(entity)
        entity:setVisible(true)
        if entity.state["animated_object"] then
            entity.state["animated_object"]:destroy()
        end
    end)
end

function events.onEnterRoom(room, firstEntry)
    query.entitiesWithStateKey("resource", function(entity)
        entity:setVisible(false)
        local object = World:spawnObject(entity.gridPosition)
        object.state:addOtherState(entity.state)
        entity.state["animated_object"] = object
    end)

    if firstEntry then
        World.camera:tweenableViewBounds():set(room:viewBounds())
    else
        World:playAsyncAnimation(function(tween)
            tween:interpolate(World.camera:tweenableViewBounds():to(room:viewBounds()), 0.25, "cubic_fast_slow")
        end, {})
    end
end

return events
