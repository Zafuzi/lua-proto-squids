--- This file is mainly just to demonstrate the basics of using the engine.
--- Special note: require may not work in all cases, defer to your systems way of including lua scripts
--- You can always just make ProtoSquid global and skip the require, or use doFile if you hate being happy
local ProtoSquid = require("ProtoSquid")

--- the order of these registers don't matter, they just have to exist before you can subscribe
ProtoSquid.register("start")
ProtoSquid.register("draw")
ProtoSquid.register("update")
ProtoSquid.register("specialEvent")

for i = 1, 3 do
    local s = ProtoSquid.create("squid_" .. i)
    s.alive = true
    s.debug = true
    s.subscribe("start")
    s.subscribe("draw")
    s.subscribe("update")
end

local specialSquid = ProtoSquid.create("specialSquid")
specialSquid.alive = true
specialSquid.debug = true
specialSquid.subscribe("specialEvent", function()
    print("This is the callback just for this event on this squid!")
end)

--- The order of the triggers DOES matter, they will fire sequentially
ProtoSquid.trigger("start")
ProtoSquid.trigger("specialEvent")
ProtoSquid.trigger("draw")
ProtoSquid.trigger("update")

specialSquid.subscribe("specialEvent", function()
    print("You can even overwrite it!")
end)

ProtoSquid.trigger("specialEvent")
