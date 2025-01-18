local Class = {}

function Class:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Class:extend(object)
    local o = object or {}
    setmetatable(o, self)
    o.__index = o
    o.super = self
    return o
end

return Class 