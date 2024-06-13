local util = require "library.util"
local animation = {}

local ANGLE_INDEX = 1

function animation.characterMove(move)
    World:playAnimation(function(tween)
        local mover = move:movingEntity()

        local offset = Soko:toPixelPosition(move:startPosition()) - Soko:toPixelPosition(move:targetPosition())
        mover.tweenableOffset:set(offset)
        tween:interpolate(mover.tweenableOffset:to(Soko:pixelPosition(0, 0)), 0.06, "linear")
    end, {})
end

function animation.bumpResource(mover, gridling, direction)
    if mover:templateName() ~= "player" then
        return
    end

    local player = mover

    local toolPosition = player.state["tool"].tweenablePosition
    local toolScale = player.state["tool"].tweenableScale
    local toolAngle = player.state["tool"].tweenableAngle
    local resourcePosition = gridling.state["animated_object"].tweenablePosition
    local resourceAngle = gridling.state["animated_object"].tweenableAngle
    local resourceScale = gridling.state["animated_object"].tweenableScale


    local tileSize = Soko:halfTileSize().x * 2
    local toolStartingScale = toolScale:get()
    local resourceStartPosition = resourcePosition:get()
    local toolStartPosition = toolPosition:get()
    local normalizedDirectionOffset = direction:toPixelPosition()
    local rightAngleFromDirection = direction:next():toPixelPosition()
    local resourceExtendedPosition = resourceStartPosition + normalizedDirectionOffset * tileSize / 4

    World:playAnimation(function(tween)
        tween:callback(function()
            player.state["is_animating"] = true
        end)

        tween:startMultiplex()
        local reelBackDuration = 0.1
        local swingDuration = 0.05

        tween:startSequence()
        local sign = util.math.sign(direction:toGridPosition().x)
        tween:interpolate(toolAngle:to(-sign * 0.5), reelBackDuration, "linear")
        tween:interpolate(toolAngle:to(sign * 0.5), swingDuration, "linear")
        tween:endSequence()

        tween:startSequence()
        tween:interpolate(toolPosition:to(toolStartPosition - normalizedDirectionOffset * tileSize / 2), reelBackDuration,
            "quadratic_fast_slow")
        tween:interpolate(toolPosition:to(resourceStartPosition), swingDuration, "quadratic_slow_fast")
        tween:endSequence()

        tween:startSequence()
        tween:interpolate(toolScale:to(toolStartingScale + 0.2), reelBackDuration, "quadratic_fast_slow")
        tween:interpolate(toolScale:to(toolStartingScale), swingDuration, "quadratic_slow_fast")
        tween:endSequence()

        tween:endMultiplex()

        tween:startMultiplex()
        local extendDuration = 0.05
        tween:interpolate(resourceScale:to(1.1), extendDuration, "linear")
        local angles = { 0.1, -0.1 }
        ANGLE_INDEX = (ANGLE_INDEX % #angles) + 1
        tween:interpolate(resourceAngle:to(angles[ANGLE_INDEX]), extendDuration, "linear")
        tween:interpolate(resourcePosition:to(resourceExtendedPosition), extendDuration, "linear")
        tween:endMultiplex()

        tween:callback(function()
            local events = require "library.events"
            events.onResourceHarvested("hand", gridling)
        end)

        tween:startMultiplex()
        local returnDuration = 0.15
        tween:interpolate(resourceScale:to(1), returnDuration, "linear")
        tween:interpolate(resourceAngle:to(0), returnDuration, "linear")
        tween:interpolate(resourcePosition:to(resourceStartPosition), returnDuration, "linear")

        tween:interpolate(toolPosition:to(toolStartPosition), returnDuration, "linear")
        tween:interpolate(toolAngle:to(0), returnDuration, "linear")
        tween:endMultiplex()

        tween:callback(function()
            player.state["is_animating"] = false
        end)
    end, {})
end

return animation
