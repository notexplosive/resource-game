local util = {
    soko = {},
    math = {}
}

function util.soko.getWorldPositionOfEntity(entity)
    return Soko:toPixelPosition(entity.gridPosition) + entity.tweenableOffset:get()
end

function util.math.sign(x)
    if x > 0 then
        return 1
    end

    return -1
end

return util
