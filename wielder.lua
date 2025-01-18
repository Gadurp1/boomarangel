local Wielder = {
    types = {
        ["Panicked Rookie"] = {
            throwForce = function(confidence) 
                -- More confidence = more consistent force
                local baseForce = 300
                local variance = (1 - confidence) * 200
                return baseForce + love.math.random(-variance, variance)
            end,
            throwAngle = function(confidence)
                -- More confidence = narrower cone
                local spread = (1 - confidence) * math.pi
                return love.math.random(-spread/2, spread/2)
            end,
            confidence = 0,
            special = "Flail-and-Pray",
            color = {0.8, 0.6, 0.2},
            stressLevel = 0,
            maxStress = 100
        },
        ["Overconfident Barbarian"] = {
            throwForce = function(confidence)
                -- Always maximum power, sometimes TOO maximum
                local baseForce = 600
                local extraPower = love.math.random(0, 200)
                return baseForce + extraPower
            end,
            throwAngle = function(confidence)
                -- Wider spread with more confidence (thinks they don't need to aim)
                local spread = confidence * math.pi * 0.75
                return love.math.random(-spread/2, spread/2)
            end,
            confidence = 0.8, -- Starts very confident
            special = "MAXIMUM POWER",
            color = {0.8, 0.2, 0.2},
            stressLevel = 0,
            maxStress = 100,
            chargeLevel = 0,
            maxCharge = 2,
            isCharging = false
        },
        ["Physics Expert"] = {
            throwForce = function(confidence)
                -- Precise force based on calculations
                return 400 -- Always consistent base force
            end,
            throwAngle = function(confidence)
                -- Perfect angle... in theory
                return 0 -- Straight ahead
            end,
            confidence = 0.5,
            special = "Calculated Arc",
            color = {0.2, 0.4, 0.8},
            stressLevel = 0,
            maxStress = 100,
            calculationTime = 0,
            maxCalculationTime = 2,
            isCalculating = false,
            predictedPath = {},
            equations = {} -- Stores floating equations
        }
    },
    x = 400,
    y = 300,
    type = "Panicked Rookie",
    throwCooldown = 0,
    throwDelay = 2,
    moveSpeed = 100,
    screenShake = 0
}

function Wielder:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Wielder:create(type)
    local wielder = Wielder:new()
    wielder.type = type
    return wielder
end

function Wielder:update(dt)
    -- Update throw cooldown
    if self.throwCooldown > 0 then
        self.throwCooldown = self.throwCooldown - dt
    end
    
    local type = self.types[self.type]
    
    -- Handle charging for Barbarian
    if self.type == "Overconfident Barbarian" then
        if love.keyboard.isDown('space') and Game.boomerang.state == "held" then
            type.isCharging = true
            type.chargeLevel = math.min(type.chargeLevel + dt, type.maxCharge)
            self.screenShake = type.chargeLevel * 5
        elseif type.isCharging then
            type.isCharging = false
            if type.chargeLevel > 0.5 then
                self:throw()
            end
            type.chargeLevel = 0
            self.screenShake = 0
        end
    -- Handle calculations for Physics Expert
    elseif self.type == "Physics Expert" then
        if love.keyboard.isDown('space') and Game.boomerang.state == "held" then
            type.isCalculating = true
            type.calculationTime = math.min(type.calculationTime + dt, type.maxCalculationTime)
            -- Generate floating equations
            if love.math.random() < 0.1 then
                table.insert(type.equations, {
                    text = "E = mc²",
                    x = self.x + love.math.random(-50, 50),
                    y = self.y + love.math.random(-50, 50),
                    life = 2,
                    alpha = 1
                })
            end
            -- Update predicted path
            self:updatePredictedPath()
        elseif type.isCalculating then
            type.isCalculating = false
            if type.calculationTime > 1 then -- Need minimum calculation time
                self:throw()
            end
            type.calculationTime = 0
            type.predictedPath = {}
        end
        
        -- Update floating equations
        for i = #type.equations, 1, -1 do
            local eq = type.equations[i]
            eq.life = eq.life - dt
            eq.alpha = eq.life / 2
            eq.y = eq.y - 20 * dt -- Float upward
            if eq.life <= 0 then
                table.remove(type.equations, i)
            end
        end
    end
    
    -- Move wielder
    if Game.boomerang.state == "held" and not type.isCharging then
        if love.keyboard.isDown('a') then
            self.x = self.x - self.moveSpeed * dt
        end
        if love.keyboard.isDown('d') then
            self.x = self.x + self.moveSpeed * dt
        end
        if love.keyboard.isDown('w') then
            self.y = self.y - self.moveSpeed * dt
        end
        if love.keyboard.isDown('s') then
            self.y = self.y + self.moveSpeed * dt
        end
    end
    
    -- Update stress level
    if Game.boomerang.state == "flying" then
        type.stressLevel = math.min(type.stressLevel + dt * 10, type.maxStress)
    else
        type.stressLevel = math.max(type.stressLevel - dt * 5, 0)
    end
    
    -- Regular throw for Panicked Rookie
    if self.type == "Panicked Rookie" and love.keyboard.wasPressed('space') and 
       self.throwCooldown <= 0 and Game.boomerang.state == "held" then
        self:throw()
    end
    
    -- Apply screen shake
    if self.screenShake > 0 then
        self.x = self.x + love.math.random(-self.screenShake, self.screenShake)
        self.y = self.y + love.math.random(-self.screenShake, self.screenShake)
        self.screenShake = math.max(0, self.screenShake - dt * 10)
    end
end

function Wielder:updatePredictedPath()
    local type = self.types[self.type]
    type.predictedPath = {}
    
    -- Calculate theoretical path
    local x = self.x
    local y = self.y
    local force = type.throwForce(type.confidence)
    local angle = type.throwAngle(type.confidence)
    local vx = math.cos(angle) * force
    local vy = math.sin(angle) * force
    
    -- Predict 20 points along the path
    for i = 1, 20 do
        table.insert(type.predictedPath, {
            x = x + vx * (i/20),
            y = y + vy * (i/20)
        })
    end
end

function Wielder:throw()
    local type = self.types[self.type]
    local force = type.throwForce(type.confidence)
    local angle = type.throwAngle(type.confidence)
    
    -- Add stress shake to throw
    local stressShake = (type.stressLevel / type.maxStress) * math.pi/4
    angle = angle + love.math.random(-stressShake, stressShake)
    
    -- Apply charge multiplier for Barbarian
    if self.type == "Overconfident Barbarian" then
        force = force * (1 + type.chargeLevel)
        self.screenShake = 20 * type.chargeLevel
    -- Apply calculation bonus for Physics Expert
    elseif self.type == "Physics Expert" then
        -- More calculation time = more accurate
        local accuracy = type.calculationTime / type.maxCalculationTime
        force = force * (0.8 + accuracy * 0.4)
        angle = angle * (1 - accuracy * 0.9) -- Less random deviation
    end
    
    Game.boomerang.x = self.x
    Game.boomerang.y = self.y
    Game.boomerang.velocity.x = math.cos(angle) * force
    Game.boomerang.velocity.y = math.sin(angle) * force
    Game.boomerang.state = "flying"
    
    -- Reset throw cooldown
    self.throwCooldown = self.throwDelay
    
    -- Add throw effects
    Game.particles:addThrowEffect(self.type)
end

function Wielder:draw()
    local type = self.types[self.type]
    
    -- Draw prediction line for Physics Expert
    if self.type == "Physics Expert" and type.isCalculating then
        love.graphics.setColor(0.2, 0.4, 0.8, 0.3)
        for i = 1, #type.predictedPath-1 do
            local p1 = type.predictedPath[i]
            local p2 = type.predictedPath[i+1]
            love.graphics.line(p1.x, p1.y, p2.x, p2.y)
        end
        
        -- Draw floating equations
        love.graphics.setColor(0.2, 0.4, 0.8, 1)
        for _, eq in ipairs(type.equations) do
            love.graphics.setColor(0.2, 0.4, 0.8, eq.alpha)
            love.graphics.print(eq.text, eq.x, eq.y)
        end
        
        -- Draw calculation progress
        local calcRadius = 30 + type.calculationTime * 10
        love.graphics.setColor(0.2, 0.4, 0.8, 0.2)
        love.graphics.circle('fill', self.x, self.y, calcRadius)
    end
    
    -- Draw charge indicator for Barbarian
    if self.type == "Overconfident Barbarian" and type.isCharging then
        local chargeRadius = 30 + type.chargeLevel * 20
        love.graphics.setColor(1, 0, 0, 0.3)
        love.graphics.circle('fill', self.x, self.y, chargeRadius)
    end
    
    -- Draw stress indicator
    local stressColor = {1, 1 - (type.stressLevel/type.maxStress), 1 - (type.stressLevel/type.maxStress)}
    love.graphics.setColor(stressColor[1], stressColor[2], stressColor[3], 0.3)
    love.graphics.circle('fill', self.x, self.y, 25 + (type.stressLevel/type.maxStress) * 10)
    
    -- Draw wielder
    love.graphics.setColor(type.color[1], type.color[2], type.color[3], 1)
    love.graphics.circle('fill', self.x, self.y, 20)
    
    -- Draw throw cooldown indicator
    if self.throwCooldown > 0 then
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.arc('fill', self.x, self.y, 25, 0, (1 - self.throwCooldown/self.throwDelay) * math.pi * 2)
    end
    
    -- Draw confidence meter
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.rectangle('line', self.x - 25, self.y - 40, 50, 5)
    love.graphics.rectangle('fill', self.x - 25, self.y - 40, 50 * type.confidence, 5)
end

return Wielder 