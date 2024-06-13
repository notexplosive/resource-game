local gameplay = {}

function gameplay.spawnResource(resourceName, gridPosition)
    local entity = World:spawnEntity(Soko.gridPosition(0, 0), resourceName)

    local resource = World:spawnObject(gridPosition)
    resource.state:addOtherState(entity.state)
    resource.state["layer"] = 4
    resource.state["scale"] = 0.5
    entity:destroy()

    return resource
end

return gameplay
