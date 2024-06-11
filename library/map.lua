local map = {}

local isFirstEntry = true
local storedGridPosition = Soko:gridPosition(0, 0)

function map.currentRoom()
    return World:roomAt(storedGridPosition)
end

function map.enterRoomAt(gridPosition)
    local oldRoom = map.currentRoom()
    local newRoom = World:roomAt(gridPosition)

    local events = require "library.events"

    if isFirstEntry then
        storedGridPosition = gridPosition
        events.onEnterRoom(newRoom, true)
    elseif oldRoom ~= newRoom then
        events.onExitRoom(oldRoom)
        storedGridPosition = gridPosition
        events.onEnterRoom(newRoom)
    end

    isFirstEntry = false
end

return map
