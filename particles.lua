local Particles = {
    systems = {},
    textures = {}
}

function Particles:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    
    -- Create particle textures
    self:createTextures()
    
    return o
end

function Particles:createTextures()
    -- Create panic particle texture
    local panicCanvas = love.graphics.newCanvas(4, 4)
    love.graphics.setCanvas(panicCanvas)
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 2, 2, 2)
    love.graphics.setCanvas()
    self.textures.panic = panicCanvas
    
    -- Create trail particle texture
    local trailCanvas = love.graphics.newCanvas(6, 6)
    love.graphics.setCanvas(trailCanvas)
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 3, 3, 3)
    love.graphics.setCanvas()
    self.textures.trail = trailCanvas
    
    -- Create power particle texture
    local powerCanvas = love.graphics.newCanvas(8, 8)
    love.graphics.setCanvas(powerCanvas)
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.polygon('fill', 4, 0, 8, 4, 4, 8, 0, 4)
    love.graphics.setCanvas()
    self.textures.power = powerCanvas
end

function Particles:update(dt)
    for i = #self.systems, 1, -1 do
        local system = self.systems[i]
        system:update(dt)
        
        -- Remove dead systems
        if system:getCount() == 0 then
            table.remove(self.systems, i)
        end
    end
end

function Particles:draw()
    love.graphics.setBlendMode('add')
    for _, system in ipairs(self.systems) do
        love.graphics.draw(system)
    end
    love.graphics.setBlendMode('alpha')
end

function Particles:addThrowEffect(wielderType)
    if wielderType == "Panicked Rookie" then
        -- Panic particles
        local panicSystem = love.graphics.newParticleSystem(self.textures.panic, 100)
        panicSystem:setPosition(Game.wielder.x, Game.wielder.y)
        panicSystem:setParticleLifetime(0.5, 1)
        panicSystem:setEmissionRate(20)
        panicSystem:setSizeVariation(1)
        panicSystem:setLinearAcceleration(-100, -100, 100, 100)
        panicSystem:setColors(1, 0.7, 0.7, 1, 1, 0.7, 0.7, 0)
        panicSystem:emit(20)
        table.insert(self.systems, panicSystem)
        
        -- Stress wave
        local stressLevel = Game.wielder.types[wielderType].stressLevel
        local waveSystem = love.graphics.newParticleSystem(self.textures.panic, 50)
        waveSystem:setPosition(Game.wielder.x, Game.wielder.y)
        waveSystem:setParticleLifetime(0.3, 0.6)
        waveSystem:setEmissionRate(0)
        waveSystem:setSizeVariation(0.5)
        waveSystem:setSizes(1, 2, 0)
        waveSystem:setSpeed(100 + stressLevel * 2)
        waveSystem:setSpread(math.pi * 2)
        waveSystem:setColors(1, 0.5, 0.5, 1, 1, 0.5, 0.5, 0)
        waveSystem:emit(20)
        table.insert(self.systems, waveSystem)
    elseif wielderType == "Overconfident Barbarian" then
        -- Power particles
        local chargeLevel = Game.wielder.types[wielderType].chargeLevel
        local powerSystem = love.graphics.newParticleSystem(self.textures.power, 200)
        powerSystem:setPosition(Game.wielder.x, Game.wielder.y)
        powerSystem:setParticleLifetime(0.3, 0.6)
        powerSystem:setEmissionRate(0)
        powerSystem:setSizeVariation(0.5)
        powerSystem:setSizes(2, 1, 0)
        powerSystem:setSpeed(200 + chargeLevel * 300)
        powerSystem:setSpread(math.pi / 6)
        powerSystem:setColors(1, 0.2, 0.2, 1, 1, 0.5, 0.2, 0)
        powerSystem:emit(50)
        table.insert(self.systems, powerSystem)
        
        -- Shockwave
        local waveSystem = love.graphics.newParticleSystem(self.textures.power, 100)
        waveSystem:setPosition(Game.wielder.x, Game.wielder.y)
        waveSystem:setParticleLifetime(0.2, 0.4)
        waveSystem:setEmissionRate(0)
        waveSystem:setSizeVariation(0.3)
        waveSystem:setSizes(1, 3, 0)
        waveSystem:setSpeed(100 + chargeLevel * 200)
        waveSystem:setSpread(math.pi * 2)
        waveSystem:setColors(1, 0.3, 0.3, 1, 1, 0.3, 0.3, 0)
        waveSystem:emit(30)
        table.insert(self.systems, waveSystem)
    elseif wielderType == "Physics Expert" then
        -- Calculation particles
        local calcSystem = love.graphics.newParticleSystem(self.textures.power, 100)
        calcSystem:setPosition(Game.wielder.x, Game.wielder.y)
        calcSystem:setParticleLifetime(0.5, 1)
        calcSystem:setEmissionRate(0)
        calcSystem:setSizeVariation(0.3)
        calcSystem:setSizes(1, 0.5, 0)
        calcSystem:setSpeed(50, 100)
        calcSystem:setSpread(math.pi * 2)
        calcSystem:setColors(0.2, 0.4, 0.8, 1, 0.2, 0.4, 0.8, 0)
        calcSystem:emit(30)
        table.insert(self.systems, calcSystem)
        
        -- Trajectory line
        local trajectorySystem = love.graphics.newParticleSystem(self.textures.trail, 50)
        trajectorySystem:setPosition(Game.wielder.x, Game.wielder.y)
        trajectorySystem:setParticleLifetime(0.3, 0.6)
        trajectorySystem:setEmissionRate(0)
        trajectorySystem:setSizeVariation(0.2)
        trajectorySystem:setSizes(0.5, 0)
        trajectorySystem:setSpeed(200, 300)
        trajectorySystem:setSpread(math.pi/16) -- Narrow spread
        trajectorySystem:setColors(0.2, 0.8, 1, 1, 0.2, 0.8, 1, 0)
        trajectorySystem:emit(20)
        table.insert(self.systems, trajectorySystem)
        
        -- Theory particles (small equations)
        local theorySystem = love.graphics.newParticleSystem(self.textures.power, 20)
        theorySystem:setPosition(Game.wielder.x, Game.wielder.y)
        theorySystem:setParticleLifetime(1, 2)
        theorySystem:setEmissionRate(0)
        theorySystem:setSizeVariation(0.5)
        theorySystem:setSizes(1, 0.5)
        theorySystem:setSpeed(30, 60)
        theorySystem:setSpread(math.pi/2)
        theorySystem:setLinearDamping(1)
        theorySystem:setColors(0.4, 0.6, 1, 1, 0.4, 0.6, 1, 0)
        theorySystem:emit(10)
        table.insert(self.systems, theorySystem)
    end
end

function Particles:addTrailEffect(x, y, velocity)
    local speed = math.sqrt(velocity.x^2 + velocity.y^2)
    local trailSystem = love.graphics.newParticleSystem(self.textures.trail, 50)
    trailSystem:setPosition(x, y)
    trailSystem:setParticleLifetime(0.2, 0.4)
    trailSystem:setEmissionRate(30)
    trailSystem:setSizeVariation(0.5)
    trailSystem:setSizes(1, 0)
    trailSystem:setLinearDamping(5)
    trailSystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)
    table.insert(self.systems, trailSystem)
end

function Particles:addHitEffect(x, y, speed)
    -- Impact particles
    local hitSystem = love.graphics.newParticleSystem(self.textures.power, 30)
    hitSystem:setPosition(x, y)
    hitSystem:setParticleLifetime(0.1, 0.3)
    hitSystem:setEmissionRate(0)
    hitSystem:setSizeVariation(0.5)
    hitSystem:setSizes(2, 0)
    hitSystem:setSpeed(speed * 0.5)
    hitSystem:setSpread(math.pi * 2)
    hitSystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)
    hitSystem:emit(10)
    table.insert(self.systems, hitSystem)
end

function Particles:addDeathEffect(x, y, enemyType)
    if enemyType == "Slime" then
        -- Slime splatter
        local splatterSystem = love.graphics.newParticleSystem(self.textures.panic, 50)
        splatterSystem:setPosition(x, y)
        splatterSystem:setParticleLifetime(0.5, 1)
        splatterSystem:setEmissionRate(0)
        splatterSystem:setSizeVariation(0.5)
        splatterSystem:setSizes(2, 0)
        splatterSystem:setSpeed(100, 200)
        splatterSystem:setSpread(math.pi * 2)
        splatterSystem:setColors(0.2, 0.8, 0.2, 1, 0.2, 0.8, 0.2, 0)
        splatterSystem:emit(30)
        table.insert(self.systems, splatterSystem)
    elseif enemyType == "Bat" then
        -- Bat poof
        local poofSystem = love.graphics.newParticleSystem(self.textures.power, 50)
        poofSystem:setPosition(x, y)
        poofSystem:setParticleLifetime(0.3, 0.6)
        poofSystem:setEmissionRate(0)
        poofSystem:setSizeVariation(0.5)
        poofSystem:setSizes(1, 2, 0)
        poofSystem:setSpeed(50, 100)
        poofSystem:setSpread(math.pi * 2)
        poofSystem:setColors(0.6, 0.3, 0.6, 1, 0.6, 0.3, 0.6, 0)
        poofSystem:emit(20)
        table.insert(self.systems, poofSystem)
        
        -- Feathers
        local featherSystem = love.graphics.newParticleSystem(self.textures.power, 20)
        featherSystem:setPosition(x, y)
        featherSystem:setParticleLifetime(1, 2)
        featherSystem:setEmissionRate(0)
        featherSystem:setSizeVariation(0.3)
        featherSystem:setSizes(1, 0.5)
        featherSystem:setSpeed(30, 60)
        featherSystem:setSpread(math.pi * 2)
        featherSystem:setLinearDamping(1)
        featherSystem:setColors(0.8, 0.8, 0.8, 1, 0.8, 0.8, 0.8, 0)
        featherSystem:emit(10)
        table.insert(self.systems, featherSystem)
    end
end

function Particles:addShockwave(x, y)
    -- Create shockwave ring
    local shockwaveSystem = love.graphics.newParticleSystem(self.textures.power, 100)
    shockwaveSystem:setPosition(x, y)
    shockwaveSystem:setParticleLifetime(0.3, 0.5)
    shockwaveSystem:setEmissionRate(0)
    shockwaveSystem:setSizeVariation(0.3)
    shockwaveSystem:setSizes(1, 3, 0)
    shockwaveSystem:setSpeed(200, 300)
    shockwaveSystem:setSpread(math.pi * 2)
    shockwaveSystem:setColors(0.3, 1.0, 0.3, 1, 0.3, 1.0, 0.3, 0)
    shockwaveSystem:emit(50)
    table.insert(self.systems, shockwaveSystem)
    
    -- Create ground impact particles
    local impactSystem = love.graphics.newParticleSystem(self.textures.power, 30)
    impactSystem:setPosition(x, y)
    impactSystem:setParticleLifetime(0.5, 0.8)
    impactSystem:setEmissionRate(0)
    impactSystem:setSizeVariation(0.5)
    impactSystem:setSizes(2, 1, 0)
    impactSystem:setSpeed(50, 100)
    impactSystem:setLinearAcceleration(-100, -200, 100, 0) -- Particles shoot upward
    impactSystem:setColors(0.3, 1.0, 0.3, 1, 0.3, 1.0, 0.3, 0)
    impactSystem:emit(20)
    table.insert(self.systems, impactSystem)
end

function Particles:addTimeShardEffect(x, y)
    -- Create sparkle effect
    local sparkleSystem = love.graphics.newParticleSystem(self.textures.power, 50)
    sparkleSystem:setPosition(x, y)
    sparkleSystem:setParticleLifetime(0.3, 0.6)
    sparkleSystem:setEmissionRate(0)
    sparkleSystem:setSizeVariation(0.5)
    sparkleSystem:setSizes(1, 0.5, 0)
    sparkleSystem:setSpeed(50, 100)
    sparkleSystem:setSpread(math.pi * 2)
    sparkleSystem:setColors(0.4, 0.8, 1, 1, 0.4, 0.8, 1, 0)
    sparkleSystem:emit(20)
    table.insert(self.systems, sparkleSystem)
    
    -- Create time ripple
    local rippleSystem = love.graphics.newParticleSystem(self.textures.power, 20)
    rippleSystem:setPosition(x, y)
    rippleSystem:setParticleLifetime(0.5, 0.8)
    rippleSystem:setEmissionRate(0)
    rippleSystem:setSizeVariation(0.3)
    rippleSystem:setSizes(0.5, 2, 0)
    rippleSystem:setSpeed(30, 50)
    rippleSystem:setSpread(math.pi * 2)
    rippleSystem:setColors(0.2, 0.6, 1, 1, 0.2, 0.6, 1, 0)
    rippleSystem:emit(10)
    table.insert(self.systems, rippleSystem)
end

return Particles 