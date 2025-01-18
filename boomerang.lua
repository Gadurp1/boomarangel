local Boomerang = {
    x = 0,
    y = 0,
    rotation = 0,
    velocity = {x = 0, y = 0},
    state = "held", -- held/flying/returning/stuck
    trail = {},
    maxTrailPoints = 20,
    controlSpeed = 200,
    returnSpeed = 300,
    maxSpeed = 800,
    spinSpeed = 15,
    returnTimer = 0,
    maxFlightTime = 3,
    damage = 10,
    size = 10,
    
    -- Bounce mechanics
    bounceCount = 0,
    maxBounces = 3,
    bounceMultiplier = 1.2, -- Speed increases with each bounce
    stickTimer = 0,
    maxStickTime = 1.5,
    
    -- Upgrades
    upgrades = {
        multiBoomerang = false,     -- Split into multiple boomerangs on bounce
        wallStick = false,          -- Can stick to walls temporarily
        phaseThrough = false,       -- Can phase through walls occasionally
        energyBounce = false,       -- Gains speed on bounce
        homingReturn = false,       -- Better return tracking
        ghostTrail = false,         -- Leave damaging trail
        timeWarp = false,         -- Slow time when aiming
        rubberPhysics = false,    -- More bouncy, less predictable
        gravityWell = false,      -- Pull enemies towards boomerang
        elementalTrail = false,   -- Trail effects based on speed
        comboSystem = false,      -- Chain hits increase damage
        timeExtension = false,  -- Increases base flight time by 2 seconds
    },
    
    -- Upgrade effects
    ghostTrailDamage = 5,
    splitBoomerangs = {},
    phaseCharge = 0,
    maxPhaseCharge = 100,
    
    -- Wielder-specific abilities
    abilities = {
        ["Panicked Rookie"] = {
            flailAndPray = {
                active = false,
                duration = 2,
                timer = 0,
                chaosMultiplier = 2,
                randomInterval = 0.1
            },
            backwardsToss = {
                active = false,
                rearDamageMultiplier = 2
            }
        },
        ["Overconfident Barbarian"] = {
            spinToWin = {
                active = false,
                duration = 3,
                timer = 0,
                spiralRadius = 50,
                spiralSpeed = 10
            },
            maximumPower = {
                active = false,
                speedMultiplier = 2,
                wallBreakThreshold = 1000
            }
        },
        ["Physics Expert"] = {
            quantumUncertainty = {
                active = false,
                phantomCount = 3,
                phantoms = {},
                convergeDamage = 3
            },
            calculatedArc = {
                active = false,
                precisionMultiplier = 2,
                criticalHitChance = 0.3
            }
        }
    },
    
    -- Combo system
    combo = {
        count = 0,
        timer = 0,
        maxTime = 2,
        multiplier = 1
    },
    
    -- Physics modifiers
    physics = {
        gravityRadius = 100,
        gravityForce = 200,
        timeScale = 1,
        rubberiness = 1
    },
    
    -- Planning phase properties
    planning = {
        active = false,
        duration = 3,
        timer = 0,
        throwArea = {
            x = 0,
            y = 0,
            width = 200,
            height = 200
        },
        trajectoryPreview = {},
        maxPreviewPoints = 50,
        previewUpdateRate = 0.1,
        previewTimer = 0
    },

    -- Enhanced prediction system
    prediction = {
        points = {},
        maxPoints = 30,
        timeStep = 0.1,
        maxTime = 3
    },
    
    -- Game state management
    gameState = {
        phase = "planning", -- planning/active
        canMove = false,
        enemiesActive = false
    },
    
    -- Time mechanics
    flightTimeLimit = 5, -- Base time limit in seconds
    currentFlightTime = 0,
    timeShardBonus = 0, -- Additional time from collected shards
    maxTimeShardBonus = 5, -- Maximum additional time from shards
}

function Boomerang:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Boomerang:update(dt)
    -- Update planning phase
    if self.planning.active then
        self:updatePlanningPhase(dt)
        return
    end
    
    -- Update combo system
    if self.upgrades.comboSystem then
        self:updateCombo(dt)
    end
    
    -- Apply time warp
    local effectiveDt = dt
    if self.upgrades.timeWarp and love.keyboard.isDown('lshift') then
        effectiveDt = dt * 0.5
        self.physics.timeScale = 0.5
    else
        self.physics.timeScale = 1
    end
    
    -- When boomerang is active (flying/returning), disable movement
    if self.state == "flying" or self.state == "returning" then
        self.gameState.canMove = false
        self.gameState.enemiesActive = false
        
        -- Freeze all enemies in place
        if Game.enemies then
            for _, enemy in ipairs(Game.enemies) do
                enemy.frozen = true
            end
        end
        
        -- Update return timer
        if self.state == "flying" then
            self.returnTimer = self.returnTimer + dt
            if self.returnTimer >= self.maxFlightTime then
                self.state = "returning"
            end
        end
        
        -- Handle stuck state
        if self.state == "stuck" then
            self.stickTimer = self.stickTimer + dt
            if self.stickTimer >= self.maxStickTime then
                self.state = "returning"
                self.stickTimer = 0
            end
            return
        end
        
        -- Apply player control
        if love.keyboard.isDown('left') then
            self.velocity.x = self.velocity.x - self.controlSpeed * dt
        end
        if love.keyboard.isDown('right') then
            self.velocity.x = self.velocity.x + self.controlSpeed * dt
        end
        if love.keyboard.isDown('up') then
            self.velocity.y = self.velocity.y - self.controlSpeed * dt
        end
        if love.keyboard.isDown('down') then
            self.velocity.y = self.velocity.y + self.controlSpeed * dt
        end
        
        -- Phase charging
        if self.upgrades.phaseThrough then
            if love.keyboard.isDown('lshift') then
                self.phaseCharge = math.min(self.phaseCharge + dt * 50, self.maxPhaseCharge)
            else
                self.phaseCharge = math.max(0, self.phaseCharge - dt * 25)
            end
        end
        
        -- Cap maximum speed
        local speed = math.sqrt(self.velocity.x^2 + self.velocity.y^2)
        if speed > self.maxSpeed then
            self.velocity.x = (self.velocity.x / speed) * self.maxSpeed
            self.velocity.y = (self.velocity.y / speed) * self.maxSpeed
        end
        
        -- Return mechanic
        if self.state == "flying" and (love.keyboard.wasPressed('r') or speed < 50) then
            self.state = "returning"
        end
        
        if self.state == "returning" then
            -- Calculate direction to wielder
            local dx = Game.wielder.x - self.x
            local dy = Game.wielder.y - self.y
            local dist = math.sqrt(dx^2 + dy^2)
            
            -- Return to wielder
            if dist < 20 then
                self:resetState()
            else
                -- Apply return force with increasing strength
                local returnMult = math.min(3, 1 + self.returnTimer)
                if self.upgrades.homingReturn then
                    returnMult = returnMult * 1.5
                end
                self.velocity.x = self.velocity.x + (dx/dist) * self.returnSpeed * dt * returnMult
                self.velocity.y = self.velocity.y + (dy/dist) * self.returnSpeed * dt * returnMult
            end
        end
        
        -- Apply wielder's throw characteristics
        self:applyWielderEffect(dt)
        
        -- Update position
        self.x = self.x + self.velocity.x * dt
        self.y = self.y + self.velocity.y * dt
        
        -- Update rotation based on velocity
        local speed = math.sqrt(self.velocity.x^2 + self.velocity.y^2)
        self.rotation = self.rotation + self.spinSpeed * dt * (speed/200)
        
        -- Check enemy collisions
        if Game.enemies then
            self:checkEnemyCollisions()
        end
        
        -- Update ghost trail
        if self.upgrades.ghostTrail then
            self:updateGhostTrail(dt)
        end
        
        -- Update trail
        self:updateTrail()
    else
        -- When boomerang is held, allow movement
        self.gameState.canMove = true
        self.gameState.enemiesActive = true
        
        -- Unfreeze enemies
        if Game.enemies then
            for _, enemy in ipairs(Game.enemies) do
                enemy.frozen = false
            end
        end
        
        -- Stay with wielder when held
        self.x = Game.wielder.x
        self.y = Game.wielder.y
    end
    
    -- Update split boomerangs
    for i = #self.splitBoomerangs, 1, -1 do
        local split = self.splitBoomerangs[i]
        split.lifetime = split.lifetime - dt
        if split.lifetime <= 0 then
            table.remove(self.splitBoomerangs, i)
        else
            split.x = split.x + split.velocity.x * dt
            split.y = split.y + split.velocity.y * dt
            -- Check enemy collisions for splits
            self:checkSplitCollisions(split)
        end
    end
    
    -- Apply gravity well
    if self.upgrades.gravityWell and (self.state == "flying" or self.state == "returning") then
        self:applyGravityWell(dt)
    end
    
    -- Update wielder-specific abilities
    self:updateAbilities(dt)
    
    -- Update flight time
    if self.state == "flying" then
        self.currentFlightTime = self.currentFlightTime + dt
        
        -- Calculate total time limit
        local totalTimeLimit = self.flightTimeLimit
        if self.upgrades.timeExtension then
            totalTimeLimit = totalTimeLimit + 2
        end
        totalTimeLimit = totalTimeLimit + self.timeShardBonus
        
        -- Force return if time limit reached
        if self.currentFlightTime >= totalTimeLimit then
            self.state = "returning"
        end
    end
end

function Boomerang:checkEnemyCollisions()
    for _, enemy in ipairs(Game.enemies) do
        local dx = enemy.x - self.x
        local dy = enemy.y - self.y
        local dist = math.sqrt(dx^2 + dy^2)
        
        if dist < self.size + enemy.size then
            -- Calculate damage based on speed
            local speed = math.sqrt(self.velocity.x^2 + self.velocity.y^2)
            local damage = self.damage * (speed / 200)
            
            -- Apply damage and knockback
            enemy:takeDamage(damage)
            
            -- Add hit effect
            Game.particles:addHitEffect(self.x, self.y, speed)
            
            -- Bounce off enemy
            if self.state == "flying" then
                self.velocity.x = -self.velocity.x * 0.5
                self.velocity.y = -self.velocity.y * 0.5
                self.state = "returning"
            end
        end
    end
    
    -- Update combo system
    if self.upgrades.comboSystem and hit then
        self.combo.count = self.combo.count + 1
        self.combo.timer = 0
        self.combo.multiplier = 1 + (self.combo.count * 0.1)
        damage = damage * self.combo.multiplier
    end
    
    -- Apply elemental effects based on speed
    if self.upgrades.elementalTrail then
        local speed = math.sqrt(self.velocity.x^2 + self.velocity.y^2)
        if speed > self.maxSpeed * 0.8 then
            Game.particles:addFireTrail(self.x, self.y)
        elseif speed > self.maxSpeed * 0.5 then
            Game.particles:addLightningTrail(self.x, self.y)
        else
            Game.particles:addIceTrail(self.x, self.y)
        end
    end
end

function Boomerang:applyWielderEffect(dt)
    if Game.wielder.type == "Panicked Rookie" then
        -- Random trajectory changes
        if love.math.random() < 0.1 then
            self.velocity.x = self.velocity.x + love.math.random(-100, 100)
            self.velocity.y = self.velocity.y + love.math.random(-100, 100)
        end
    end
end

function Boomerang:updateTrail()
    table.insert(self.trail, 1, {x = self.x, y = self.y})
    if #self.trail > self.maxTrailPoints then
        table.remove(self.trail)
    end
end

function Boomerang:draw()
    -- Draw planning phase elements
    if self.planning.active then
        -- Draw throw area
        love.graphics.setColor(0.2, 0.8, 0.2, 0.3)
        love.graphics.rectangle('fill', 
            self.planning.throwArea.x, 
            self.planning.throwArea.y,
            self.planning.throwArea.width, 
            self.planning.throwArea.height
        )
        
        -- Draw trajectory preview
        love.graphics.setColor(1, 1, 1, 0.5)
        for i = 1, #self.planning.trajectoryPreview - 1 do
            local p1 = self.planning.trajectoryPreview[i]
            local p2 = self.planning.trajectoryPreview[i + 1]
            love.graphics.line(p1.x, p1.y, p2.x, p2.y)
        end
        
        -- Draw planning timer
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(string.format("Planning: %.1fs", self.planning.timer),
            10, 10)
    end
    
    -- Draw trail
    for i, point in ipairs(self.trail) do
        local alpha = (1 - (i / #self.trail)) * 255
        love.graphics.setColor(1, 1, 1, alpha/255)
        love.graphics.circle('fill', point.x, point.y, 2)
    end
    
    -- Draw boomerang
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)
    love.graphics.polygon('fill', -10, -5, 10, -5, 10, 5, -10, 5)
    love.graphics.pop()
    
    -- Draw time remaining if in flight
    if self.state == "flying" then
        local totalTimeLimit = self.flightTimeLimit
        if self.upgrades.timeExtension then
            totalTimeLimit = totalTimeLimit + 2
        end
        totalTimeLimit = totalTimeLimit + self.timeShardBonus
        
        local timeRemaining = totalTimeLimit - self.currentFlightTime
        local timePercent = timeRemaining / totalTimeLimit
        
        -- Draw time ring
        love.graphics.setColor(0.4, 0.8, 1, 0.5)
        love.graphics.arc('fill', self.x, self.y, 15, 0, timePercent * math.pi * 2)
        
        -- Draw time shard bonus indicator
        if self.timeShardBonus > 0 then
            love.graphics.setColor(0.2, 0.6, 1, 0.8)
            love.graphics.arc('fill', self.x, self.y, 12, 0, (self.timeShardBonus / self.maxTimeShardBonus) * math.pi * 2)
        end
    end
end

function Boomerang:handleWallCollision(hitX, hitY, normalX, normalY)
    if self.upgrades.wallStick and love.keyboard.isDown('lshift') then
        -- Stick to wall
        self.state = "stuck"
        self.x = hitX
        self.y = hitY
        self.velocity.x = 0
        self.velocity.y = 0
        return
    end
    
    if self.upgrades.phaseThrough and self.phaseCharge > 50 then
        -- Phase through wall
        self.phaseCharge = self.phaseCharge - 50
        return
    end
    
    -- Normal bounce with potential energy gain
    self.bounceCount = self.bounceCount + 1
    
    -- Calculate reflection
    local speed = math.sqrt(self.velocity.x^2 + self.velocity.y^2)
    local dot = self.velocity.x * normalX + self.velocity.y * normalY
    self.velocity.x = self.velocity.x - 2 * dot * normalX
    self.velocity.y = self.velocity.y - 2 * dot * normalY
    
    -- Apply energy bounce if upgraded
    if self.upgrades.energyBounce then
        local newSpeed = speed * self.bounceMultiplier
        self.velocity.x = self.velocity.x * (newSpeed/speed)
        self.velocity.y = self.velocity.y * (newSpeed/speed)
    end
    
    -- Create split boomerangs
    if self.upgrades.multiBoomerang and self.bounceCount <= self.maxBounces then
        self:createSplitBoomerangs(hitX, hitY)
    end
    
    -- Add bounce effect
    Game.particles:addBounceEffect(hitX, hitY, speed)
    
    -- Apply rubber physics
    if self.upgrades.rubberPhysics then
        local randomAngle = love.math.random() * math.pi/4 - math.pi/8
        local rotatedNormalX = normalX * math.cos(randomAngle) - normalY * math.sin(randomAngle)
        local rotatedNormalY = normalX * math.sin(randomAngle) + normalY * math.cos(randomAngle)
        normalX = rotatedNormalX
        normalY = rotatedNormalY
        
        -- Increase bounce speed
        speed = speed * (1 + self.physics.rubberiness * 0.2)
    end
end

function Boomerang:createSplitBoomerangs(x, y)
    local angles = {-math.pi/4, math.pi/4}
    for _, angle in ipairs(angles) do
        local speed = math.sqrt(self.velocity.x^2 + self.velocity.y^2)
        local splitVelX = math.cos(angle) * speed * 0.5
        local splitVelY = math.sin(angle) * speed * 0.5
        table.insert(self.splitBoomerangs, {
            x = x,
            y = y,
            velocity = {x = splitVelX, y = splitVelY},
            lifetime = 0.5,
            damage = self.damage * 0.5
        })
    end
end

function Boomerang:checkSplitCollisions(split)
    for _, enemy in ipairs(Game.enemies) do
        local dx = enemy.x - split.x
        local dy = enemy.y - split.y
        local dist = math.sqrt(dx^2 + dy^2)
        
        if dist < enemy.size + 5 then
            enemy:takeDamage(split.damage)
            Game.particles:addHitEffect(split.x, split.y, 
                math.sqrt(split.velocity.x^2 + split.velocity.y^2))
        end
    end
end

function Boomerang:updateGhostTrail(dt)
    for i, point in ipairs(self.trail) do
        -- Check enemy collisions with trail
        for _, enemy in ipairs(Game.enemies) do
            local dx = enemy.x - point.x
            local dy = enemy.y - point.y
            local dist = math.sqrt(dx^2 + dy^2)
            
            if dist < enemy.size + 5 then
                enemy:takeDamage(self.ghostTrailDamage * dt)
            end
        end
    end
end

function Boomerang:resetState()
    self.state = "held"
    self.x = Game.wielder.x
    self.y = Game.wielder.y
    self.velocity.x = 0
    self.velocity.y = 0
    self.returnTimer = 0
    self.bounceCount = 0
    self.stickTimer = 0
    self.splitBoomerangs = {}
    
    -- Reset game state for next round
    self.gameState.phase = "planning"
    self.gameState.canMove = false
    self.gameState.enemiesActive = false
end

function Boomerang:updateAbilities(dt)
    local currentAbilities = self.abilities[Game.wielder.type]
    if not currentAbilities then return end
    
    -- Panicked Rookie abilities
    if Game.wielder.type == "Panicked Rookie" then
        if currentAbilities.flailAndPray.active then
            self:updateFlailAndPray(dt)
        end
        -- Check for backwards hit bonus
        if currentAbilities.backwardsToss.active then
            self:checkBackwardsHits()
        end
    
    -- Barbarian abilities
    elseif Game.wielder.type == "Overconfident Barbarian" then
        if currentAbilities.spinToWin.active then
            self:updateSpinToWin(dt)
        end
        if currentAbilities.maximumPower.active then
            self:checkWallBreak()
        end
    
    -- Physics Expert abilities
    elseif Game.wielder.type == "Physics Expert" then
        if currentAbilities.quantumUncertainty.active then
            self:updateQuantumPhantoms(dt)
        end
        if currentAbilities.calculatedArc.active then
            self:updateCalculatedArc()
        end
    end
end

function Boomerang:updateFlailAndPray(dt)
    local flail = self.abilities["Panicked Rookie"].flailAndPray
    flail.timer = flail.timer + dt
    
    if flail.timer >= flail.randomInterval then
        flail.timer = 0
        -- Add random velocity changes
        self.velocity.x = self.velocity.x + love.math.random(-200, 200) * flail.chaosMultiplier
        self.velocity.y = self.velocity.y + love.math.random(-200, 200) * flail.chaosMultiplier
    end
end

function Boomerang:updateSpinToWin(dt)
    local spin = self.abilities["Overconfident Barbarian"].spinToWin
    spin.timer = spin.timer + dt
    
    -- Create spiral pattern
    local angle = spin.timer * spin.spiralSpeed
    local targetX = Game.wielder.x + math.cos(angle) * spin.spiralRadius
    local targetY = Game.wielder.y + math.sin(angle) * spin.spiralRadius
    
    -- Move towards spiral point
    local dx = targetX - self.x
    local dy = targetY - self.y
    local dist = math.sqrt(dx^2 + dy^2)
    if dist > 0 then
        self.velocity.x = dx/dist * self.maxSpeed
        self.velocity.y = dy/dist * self.maxSpeed
    end
end

function Boomerang:updateQuantumPhantoms(dt)
    local quantum = self.abilities["Physics Expert"].quantumUncertainty
    
    -- Update phantom positions
    for i, phantom in ipairs(quantum.phantoms) do
        phantom.timer = phantom.timer + dt
        phantom.x = phantom.startX + math.cos(phantom.timer * 2) * 30
        phantom.y = phantom.startY + math.sin(phantom.timer * 2) * 30
        
        -- Check phantom collisions
        for _, enemy in ipairs(Game.enemies) do
            local dx = enemy.x - phantom.x
            local dy = enemy.y - phantom.y
            local dist = math.sqrt(dx^2 + dy^2)
            if dist < enemy.size + self.size then
                enemy:takeDamage(self.damage * 0.3)
                Game.particles:addPhantomHitEffect(phantom.x, phantom.y)
            end
        end
    end
end

function Boomerang:updateCombo(dt)
    if self.combo.count > 0 then
        self.combo.timer = self.combo.timer + dt
        if self.combo.timer >= self.combo.maxTime then
            self.combo.count = 0
            self.combo.multiplier = 1
        end
    end
end

function Boomerang:applyGravityWell(dt)
    for _, enemy in ipairs(Game.enemies) do
        local dx = self.x - enemy.x
        local dy = self.y - enemy.y
        local dist = math.sqrt(dx^2 + dy^2)
        
        if dist < self.physics.gravityRadius and dist > 0 then
            local force = (1 - dist/self.physics.gravityRadius) * self.physics.gravityForce
            enemy.x = enemy.x + (dx/dist) * force * dt
            enemy.y = enemy.y + (dy/dist) * force * dt
        end
    end
end

function Boomerang:startPlanningPhase()
    self.planning.active = true
    self.planning.timer = self.planning.duration
    -- Set initial throw area based on wielder position
    self.planning.throwArea.x = Game.wielder.x - self.planning.throwArea.width/2
    self.planning.throwArea.y = Game.wielder.y - self.planning.throwArea.height/2
    
    -- Lock movement during planning
    self.gameState.phase = "planning"
    self.gameState.canMove = false
    self.gameState.enemiesActive = false
    
    -- Signal game to freeze enemies
    if Game.enemies then
        for _, enemy in ipairs(Game.enemies) do
            enemy.frozen = true
        end
    end
end

function Boomerang:updatePlanningPhase(dt)
    if not self.planning.active then return end
    
    self.planning.timer = self.planning.timer - dt
    
    -- Update trajectory preview
    self.planning.previewTimer = self.planning.previewTimer - dt
    if self.planning.previewTimer <= 0 then
        self.planning.previewTimer = self.planning.previewUpdateRate
        self:updateTrajectoryPreview()
    end
    
    -- Check if planning phase is over
    if self.planning.timer <= 0 then
        self.planning.active = false
        -- Start active phase
        self:startActivePhase()
        -- Automatically throw the boomerang
        if self.state == "held" then
            self:throw()
        end
    end
end

function Boomerang:startActivePhase()
    self.gameState.phase = "active"
    self.gameState.canMove = true
    self.gameState.enemiesActive = true
    
    -- Signal game to unfreeze enemies
    if Game.enemies then
        for _, enemy in ipairs(Game.enemies) do
            enemy.frozen = false
            -- Set enemies to chase mode
            enemy.state = "chase"
        end
    end
end

function Boomerang:isGameplayActive()
    return self.gameState.phase == "active"
end

function Boomerang:canMoveWielder()
    return self.gameState.canMove
end

function Boomerang:areEnemiesActive()
    return self.gameState.enemiesActive
end

function Boomerang:updateTrajectoryPreview()
    self.planning.trajectoryPreview = {}
    
    -- Get mouse position for aiming
    local mx, my = love.mouse.getPosition()
    
    -- Calculate throw vector
    local dx = mx - self.x
    local dy = my - self.y
    local dist = math.sqrt(dx^2 + dy^2)
    
    -- Normalize and apply throw speed
    local speed = math.min(dist, self.maxSpeed)
    local vx = (dx/dist) * speed
    local vy = (dy/dist) * speed
    
    -- Simulate trajectory
    local simX, simY = self.x, self.y
    local simVX, simVY = vx, vy
    
    for i = 1, self.planning.maxPreviewPoints do
        -- Add point to preview
        table.insert(self.planning.trajectoryPreview, {x = simX, y = simY})
        
        -- Simple physics simulation
        simX = simX + simVX * self.planning.previewUpdateRate
        simY = simY + simVY * self.planning.previewUpdateRate
        
        -- Apply wielder effects to prediction
        if Game.wielder.type == "Panicked Rookie" then
            -- Add some randomness to prediction
            simVX = simVX + love.math.random(-20, 20)
            simVY = simVY + love.math.random(-20, 20)
        elseif Game.wielder.type == "Physics Expert" then
            -- More accurate prediction
            -- Add subtle curves based on calculated arc
            local time = i * self.planning.previewUpdateRate
            simVX = simVX + math.cos(time) * 5
            simVY = simVY + math.sin(time) * 5
        end
    end
end

function Boomerang:throw()
    if not self:isInThrowArea() then return end
    
    -- Get mouse position for throw direction
    local mx, my = love.mouse.getPosition()
    local dx = mx - self.x
    local dy = my - self.y
    local dist = math.sqrt(dx^2 + dy^2)
    
    -- Set initial velocity based on aim
    local speed = math.min(dist, self.maxSpeed)
    self.velocity.x = (dx/dist) * speed
    self.velocity.y = (dy/dist) * speed
    
    self.state = "flying"
    self.returnTimer = 0
end

function Boomerang:isInThrowArea()
    return self.x >= self.planning.throwArea.x and
           self.x <= self.planning.throwArea.x + self.planning.throwArea.width and
           self.y >= self.planning.throwArea.y and
           self.y <= self.planning.throwArea.y + self.planning.throwArea.height
end

function Boomerang:collectTimeShard()
    -- Add time bonus up to maximum
    local shardTimeBonus = 1 -- Each shard gives 1 second
    self.timeShardBonus = math.min(self.timeShardBonus + shardTimeBonus, self.maxTimeShardBonus)
    
    -- Create collection effect
    Game.particles:addTimeShardEffect(self.x, self.y)
end

return Boomerang 