local Camera = {
    x = 0,
    y = 0,
    scale = 1,
    rotation = 0,
    target = nil,
    smoothSpeed = 5,
    bounds = {
        minX = -1000,
        maxX = 1000,
        minY = -1000,
        maxY = 1000
    }
}

function Camera:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    -- Initialize at wielder position
    if Game and Game.wielder then
        o.x = Game.wielder.x
        o.y = Game.wielder.y
    end
    
    return o
end

function Camera:update(dt)
    -- Determine target
    if Game.boomerang.state == "flying" or Game.boomerang.state == "returning" then
        -- Follow boomerang when in flight
        self.target = Game.boomerang
    else
        -- Follow wielder otherwise
        self.target = Game.wielder
    end
    
    if self.target then
        -- Calculate target position (center of screen)
        local targetX = self.target.x - love.graphics.getWidth()/2
        local targetY = self.target.y - love.graphics.getHeight()/2
        
        -- Smooth camera movement
        self.x = self.x + (targetX - self.x) * self.smoothSpeed * dt
        self.y = self.y + (targetY - self.y) * self.smoothSpeed * dt
        
        -- Keep camera within bounds
        self.x = math.max(self.bounds.minX, math.min(self.bounds.maxX, self.x))
        self.y = math.max(self.bounds.minY, math.min(self.bounds.maxY, self.y))
    end
end

function Camera:attach()
    love.graphics.push()
    love.graphics.translate(-self.x, -self.y)
end

function Camera:detach()
    love.graphics.pop()
end

function Camera:mousePosition()
    return love.mouse.getX() + self.x,
           love.mouse.getY() + self.y
end

function Camera:setBounds(minX, maxX, minY, maxY)
    self.bounds.minX = minX
    self.bounds.maxX = maxX
    self.bounds.minY = minY
    self.bounds.maxY = maxY
end

return Camera 