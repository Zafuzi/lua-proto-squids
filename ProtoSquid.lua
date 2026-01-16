--- ProtoSquid is a prototype event driven entity system that is meant to be portable to any engine.
--- This file should be
--- - Engine agnostic
--- - Compatible with as many older / custom versions of lua as possble
--- - Limited in scope and efficient in it's implementation
--- - If you add anything to this...
--- - - Test: Make sure your feature works
--- - - Improve: Is this as efficient as it could be?
--- - - Validate: Does this belong here? If not, make it a plugin
--- - - Contemplate: Will this slow down the engine?
--- - - Show: Write an example of how to use your new feature
--- For example, there isn't a loop system here because your engine probably already has a preffered way of doing that,
--- same for tracking keydowns, mouse movement, etc...
--- All this is really meant for is efficiently maintaing a basic ECS
---
--- TODO:
--- - [ ] Add a way to de-register an event
--- - [ ] Add a way to unsubscribe a squid from an event

--- @alias vec2 {x: 0, y: 0}

--- @class Listener
--- @field name string
--- @field notify function

--- @class Event
--- @field name string
--- @field trigger function
--- @field subscribers Listener[]

--- @class ProtoSquid
--- @field events Event[]
--- @field squids Squid[]
local ProtoSquid = {
    events = {},
    squids = {},
}

--- @class Squid
--- @field name string
--- @field alive boolean
--- @field debug boolean
--- @field position vec2
--- @field rotation number
--- @field scale vec2
--- @field opacity number
--- @field subscribe fun(eventName: string, onTrigger?: function)


--- creates a proto squid
---@param name string
---@return Squid
ProtoSquid.create = function(name)
    if not name then
        error("Must provide a name")
    end

    local squid = {
        name = name,
        alive = false,
        debug = false,
        position = { x = 0, y = 0 },
        rotation = 0,
        scale = { x = 0, y = 0 },
        opacity = 0,
    }

    --- Subscribes this squid to the firing of an event
    ---@param eventName string
    ---@param onTrigger? function
    squid.subscribe = function(eventName, onTrigger)
        if not eventName or not ProtoSquid.events[eventName] then
            error("Event " .. eventName .. " does not exist")
        end

        local event = ProtoSquid.events[eventName]

        event.subscribers[squid.name] = {
            name = name,
            notify = function()
                if squid.alive then
                    if type(onTrigger) == "function" then
                        onTrigger(squid)
                    else
                        if squid.debug then
                            print(eventName .. ' ' .. squid.name)
                        end
                    end
                end
            end
        }
    end

    ProtoSquid.squids[name] = squid
    return squid
end

--- Registers an event
---@param name string
ProtoSquid.register = function(name)
    if not name then
        error("Must provide a name")
    end

    if ProtoSquid.events[name] then
        print("WARN - Overwrite " .. name)
    end

    ProtoSquid.events[name] = {
        name = name,
        trigger = function(self)
            for index, subscriber in pairs(self.subscribers) do
                subscriber:notify(index)
            end
        end,
        subscribers = {}
    }
end

--- Triggers all the subscribers to an event
--- @param eventName string
ProtoSquid.trigger = function(eventName)
    if not eventName or not ProtoSquid.events[eventName] then
        error("Event " .. eventName .. " does not exist")
    end

    ProtoSquid.events[eventName]:trigger()
end

return ProtoSquid
