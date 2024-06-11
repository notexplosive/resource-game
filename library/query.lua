local map = require "library.map"
local query = {}

function query.roomEntities()
    return map.currentRoom():allEntities()
end

function query.entitiesWithTemplate(templateName, func)
    for i, entity in ipairs(query.roomEntities()) do
        if entity.templateName() == templateName then
            func(entity)
        end
    end
end

function query.entitiesWithStateKey(key, func)
    for i, entity in ipairs(query.roomEntities()) do
        if entity.state[key] then
            func(entity)
        end
    end
end

function query.entitiesWithState(key, value, func)
    for i, entity in ipairs(query.roomEntities()) do
        if entity.state[key] == value then
            func(entity)
        end
    end
end

function query.gridlingsAt(position, func)
    for i, gridling in ipairs(World.gridlingsAt(position)) do
        func(gridling)
    end
end

return query
