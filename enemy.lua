local Enemy = {
    types = {
        ["Slime"] = {
            health = 30,
            speed = 50,
            size = 15,
            color = {0.2, 0.8, 0.2},
            bounceHeight = 10,
            bounceSpeed = 4
        },
        ["Bat"] = {
            health = 20,
            speed = 80,
            size = 10,
            color = {0.6, 0.3, 0.6},
            flutterSpeed = 8,
            flutterHeight = 5
        },
        ["SlimeKing"] = {
            health = 300,
            speed = 30,
            size = 40,
            color = {0.3, 1.0, 0.3},
            bounceHeight = 20,
            bounceSpeed = 2,
            attackCooldown = 3,
            attackTypes = {"slam", "split", "charge"}
        }
    }
}

function Enemy:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Enemy:create(type, x, y)
    local enemy = Enemy:new()
    enemy.type = type
    enemy.x = x
    enemy.y = y
    enemy.health = Enemy.types[type].health
    enemy.maxHealth = Enemy.types[type].health  -- Store max health for boss health bar
    enemy.speed = Enemy.types[type].speed
    enemy.size = Enemy.types[type].size
    enemy.color = Enemy.types[type].color
    enemy.time = love.math.random() * 10
    enemy.stunTime = 0
    enemy.knockbackVel = {x = 0, y = 0}
    
    -- Boss-specific properties
    if type == "SlimeKing" then
        enemy.attackTimer = Enemy.types[type].attackCooldown
        enemy.currentAttack = nil
        enemy.attackPhase = 0
        enemy.targetX = x
        enemy.targetY = y
    end
    
    return enemy
end

function Enemy:update(dt)
    -- If frozen, don't update position
    if self.frozen then
        return
    end

    -- Update stun
    if self.stunTime > 0 then
        self.stunTime = self.stunTime - dt
        -- Apply knockback
        self.x = self.x + self.knockbackVel.x * dt
        self.y = self.y + self.knockbackVel.y * dt
        -- Slow down knockback
        self.knockbackVel.x = self.knockbackVel.x * 0.95
        self.knockbackVel.y = self.knockbackVel.y * 0.95
        return
    end
    
    -- Update time for animations
    self.time = self.time + dt
    
    -- Boss-specific behavior
    if self.type == "SlimeKing" then
        self:updateBoss(dt)
        return
    end
    
    -- Regular enemy behavior
    local dx = Game.wielder.x - self.x
    local dy = Game.wielder.y - self.y
    local dist = math.sqrt(dx^2 + dy^2)
    
    if dist > 0 then
        self.x = self.x + (dx/dist) * self.speed * dt
        self.y = self.y + (dy/dist) * self.speed * dt
    end
end

function Enemy:updateBoss(dt)
    -- Update attack timer
    if not self.currentAttack then
        self.attackTimer = self.attackTimer - dt
        if self.attackTimer <= 0 then
            self:startNewAttack()
        end
    else
        self:updateCurrentAttack(dt)
    end
end

function Enemy:startNewAttack()
    local attacks = Enemy.types["SlimeKing"].attackTypes
    self.currentAttack = attacks[love.math.random(#attacks)]
    self.attackPhase = 0
    self.attackTimer = Enemy.types["SlimeKing"].attackCooldown
    
    -- Set up attack-specific properties
    if self.currentAttack == "slam" then
        -- Jump high and slam down
        self.targetX = Game.wielder.x
        self.targetY = Game.wielder.y
        self.jumpHeight = 200
    elseif self.currentAttack == "split" then
        -- Create smaller slimes
        for i = 1, 4 do
            local angle = (i-1) * math.pi/2
            local spawnX = self.x + math.cos(angle) * 50
            local spawnY = self.y + math.sin(angle) * 50
            table.insert(Game.enemies, Enemy:create("Slime", spawnX, spawnY))
        end
        self.currentAttack = nil
    elseif self.currentAttack == "charge" then
        -- Charge toward player
        self.targetX = Game.wielder.x
        self.targetY = Game.wielder.y
        self.chargeSpeed = self.speed * 3
    end
end

function Enemy:updateCurrentAttack(dt)
    if self.currentAttack == "slam" then
        if self.attackPhase == 0 then
            -- Rising phase
            self.jumpHeight = self.jumpHeight - 400 * dt
            if self.jumpHeight <= 0 then
                self.attackPhase = 1
            end
        else
            -- Slam down phase
            local dx = self.targetX - self.x
            local dy = self.targetY - self.y
            local dist = math.sqrt(dx^2 + dy^2)
            if dist > 5 then
                self.x = self.x + (dx/dist) * 800 * dt
                self.y = self.y + (dy/dist) * 800 * dt
            else
                -- Create shockwave effect
                Game.particles:addShockwave(self.x, self.y)
                self.currentAttack = nil
            end
        end
    elseif self.currentAttack == "charge" then
        local dx = self.targetX - self.x
        local dy = self.targetY - self.y
        local dist = math.sqrt(dx^2 + dy^2)
        
        if dist > 5 then
            self.x = self.x + (dx/dist) * self.chargeSpeed * dt
            self.y = self.y + (dy/dist) * self.chargeSpeed * dt
        else
            self.currentAttack = nil
        end
    end
end

function Enemy:draw()
    local type = Enemy.types[self.type]
    
    if self.type == "SlimeKing" then
        -- Draw boss shadow
        love.graphics.setColor(0, 0, 0, 0.3)
        love.graphics.ellipse('fill', self.x, self.y + 10, self.size * 1.2, self.size * 0.3)
        
        -- Draw boss body with bounce animation
        local bounce = math.sin(self.time * type.bounceSpeed) * type.bounceHeight
        local jumpOffset = self.currentAttack == "slam" and self.jumpHeight or 0
        
        love.graphics.setColor(type.color[1], type.color[2], type.color[3], 1)
        love.graphics.circle('fill', self.x, self.y - jumpOffset + bounce, self.size)
        
        -- Draw crown
        love.graphics.setColor(1, 1, 0)
        love.graphics.polygon('fill',
            self.x - 20, self.y - jumpOffset + bounce - 30,
            self.x + 20, self.y - jumpOffset + bounce - 30,
            self.x + 25, self.y - jumpOffset + bounce - 20,
            self.x + 15, self.y - jumpOffset + bounce - 40,
            self.x, self.y - jumpOffset + bounce - 20,
            self.x - 15, self.y - jumpOffset + bounce - 40,
            self.x - 25, self.y - jumpOffset + bounce - 20
        )
        
        -- Draw face
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle('fill', self.x - 15, self.y - jumpOffset + bounce - 10, 5)
        love.graphics.circle('fill', self.x + 15, self.y - jumpOffset + bounce - 10, 5)
        love.graphics.arc('line', self.x, self.y - jumpOffset + bounce + 5, 20, 0, math.pi)
    else
        -- Regular enemy drawing code
        if self.type == "Slime" then
            local bounce = math.sin(self.time * type.bounceSpeed) * type.bounceHeight
            love.graphics.setColor(type.color[1], type.color[2], type.color[3], 1)
            love.graphics.circle('fill', self.x, self.y + bounce, self.size)
            -- Draw face
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.circle('fill', self.x - 5, self.y + bounce - 2, 2)
            love.graphics.circle('fill', self.x + 5, self.y + bounce - 2, 2)
        elseif self.type == "Bat" then
            local flutter = math.sin(self.time * type.flutterSpeed) * type.flutterHeight
            love.graphics.setColor(type.color[1], type.color[2], type.color[3], 1)
            love.graphics.circle('fill', self.x, self.y + flutter, self.size)
            -- Draw wings
            local wingSpread = math.abs(math.sin(self.time * type.flutterSpeed))
            love.graphics.polygon('fill', 
                self.x - 15 * wingSpread, self.y + flutter,
                self.x, self.y + flutter,
                self.x, self.y + flutter - 10)
            love.graphics.polygon('fill',
                self.x + 15 * wingSpread, self.y + flutter,
                self.x, self.y + flutter,
                self.x, self.y + flutter - 10)
        end
    end
    
    -- Draw health bar
    local healthPercent = self.health / Enemy.types[self.type].health
    love.graphics.setColor(1, 0, 0, 0.7)
    love.graphics.rectangle('fill', self.x - 15, self.y - 20, 30 * healthPercent, 3)
end

function Enemy:takeDamage(amount)
    self.health = self.health - amount
    
    -- Apply stun and knockback
    self.stunTime = 0.2
    local knockbackSpeed = amount * 10
    local dx = self.x - Game.boomerang.x
    local dy = self.y - Game.boomerang.y
    local dist = math.sqrt(dx^2 + dy^2)
    if dist > 0 then
        self.knockbackVel.x = (dx/dist) * knockbackSpeed
        self.knockbackVel.y = (dy/dist) * knockbackSpeed
    end
end

return Enemy 