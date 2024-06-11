local animation = {}

function animation.characterMove(move)
    World:playAnimation(function(tween)
        local mover = move:movingEntity()

        local offset = Soko:toPixelPosition(move:startPosition()) - Soko:toPixelPosition(move:targetPosition())
        mover.tweenableOffset:set(offset)
        tween:interpolate(mover.tweenableOffset:to(Soko:pixelPosition(0, 0)), 0.06, "linear")
    end, {})
end

function animation.bumpResource(gridling, direction)
    local startPosition = gridling.state["animated_object"].tweenablePosition:get()
    local extendedPosition = startPosition + direction:toPixelPosition() * Soko:halfTileSize().x

    World:playAnimation(function(tween)
        local position = gridling.state["animated_object"].tweenablePosition
        tween:interpolate(position:to(extendedPosition), 0.15, "linear")
        tween:interpolate(position:to(startPosition), 0.15, "linear")
    end, {})
end

return animation
