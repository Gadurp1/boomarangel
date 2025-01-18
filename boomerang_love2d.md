# BOOMERANGELIC: LÖVE2D Implementation

## Core Files Structure
```lua
-- main.lua
function love.load()
    -- Initialize game state
    Game = {
        wielder = require('wielder'),
        boomerang = require('boomerang'),
        physics = require('physics'),
        camera = require('camera'),
        particles = require('particles')
    }
    
    -- Current wielder state
    currentWielder = Game.wielder.create("Panicked Rookie")
end

function love.update(dt)
    Game.boomerang:update(dt)
    Game.wielder:update(dt)
    Game.physics:update(dt)
    Game.particles:update(dt)
end

function love.draw()
    Game.camera:attach()
        Game.wielder:draw()
        Game.boomerang:draw()
        Game.particles:draw()
    Game.camera:detach()
end
```

## Boomerang Physics
```lua
-- boomerang.lua
local Boomerang = {
    x = 0,
    y = 0,
    rotation = 0,
    velocity = {x = 0, y = 0},
    state = "held", -- held/flying/returning
    trail = {}
}

function Boomerang:update(dt)
    if self.state == "flying" then
        -- Apply player control
        local control = self:getPlayerControl()
        self.velocity.x = self.velocity.x + control.x * dt
        self.velocity.y = self.velocity.y + control.y * dt
        
        -- Apply wielder's throw characteristics
        self:applyWielderEffect(dt)
        
        -- Update position
        self.x = self.x + self.velocity.x * dt
        self.y = self.y + self.velocity.y * dt
        
        -- Update trail
        self:updateTrail()
    end
end

function Boomerang:applyWielderEffect(dt)
    local wielder = Game.wielder
    
    if wielder.type == "Panicked Rookie" then
        -- Random trajectory changes
        if love.math.random() < 0.1 then
            self.velocity.x = self.velocity.x + love.math.random(-100, 100)
            self.velocity.y = self.velocity.y + love.math.random(-100, 100)
        end
    end
    
    -- Add more wielder-specific effects
end
```

## Wielder System
```lua
-- wielder.lua
local Wielder = {
    types = {
        ["Panicked Rookie"] = {
            throwForce = function() 
                return love.math.random(200, 400)
            end,
            throwAngle = function()
                return love.math.random(-math.pi/2, math.pi/2)
            end,
            confidence = 0,
            special = "Flail-and-Pray"
        },
        -- Add more wielder types
    }
}

function Wielder:throw()
    local type = self.types[self.currentType]
    local force = type.throwForce()
    local angle = type.throwAngle()
    
    Game.boomerang.velocity.x = math.cos(angle) * force
    Game.boomerang.velocity.y = math.sin(angle) * force
    Game.boomerang.state = "flying"
    
    -- Add throw effects
    Game.particles:addThrowEffect(self.currentType)
end
```

## Particle Systems
```lua
-- particles.lua
local Particles = {
    systems = {}
}

function Particles:addThrowEffect(wielderType)
    if wielderType == "Panicked Rookie" then
        local system = love.graphics.newParticleSystem(
            panicTexture, 100
        )
        system:setEmissionRate(20)
        system:setParticleLifetime(0.5, 1)
        system:setLinearAcceleration(-100, -100, 100, 100)
        table.insert(self.systems, system)
    end
end
```

## Physics Integration
```lua
-- physics.lua
local Physics = {
    world = love.physics.newWorld(0, 0, true)
}

function Physics:createBoomerang()
    local body = love.physics.newBody(
        self.world,
        Game.boomerang.x,
        Game.boomerang.y,
        "dynamic"
    )
    local shape = love.physics.newPolygonShape(
        -- Boomerang vertices
    )
    return love.physics.newFixture(body, shape)
end
```

## Camera System
```lua
-- camera.lua
local Camera = {
    x = 0,
    y = 0,
    scale = 1,
    rotation = 0
}

function Camera:follow(target, dt)
    local dx = target.x - self.x
    local dy = target.y - self.y
    self.x = self.x + dx * dt * 5
    self.y = self.y + dy * dt * 5
end
```

## State Management
```lua
-- gamestate.lua
local GameState = {
    current = "menu",
    states = {
        menu = require('states/menu'),
        playing = require('states/playing'),
        paused = require('states/paused')
    }
}

function GameState:switch(newState)
    self.current = newState
    self.states[newState]:enter()
end
```

## Implementation Notes

### Core Systems
1. Physics
   - Custom trajectory calculations
   - Wielder influence
   - Collision detection
   - Bounce physics

2. Visual Effects
   - Trail rendering
   - Particle systems
   - Screen shake
   - Impact effects

3. State Management
   - Wielder states
   - Boomerang states
   - Game flow
   - Scene transitions

### Performance Considerations
1. Particle Optimization
   - Pool particle systems
   - Limit active particles
   - Clean up inactive systems

2. Physics Optimization
   - Sleep distant objects
   - Simplified collision shapes
   - Batch physics updates

3. Memory Management
   - Resource pooling
   - Asset management
   - State cleanup 