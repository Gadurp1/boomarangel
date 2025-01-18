local Level = {
    currentLevel = 1,
    enemiesDefeated = 0,
    score = 0,
    highScores = {},
    
    -- Scoring system
    scoreMultiplier = 1,
    comboTimer = 0,
    maxComboTime = 3,
    stylePoints = 0,
    
    -- Level definitions
    levels = {
        -- The Dojo (Tutorial gone wrong)
        {
            name = "The Dojo",
            description = "A perfectly normal training room. What could go wrong?",
            layout = {
                walls = {
                    -- Training room boundaries
                    {x = 0, y = 0, width = 800, height = 20},     -- Top
                    {x = 0, y = 580, width = 800, height = 20},   -- Bottom
                    {x = 0, y = 0, width = 20, height = 600},     -- Left
                    {x = 780, y = 0, width = 20, height = 600},   -- Right
                    
                    -- Training dummies and obstacles
                    {x = 200, y = 200, width = 40, height = 40},
                    {x = 600, y = 200, width = 40, height = 40},
                    {x = 400, y = 400, width = 40, height = 40},
                },
                spawns = {
                    enemies = {
                        {x = 200, y = 100, type = "Slime"},
                        {x = 600, y = 100, type = "Slime"},
                        {x = 400, y = 500, type = "Bat"},
                    },
                    wielder = {x = 400, y = 300}
                }
            },
            requirements = {
                enemiesDefeated = 5,
                timeLimit = 60
            },
            modifiers = {
                enemySpeed = 1.0,
                enemyHealth = 1.0
            }
        },
        
        -- The Physics Lab
        {
            name = "The Physics Lab",
            description = "Hope you paid attention in physics class!",
            layout = {
                walls = {
                    -- Lab boundaries
                    {x = 0, y = 0, width = 1000, height = 20},
                    {x = 0, y = 780, width = 1000, height = 20},
                    {x = 0, y = 0, width = 20, height = 800},
                    {x = 980, y = 0, width = 20, height = 800},
                    
                    -- Puzzle elements
                    {x = 300, y = 200, width = 20, height = 400},  -- Vertical barrier
                    {x = 700, y = 200, width = 20, height = 400},  -- Vertical barrier
                    {x = 300, y = 200, width = 400, height = 20},  -- Horizontal barrier
                },
                spawns = {
                    enemies = {
                        {x = 200, y = 200, type = "Slime"},
                        {x = 800, y = 200, type = "Slime"},
                        {x = 500, y = 600, type = "Bat"},
                        {x = 200, y = 600, type = "Bat"},
                    },
                    wielder = {x = 500, y = 400}
                }
            },
            requirements = {
                enemiesDefeated = 8,
                timeLimit = 90
            },
            modifiers = {
                enemySpeed = 1.2,
                enemyHealth = 1.2,
                boomerangBounceMultiplier = 1.5
            }
        },

        -- The Time Trial
        {
            name = "The Time Trial",
            description = "The clock is broken, but so is physics!",
            layout = {
                walls = {
                    -- Arena boundaries
                    {x = 0, y = 0, width = 1200, height = 20},
                    {x = 0, y = 780, width = 1200, height = 20},
                    {x = 0, y = 0, width = 20, height = 800},
                    {x = 1180, y = 0, width = 20, height = 800},
                    
                    -- Time zones (visual barriers)
                    {x = 300, y = 100, width = 20, height = 600},
                    {x = 600, y = 0, width = 20, height = 500},
                    {x = 900, y = 200, width = 20, height = 600},
                },
                spawns = {
                    enemies = {
                        {x = 150, y = 200, type = "Slime"},
                        {x = 450, y = 400, type = "Bat"},
                        {x = 750, y = 300, type = "Slime"},
                        {x = 1050, y = 500, type = "Bat"},
                        {x = 150, y = 600, type = "Bat"},
                    },
                    wielder = {x = 100, y = 400}
                },
                timeZones = {
                    {x = 0, y = 0, width = 300, timeScale = 1.0},
                    {x = 300, y = 0, width = 300, timeScale = 0.5},
                    {x = 600, y = 0, width = 300, timeScale = 2.0},
                    {x = 900, y = 0, width = 300, timeScale = 0.75},
                }
            },
            requirements = {
                enemiesDefeated = 10,
                timeLimit = 120
            },
            modifiers = {
                enemySpeed = 1.5,
                enemyHealth = 1.3,
                boomerangBounceMultiplier = 2.0
            }
        },

        -- The Anti-Gravity Chamber
        {
            name = "The Anti-Gravity Chamber",
            description = "Up is down, down is up, and the walls are suggestions.",
            layout = {
                walls = {
                    -- Chamber boundaries
                    {x = 0, y = 0, width = 1000, height = 20},
                    {x = 0, y = 780, width = 1000, height = 20},
                    {x = 0, y = 0, width = 20, height = 800},
                    {x = 980, y = 0, width = 20, height = 800},
                    
                    -- Floating platforms
                    {x = 200, y = 200, width = 100, height = 20},
                    {x = 400, y = 400, width = 100, height = 20},
                    {x = 600, y = 300, width = 100, height = 20},
                    {x = 800, y = 500, width = 100, height = 20},
                },
                spawns = {
                    enemies = {
                        {x = 200, y = 100, type = "Slime"},
                        {x = 400, y = 300, type = "Bat"},
                        {x = 600, y = 200, type = "Slime"},
                        {x = 800, y = 400, type = "Bat"},
                        {x = 500, y = 600, type = "Slime"},
                    },
                    wielder = {x = 500, y = 300}
                },
                gravityZones = {
                    {x = 0, y = 0, width = 500, height = 400, direction = "up"},
                    {x = 500, y = 0, width = 500, height = 400, direction = "down"},
                    {x = 0, y = 400, width = 500, height = 400, direction = "right"},
                    {x = 500, y = 400, width = 500, height = 400, direction = "left"},
                }
            },
            requirements = {
                enemiesDefeated = 12,
                timeLimit = 150
            },
            modifiers = {
                enemySpeed = 1.8,
                enemyHealth = 1.5,
                boomerangBounceMultiplier = 2.5,
                gravityScale = 0.5
            }
        },

        -- The Boss Room
        {
            name = "The Boss Room",
            description = "The boss is definitely not on lunch break anymore.",
            layout = {
                walls = {
                    -- Arena boundaries
                    {x = 0, y = 0, width = 1200, height = 20},
                    {x = 0, y = 780, width = 1200, height = 20},
                    {x = 0, y = 0, width = 20, height = 800},
                    {x = 1180, y = 0, width = 20, height = 800},
                    
                    -- Arena pillars that can be destroyed
                    {x = 200, y = 200, width = 40, height = 400, destructible = true},
                    {x = 960, y = 200, width = 40, height = 400, destructible = true},
                },
                spawns = {
                    enemies = {
                        -- The Boss: Giant Slime King
                        {x = 600, y = 400, type = "SlimeKing"},
                        -- Minions
                        {x = 200, y = 200, type = "Slime"},
                        {x = 1000, y = 200, type = "Slime"},
                        {x = 200, y = 600, type = "Bat"},
                        {x = 1000, y = 600, type = "Bat"},
                    },
                    wielder = {x = 600, y = 700}
                },
                phases = {
                    {
                        healthThreshold = 0.75,
                        spawnMinions = true,
                        activateTimeZones = false
                    },
                    {
                        healthThreshold = 0.5,
                        spawnMinions = true,
                        activateTimeZones = true,
                        timeZones = {
                            {x = 0, y = 0, width = 600, timeScale = 0.5},
                            {x = 600, y = 0, width = 600, timeScale = 1.5}
                        }
                    },
                    {
                        healthThreshold = 0.25,
                        spawnMinions = true,
                        activateGravityZones = true,
                        gravityZones = {
                            {x = 0, y = 0, width = 1200, height = 400, direction = "down"},
                            {x = 0, y = 400, width = 1200, height = 400, direction = "up"}
                        }
                    }
                }
            },
            requirements = {
                bossDefeated = true,
                timeLimit = 180
            },
            modifiers = {
                enemySpeed = 2.0,
                enemyHealth = 2.0,
                boomerangBounceMultiplier = 3.0,
                gravityScale = 1.0
            }
        }
    },
    
    -- Survival mode specific properties
    survival = {
        wave = 1,
        spawnTimer = 0,
        shardTimer = 0,
        timeShards = {},
        baseEnemies = 5,
        enemiesPerWave = 2,  -- Additional enemies per wave
        shardSpawnTime = 5,  -- Seconds between shard spawns
        timeScale = 1,
        timeSlowDuration = 0,
        waveDelay = 3,       -- Seconds between waves
        waveDelayTimer = 0,
        isWaveComplete = false,
        modifiers = {
            enemySpeed = 1.0,
            enemyHealth = 1.0,
            scoreMultiplier = 1.0
        }
    },
    
    -- At the top of Level table definition, add default requirements
    defaultRequirements = {
        enemiesDefeated = 0,
        timeLimit = math.huge,
        bossDefeated = false
    },
    
    -- Add to Level table properties
    cutscenes = {
        quotes = {
            "The boomerang isn't running from enemies... time itself is running from you.",
            "In a world where everything comes back, you're the one thing that keeps going forward.",
            "They say time is a flat circle. They've clearly never seen it dodge a slime.",
            "ERROR: Time.exe has stopped working. Have you tried turning reality off and on again?",
            "Breaking news: Local weapon achieves sentience, questions why physics exists",
            "The slimes aren't chasing you. They're running from their own existential dread.",
            "Warning: Temporal paradox detected. Cause: Too much style.",
            "Plot twist: You were the time shard all along.",
            "The real treasure was the physics we broke along the way.",
            "Fun fact: This message is both here and not here until you observe it.",
        },
        animations = {
            timer = 0,
            duration = 3,
            alpha = 0
        }
    },
    
    -- Add to Level table properties
    weaponUpgrades = {
        {
            name = "Increased Range",
            description = "Your orbit radius increases",
            maxLevel = 5,
            effect = function(weapon, level)
                weapon.orbitDistance = weapon.orbitDistance + 20
            end
        },
        {
            name = "Attack Speed",
            description = "You spin faster around the wielder",
            maxLevel = 5,
            effect = function(weapon, level)
                weapon.rotationSpeed = weapon.rotationSpeed + 50
            end
        },
        {
            name = "Damage",
            description = "Your attacks deal more damage",
            maxLevel = 5,
            effect = function(weapon, level)
                weapon.damage = weapon.damage + 10
            end
        },
        {
            name = "Multi-Strike",
            description = "You can hit multiple enemies at once",
            maxLevel = 3,
            effect = function(weapon, level)
                weapon.piercing = weapon.piercing + 1
            end
        },
        {
            name = "Time Resonance",
            description = "Time shards have stronger effects",
            maxLevel = 3,
            effect = function(weapon, level)
                weapon.timeSlowPower = weapon.timeSlowPower + 0.1
            end
        }
    }
}

function Level:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Level:load(levelNum)
    self.currentLevel = levelNum
    local level = self.levels[levelNum]
    if not level then return end
    
    -- Reset level state
    self.enemiesDefeated = 0
    self.timeRemaining = self:getRequirements().timeLimit
    
    -- Clear existing enemies
    Game.enemies = {}
    
    -- Position wielder
    if level.layout and level.layout.spawns then
        Game.wielder.x = level.layout.spawns.wielder.x
        Game.wielder.y = level.layout.spawns.wielder.y
    end
    
    -- Create walls
    if level.layout then
        self.walls = level.layout.walls
    end
    
    -- Apply level modifiers
    if level.modifiers then
        self:applyModifiers(level.modifiers)
    end
    
    -- Spawn initial enemies
    if level.layout and level.layout.spawns and level.layout.spawns.enemies then
        self:spawnEnemies()
    end
end

function Level:update(dt)
    if self.mode == "survival" then
        self:updateSurvival(dt)
        return
    end

    -- Only proceed with level updates if we have a valid level
    if not self.currentLevel or type(self.currentLevel) ~= "number" then
        return
    end

    local level = self.levels[self.currentLevel]
    if not level then
        return
    end

    self.timeRemaining = self.timeRemaining - dt
    
    -- Update score and combo
    self:updateScore(dt)
    
    -- Update boss phases if applicable
    if level.layout and level.layout.phases then
        self:updateBossPhases()
    end
    
    -- Update time zones if they exist
    if level.layout and level.layout.timeZones then
        for _, zone in ipairs(level.layout.timeZones) do
            if self:isInZone(Game.boomerang.x, Game.boomerang.y, zone) then
                dt = dt * zone.timeScale
                break
            end
        end
    end
    
    -- Update gravity zones if they exist
    if level.layout and level.layout.gravityZones then
        for _, zone in ipairs(level.layout.gravityZones) do
            if self:isInZone(Game.boomerang.x, Game.boomerang.y, zone) then
                self:applyGravityEffect(zone.direction, dt)
                break
            end
        end
    end
    
    -- Check for level failure
    if self.timeRemaining <= 0 then
        self:failLevel()
    end
end

function Level:spawnEnemies()
    local level = self.levels[self.currentLevel]
    for _, spawn in ipairs(level.layout.spawns.enemies) do
        table.insert(Game.enemies, Game.Enemy:create(spawn.type, spawn.x, spawn.y))
    end
end

function Level:checkWin()
    local requirements = self:getRequirements()
    
    if self.mode == "survival" then
        return false
    end
    
    if requirements.bossDefeated then
        local boss = self:findBoss()
        return boss == nil or boss.health <= 0
    end
    
    return self.enemiesDefeated >= requirements.enemiesDefeated
end

function Level:failLevel()
    -- Reset level
    self:load(self.currentLevel)
    -- TODO: Add failure effects/UI
end

function Level:applyModifiers(modifiers)
    -- Apply enemy modifiers
    for _, enemy in ipairs(Game.enemies) do
        enemy.speed = enemy.speed * modifiers.enemySpeed
        enemy.health = enemy.health * modifiers.enemyHealth
    end
    
    -- Apply boomerang modifiers
    if modifiers.boomerangBounceMultiplier then
        Game.boomerang.bounceMultiplier = modifiers.boomerangBounceMultiplier
    end
end

function Level:checkCollision(x, y, radius)
    for _, wall in ipairs(self.walls) do
        -- Check if point is inside wall (plus radius)
        if x + radius > wall.x and x - radius < wall.x + wall.width and
           y + radius > wall.y and y - radius < wall.y + wall.height then
            -- Calculate closest point on wall
            local closestX = math.max(wall.x, math.min(x, wall.x + wall.width))
            local closestY = math.max(wall.y, math.min(y, wall.y + wall.height))
            return true, closestX, closestY
        end
    end
    return false
end

function Level:isInZone(x, y, zone)
    return x >= zone.x and x <= zone.x + zone.width and
           y >= (zone.y or 0) and y <= (zone.y or 0) + (zone.height or love.graphics.getHeight())
end

function Level:applyGravityEffect(direction, dt)
    local force = 500 * dt
    if direction == "up" then
        Game.boomerang.velocity.y = Game.boomerang.velocity.y - force
    elseif direction == "down" then
        Game.boomerang.velocity.y = Game.boomerang.velocity.y + force
    elseif direction == "left" then
        Game.boomerang.velocity.x = Game.boomerang.velocity.x - force
    elseif direction == "right" then
        Game.boomerang.velocity.x = Game.boomerang.velocity.x + force
    end
end

function Level:addScore(amount, styleBonus)
    self.score = self.score + (amount * self.scoreMultiplier)
    self.stylePoints = self.stylePoints + (styleBonus or 0)
    
    -- Update combo
    self.comboTimer = self.maxComboTime
    self.scoreMultiplier = self.scoreMultiplier + 0.1
end

function Level:updateScore(dt)
    -- Update combo timer
    if self.comboTimer > 0 then
        self.comboTimer = self.comboTimer - dt
        if self.comboTimer <= 0 then
            self.scoreMultiplier = 1
        end
    end
end

function Level:getRating()
    local ratings = {
        {threshold = 10000, text = "Physics Left The Chat", grade = "S"},
        {threshold = 8000, text = "Task Failed Successfully", grade = "A"},
        {threshold = 6000, text = "Technically Correct", grade = "B"},
        {threshold = 4000, text = "Task Successfully Failed", grade = "C"},
        {threshold = 2000, text = "At Least You Tried", grade = "D"},
        {threshold = 0, text = "Did You Even Throw?", grade = "F"}
    }
    
    for _, rating in ipairs(ratings) do
        if self.score >= rating.threshold then
            return rating.text, rating.grade
        end
    end
end

function Level:updateBossPhases()
    local level = self.levels[self.currentLevel]
    local boss = self:findBoss()
    
    if boss then
        local healthPercent = boss.health / boss.maxHealth
        
        -- Check each phase
        for _, phase in ipairs(level.layout.phases) do
            if healthPercent <= phase.healthThreshold and not phase.activated then
                self:activatePhase(phase)
                phase.activated = true
            end
        end
    end
end

function Level:findBoss()
    for _, enemy in ipairs(Game.enemies) do
        if enemy.type == "SlimeKing" then
            return enemy
        end
    end
    return nil
end

function Level:activatePhase(phase)
    -- Spawn additional minions
    if phase.spawnMinions then
        local minionTypes = {"Slime", "Bat"}
        for i = 1, 3 do
            local spawnX = love.math.random(100, 1100)
            local spawnY = love.math.random(100, 700)
            local minionType = minionTypes[love.math.random(#minionTypes)]
            table.insert(Game.enemies, Game.Enemy:create(minionType, spawnX, spawnY))
        end
    end
    
    -- Activate time zones
    if phase.activateTimeZones then
        self.currentTimeZones = phase.timeZones
    end
    
    -- Activate gravity zones
    if phase.activateGravityZones then
        self.currentGravityZones = phase.gravityZones
    end
end

function Level:draw()
    -- Draw walls
    love.graphics.setColor(0.5, 0.5, 0.5)
    for _, wall in ipairs(self.walls) do
        love.graphics.rectangle('fill', wall.x, wall.y, wall.width, wall.height)
    end
    
    if self.mode == "survival" then
        -- Draw survival mode UI
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("SURVIVAL MODE", 10, 10)
        love.graphics.print("Wave: " .. self.survival.wave, 10, 30)
        love.graphics.print("Enemies: " .. #Game.enemies, 10, 50)
        love.graphics.print("Score: " .. math.floor(self.score), 10, 70)
        
        -- Draw wave transition
        if self.survival.isWaveComplete then
            love.graphics.setColor(1, 1, 0)
            love.graphics.printf("Wave " .. self.survival.wave .. " Complete!", 
                0, love.graphics.getHeight()/2 - 40, love.graphics.getWidth(), "center")
            love.graphics.printf("Next wave in: " .. math.ceil(self.survival.waveDelayTimer), 
                0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
        end
        
        -- Draw time shards
        love.graphics.setColor(0, 1, 1, 0.8)
        for _, shard in ipairs(self.survival.timeShards) do
            love.graphics.circle('fill', shard.x, shard.y, shard.radius)
        end
        
        -- Draw time slow effect indicator
        if self.survival.timeScale < 1 then
            love.graphics.setColor(0, 1, 1, 0.3)
            love.graphics.printf("TIME SLOW", 0, 100, love.graphics.getWidth(), "center")
        end
        
        -- Draw XP bar
        love.graphics.setColor(0.2, 0.2, 0.8)
        love.graphics.rectangle('fill', 10, love.graphics.getHeight() - 30, 
            (self.survival.xp / self.survival.xpToNext) * 200, 20)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Level " .. self.survival.level, 220, love.graphics.getHeight() - 30)
        
        -- Draw upgrade menu if active
        if self.survival.showingUpgrades then
            -- Darken background
            love.graphics.setColor(0, 0, 0, 0.8)
            love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            
            -- Draw upgrade options
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf("CHOOSE YOUR UPGRADE", 0, 200, love.graphics.getWidth(), "center")
            
            for i, upgradeIdx in ipairs(self.survival.upgradeChoices) do
                local upgrade = self.weaponUpgrades[upgradeIdx]
                local currentLevel = self.survival.upgradeLevels[upgradeIdx] or 0
                local y = 300 + (i-1) * 100
                
                love.graphics.rectangle('line', love.graphics.getWidth()/2 - 150, y, 300, 80)
                love.graphics.printf(upgrade.name .. " (Level " .. currentLevel .. "/" .. upgrade.maxLevel .. ")",
                    love.graphics.getWidth()/2 - 140, y + 10, 280, "left")
                love.graphics.printf(upgrade.description,
                    love.graphics.getWidth()/2 - 140, y + 40, 280, "left")
            end
        end
        
        return
    end
    
    -- Original level drawing code
    if type(self.currentLevel) == "number" then  -- Only if it's a regular level
        local level = self.levels[self.currentLevel]
        if level then
            -- Draw level info
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(string.format("Level: %s", level.name), 10, 30)
            love.graphics.print(string.format("Time: %.1f", self.timeRemaining), 10, 50)
            
            -- Draw boss health if applicable
            if level.layout and level.layout.phases then
                local boss = self:findBoss()
                if boss then
                    local healthPercent = boss.health / boss.maxHealth
                    love.graphics.setColor(1, 0, 0)
                    love.graphics.rectangle('fill', 300, 20, 600 * healthPercent, 20)
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.print("SLIME KING", 550, 20)
                end
            end
            
            -- Draw special zones
            if level.layout then
                if level.layout.timeZones then
                    for _, zone in ipairs(level.layout.timeZones) do
                        love.graphics.setColor(0.2, 0.5, 0.8, 0.2)
                        love.graphics.rectangle('fill', zone.x, 0, zone.width, love.graphics.getHeight())
                    end
                end
                
                if level.layout.gravityZones then
                    for _, zone in ipairs(level.layout.gravityZones) do
                        love.graphics.setColor(0.8, 0.2, 0.5, 0.2)
                        love.graphics.rectangle('fill', zone.x, zone.y, zone.width, zone.height)
                        self:drawGravityArrow(zone)
                    end
                end
            end
        end
    end
    
    -- Draw score and combo (for both modes)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("Score: %d", self.score), 10, 90)
    if self.scoreMultiplier > 1 then
        love.graphics.print(string.format("Combo: x%.1f", self.scoreMultiplier), 10, 110)
    end
    if self.stylePoints > 0 then
        love.graphics.print(string.format("Style: %d", self.stylePoints), 10, 130)
    end
    
    -- Draw cutscene if active
    if self.cutscenes.animations.timer > 0 then
        -- Draw dramatic background
        love.graphics.setColor(0, 0, 0, self.cutscenes.animations.alpha * 0.7)
        love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        
        -- Draw quote with glitch effect
        love.graphics.setColor(1, 1, 1, self.cutscenes.animations.alpha)
        local quote = self.currentQuote
        
        -- Add glitch effect
        if self.cutscenes.animations.timer % 0.2 < 0.1 then
            quote = quote:gsub(".", function(c) 
                return love.math.random() < 0.1 and string.char(love.math.random(33, 126)) or c 
            end)
        end
        
        -- Draw the quote with a dramatic font
        love.graphics.setFont(love.graphics.newFont(24))
        love.graphics.printf(quote, 
            100, love.graphics.getHeight()/2 - 50,
            love.graphics.getWidth() - 200, "center")
            
        -- Draw wave number with matrix-style effect
        love.graphics.setColor(0, 1, 0, self.cutscenes.animations.alpha * 0.7)
        local waveText = "WAVE " .. self.survival.wave
        for i = 1, #waveText do
            local char = waveText:sub(i,i)
            if love.math.random() < 0.1 then
                char = string.char(love.math.random(33, 126))
            end
            love.graphics.print(char, 
                love.graphics.getWidth()/2 - 100 + i * 20,
                love.graphics.getHeight()/2 + 50 + math.sin(love.timer.getTime() * 5 + i) * 5)
        end
    end
end

function Level:drawGravityArrow(zone)
    local centerX = zone.x + zone.width/2
    local centerY = zone.y + zone.height/2
    local arrowSize = 20
    
    love.graphics.setColor(1, 1, 1, 0.5)
    if zone.direction == "up" then
        love.graphics.polygon('fill', 
            centerX, centerY - arrowSize,
            centerX - arrowSize/2, centerY + arrowSize/2,
            centerX + arrowSize/2, centerY + arrowSize/2)
    elseif zone.direction == "down" then
        love.graphics.polygon('fill',
            centerX, centerY + arrowSize,
            centerX - arrowSize/2, centerY - arrowSize/2,
            centerX + arrowSize/2, centerY - arrowSize/2)
    elseif zone.direction == "left" then
        love.graphics.polygon('fill',
            centerX - arrowSize, centerY,
            centerX + arrowSize/2, centerY - arrowSize/2,
            centerX + arrowSize/2, centerY + arrowSize/2)
    elseif zone.direction == "right" then
        love.graphics.polygon('fill',
            centerX + arrowSize, centerY,
            centerX - arrowSize/2, centerY - arrowSize/2,
            centerX - arrowSize/2, centerY + arrowSize/2)
    end
end

function Level:showAppleIIBoot()
    local bootSequence = {
        {text = "APPLE ][", delay = 1.0},
        {text = "BOOMERANGELIC OS V1.0", delay = 0.8},
        {text = "COPYRIGHT (C) 1977", delay = 0.8},
        {text = "LOADING TEMPORAL MATRIX", delay = 0.5},
        {text = "INITIALIZING TIME SHARDS", delay = 0.5},
        {text = "CALIBRATING REALITY ENGINES", delay = 0.5},
        {text = "]", delay = 0.2, cursor = true},
        {text = "]LOAD SURVIVAL.SYSTEM", delay = 0.8},
        {text = "SEARCHING FOR SURVIVAL.SYSTEM", delay = 0.5},
        {text = "LOADING...", delay = 0.3},
        {text = "PRESS ANY KEY TO DESTABILIZE TIME", delay = 1.0}
    }
    
    -- Add to Level table properties
    self.bootScreen = {
        active = true,
        currentLine = 1,
        timer = 0,
        lines = {},
        cursorBlink = 0,
        showCursor = true
    }
    
    -- Start the boot sequence
    self.bootScreen.sequence = bootSequence
    
    -- Override the draw function temporarily
    local originalDraw = self.draw
    self.draw = function(self)
        if self.bootScreen.active then
            -- Clear screen with classic green phosphor look
            love.graphics.setColor(0, 0.1, 0)
            love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
            
            -- Set up retro font
            love.graphics.setColor(0, 1, 0)
            love.graphics.setFont(love.graphics.newFont(20))
            
            -- Draw existing lines
            for i, line in ipairs(self.bootScreen.lines) do
                love.graphics.print(line.text, 40, 40 + i * 30)
            end
            
            -- Draw blinking cursor
            if self.bootScreen.showCursor then
                local cursorY = 40 + (#self.bootScreen.lines + 1) * 30
                love.graphics.print("_", 40, cursorY)
            end
        else
            originalDraw(self)
        end
    end
    
    -- Override the update function temporarily
    local originalUpdate = self.update
    self.update = function(self, dt)
        if self.bootScreen.active then
            -- Update cursor blink
            self.bootScreen.cursorBlink = self.bootScreen.cursorBlink + dt
            if self.bootScreen.cursorBlink >= 0.5 then
                self.bootScreen.cursorBlink = 0
                self.bootScreen.showCursor = not self.bootScreen.showCursor
            end
            
            -- Update boot sequence
            self.bootScreen.timer = self.bootScreen.timer + dt
            local currentSeq = self.bootScreen.sequence[self.bootScreen.currentLine]
            
            if currentSeq and self.bootScreen.timer >= currentSeq.delay then
                table.insert(self.bootScreen.lines, currentSeq)
                self.bootScreen.currentLine = self.bootScreen.currentLine + 1
                self.bootScreen.timer = 0
                
                -- Play retro beep sound
                -- TODO: Add beep sound here
                
                -- Check if boot sequence is complete
                if self.bootScreen.currentLine > #self.bootScreen.sequence then
                    -- Wait for key press
                    love.keypressed = function(key)
                        self.bootScreen.active = false
                        self.draw = originalDraw
                        self.update = originalUpdate
                        love.keypressed = nil
                    end
                end
            end
        else
            originalUpdate(self, dt)
        end
    end
end

-- Modify loadSurvival to show boot screen first
local originalLoadSurvival = Level.loadSurvival
function Level:loadSurvival()
    -- Reset game state
    self.mode = "survival"
    self.currentLevel = nil
    self.enemiesDefeated = 0
    self.score = 0
    self.scoreMultiplier = 1
    self.comboTimer = 0
    self.stylePoints = 0
    
    -- Initialize survival state
    self.survival = {
        wave = 1,
        spawnTimer = 0,
        shardTimer = 0,
        timeShards = {},  -- Initialize empty table
        baseEnemies = 5,
        enemiesPerWave = 2,
        shardSpawnTime = 5,
        timeScale = 1,
        timeSlowDuration = 0,
        waveDelay = 3,
        waveDelayTimer = 0,
        isWaveComplete = false,
        modifiers = {
            enemySpeed = 1.0,
            enemyHealth = 1.0,
            scoreMultiplier = 1.0
        },
        xp = 0,
        level = 1,
        xpToNext = 100,
        availableUpgrades = 0,
        upgradeLevels = {},
        showingUpgrades = false,
        upgradeChoices = {}
    }
    
    -- Initialize weapon stats
    Game.weapon = {
        orbitDistance = 50,
        rotationSpeed = 200,
        damage = 20,
        piercing = 1,
        timeSlowPower = 1.0,
        angle = 0,
        autoAttack = true
    }
    
    -- Clear and setup arena
    self.walls = {}
    Game.enemies = {}
    
    -- Create arena walls
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    table.insert(self.walls, {x = 0, y = 0, width = width, height = 20})           -- Top
    table.insert(self.walls, {x = 0, y = height - 20, width = width, height = 20}) -- Bottom
    table.insert(self.walls, {x = 0, y = 0, width = 20, height = height})          -- Left
    table.insert(self.walls, {x = width - 20, y = 0, width = 20, height = height}) -- Right
    
    -- Position wielder in center
    Game.wielder.x = width / 2
    Game.wielder.y = height / 2
    
    -- Remove boomerang cooldown
    if Game.boomerang then
        Game.boomerang.cooldown = 0
        Game.boomerang.maxCooldown = 0
    end
    
    -- Start first wave
    self:startSurvivalWave()
end

function Level:startSurvivalWave()
    local s = self.survival
    local numEnemies = s.baseEnemies + ((s.wave - 1) * s.enemiesPerWave)
    
    -- Increase difficulty every 5 waves
    if s.wave % 5 == 0 then
        s.modifiers.enemySpeed = s.modifiers.enemySpeed + 0.1
        s.modifiers.enemyHealth = s.modifiers.enemyHealth + 0.2
        s.modifiers.scoreMultiplier = s.modifiers.scoreMultiplier + 0.5
    end
    
    -- Spawn enemies
    for i = 1, numEnemies do
        local angle = love.math.random() * math.pi * 2
        local distance = love.math.random(300, 500)
        local spawnX = Game.wielder.x + math.cos(angle) * distance
        local spawnY = Game.wielder.y + math.sin(angle) * distance
        
        -- Mix of enemy types
        local enemyType = "Slime"
        local rand = love.math.random(100)
        if rand > 70 then
            enemyType = "Bat"
        elseif rand > 90 and s.wave > 3 then
            enemyType = "SlimeKing"  -- Rare boss spawn in later waves
        end
        
        local enemy = Game.Enemy:create(enemyType, spawnX, spawnY)
        -- Apply wave modifiers
        enemy.speed = enemy.speed * s.modifiers.enemySpeed
        enemy.health = enemy.health * s.modifiers.enemyHealth
        table.insert(Game.enemies, enemy)
    end
    
    s.isWaveComplete = false
end

function Level:updateSurvival(dt)
    local s = self.survival
    
    -- Update time slow effect
    if s.timeSlowDuration > 0 then
        s.timeSlowDuration = s.timeSlowDuration - dt
        if s.timeSlowDuration <= 0 then
            s.timeScale = 1
        end
    end
    
    -- Check wave completion
    if #Game.enemies == 0 and not s.isWaveComplete then
        s.isWaveComplete = true
        s.waveDelayTimer = s.waveDelay
        s.wave = s.wave + 1
        
        -- Trigger absurd cutscene
        self:triggerCutscene()
        
        -- Award wave completion bonus
        self.score = self.score + (1000 * s.wave * s.modifiers.scoreMultiplier)
    end
    
    -- Update cutscene animation
    if self.cutscenes.animations.timer > 0 then
        self.cutscenes.animations.timer = self.cutscenes.animations.timer - dt
        -- Fade in and out
        if self.cutscenes.animations.timer > self.cutscenes.animations.duration/2 then
            self.cutscenes.animations.alpha = 1 - (self.cutscenes.animations.timer - self.cutscenes.animations.duration/2)/(self.cutscenes.animations.duration/2)
        else
            self.cutscenes.animations.alpha = self.cutscenes.animations.timer/(self.cutscenes.animations.duration/2)
        end
    end
    
    -- Handle wave delay
    if s.isWaveComplete then
        s.waveDelayTimer = s.waveDelayTimer - dt
        if s.waveDelayTimer <= 0 then
            self:startSurvivalWave()
        end
    end
    
    -- Spawn time shards
    s.shardTimer = s.shardTimer + dt
    if s.shardTimer >= s.shardSpawnTime then
        self:spawnSurvivalShard()
        s.shardTimer = 0
    end
    
    -- Update shards
    for i = #s.timeShards, 1, -1 do
        local shard = s.timeShards[i]
        if self:checkShardCollection(shard) then
            table.remove(s.timeShards, i)
            -- Apply time slow effect
            s.timeScale = 0.5
            s.timeSlowDuration = 3
            -- Award points
            self.score = self.score + (500 * s.modifiers.scoreMultiplier)
        end
    end
    
    -- Update score multiplier
    self:updateScore(dt * s.timeScale)
end

function Level:spawnSurvivalShard()
    local angle = love.math.random() * math.pi * 2
    local distance = love.math.random(100, 300)
    local spawnX = Game.wielder.x + math.cos(angle) * distance
    local spawnY = Game.wielder.y + math.sin(angle) * distance
    
    table.insert(self.survival.timeShards, {
        x = spawnX,
        y = spawnY,
        radius = 15
    })
end

function Level:checkShardCollection(shard)
    local dx = Game.wielder.x - shard.x
    local dy = Game.wielder.y - shard.y
    return (dx * dx + dy * dy) <= (shard.radius + 20) * (shard.radius + 20)
end

function Level:getRequirements()
    if self.mode == "survival" then
        return self.defaultRequirements
    end
    
    if type(self.currentLevel) == "number" and self.levels[self.currentLevel] then
        return self.levels[self.currentLevel].requirements
    end
    
    return self.defaultRequirements
end

function Level:updateWielderAI(dt)
    if not Game.wielder then return end
    
    local nearestEnemy = nil
    local nearestEnemyDist = math.huge
    local nearestShard = nil
    local nearestShardDist = math.huge
    local dangerZone = 150  -- Distance to start running from enemies
    local panicZone = 80    -- Distance to panic and run faster
    
    -- Find nearest enemy and shard
    for _, enemy in ipairs(Game.enemies) do
        local dx = enemy.x - Game.wielder.x
        local dy = enemy.y - Game.wielder.y
        local dist = math.sqrt(dx * dx + dy * dy)
        
        if dist < nearestEnemyDist then
            nearestEnemy = enemy
            nearestEnemyDist = dist
        end
    end
    
    for _, shard in ipairs(self.survival.timeShards) do
        local dx = shard.x - Game.wielder.x
        local dy = shard.y - Game.wielder.y
        local dist = math.sqrt(dx * dx + dy * dy)
        
        if dist < nearestShardDist then
            nearestShard = shard
            nearestShardDist = dist
        end
    end
    
    -- Calculate movement
    local moveX, moveY = 0, 0
    local speed = 200  -- Base speed
    
    -- Handle enemy avoidance
    if nearestEnemy then
        if nearestEnemyDist < panicZone then
            -- Panic mode - run away faster
            speed = 300
            local dx = Game.wielder.x - nearestEnemy.x
            local dy = Game.wielder.y - nearestEnemy.y
            local len = math.sqrt(dx * dx + dy * dy)
            moveX = moveX + (dx / len) * 2  -- Stronger avoidance in panic
            moveY = moveY + (dy / len) * 2
        elseif nearestEnemyDist < dangerZone then
            -- Normal avoidance
            local dx = Game.wielder.x - nearestEnemy.x
            local dy = Game.wielder.y - nearestEnemy.y
            local len = math.sqrt(dx * dx + dy * dy)
            moveX = moveX + (dx / len)
            moveY = moveY + (dy / len)
        end
    end
    
    -- Move towards shards if safe
    if nearestShard and (not nearestEnemy or nearestEnemyDist > dangerZone) then
        local dx = nearestShard.x - Game.wielder.x
        local dy = nearestShard.y - Game.wielder.y
        local len = math.sqrt(dx * dx + dy * dy)
        moveX = moveX + (dx / len) * 0.5  -- Weaker attraction to shards
        moveY = moveY + (dy / len) * 0.5
    end
    
    -- Normalize movement vector
    if moveX ~= 0 or moveY ~= 0 then
        local len = math.sqrt(moveX * moveX + moveY * moveY)
        moveX = moveX / len
        moveY = moveY / len
        
        -- Apply movement
        local newX = Game.wielder.x + moveX * speed * dt
        local newY = Game.wielder.y + moveY * speed * dt
        
        -- Check wall collisions
        if not self:checkCollision(newX, newY, 20) then
            Game.wielder.x = newX
            Game.wielder.y = newY
        end
    end
end

function Level:triggerCutscene()
    -- Pick random quote
    local quoteIndex = love.math.random(#self.cutscenes.quotes)
    self.currentQuote = self.cutscenes.quotes[quoteIndex]
    
    -- Reset animation timer
    self.cutscenes.animations.timer = self.cutscenes.animations.duration
    self.cutscenes.animations.alpha = 0
    
    -- Special effects based on wave number
    if self.survival.wave % 5 == 0 then
        -- Every 5th wave gets extra dramatic
        self.currentQuote = string.upper(self.currentQuote)
    end
end

function Level:updateWeapon(dt)
    if not Game.weapon or not Game.wielder then return end
    
    -- Auto-rotate around wielder
    Game.weapon.angle = Game.weapon.angle + Game.weapon.rotationSpeed * dt
    
    -- Update position
    local angle = math.rad(Game.weapon.angle)
    Game.weapon.x = Game.wielder.x + math.cos(angle) * Game.weapon.orbitDistance
    Game.weapon.y = Game.wielder.y + math.sin(angle) * Game.weapon.orbitDistance
    
    -- Auto-attack nearby enemies
    if Game.weapon.autoAttack then
        local hitEnemies = 0
        for _, enemy in ipairs(Game.enemies) do
            if hitEnemies >= Game.weapon.piercing then break end
            
            local dx = enemy.x - Game.weapon.x
            local dy = enemy.y - Game.weapon.y
            local dist = math.sqrt(dx * dx + dy * dy)
            
            if dist < 30 then  -- Weapon hit radius
                enemy.health = enemy.health - Game.weapon.damage
                hitEnemies = hitEnemies + 1
                
                -- Visual effect for hit
                -- TODO: Add particle effect
            end
        end
    end
end

function Level:addXP(amount)
    self.survival.xp = self.survival.xp + amount
    while self.survival.xp >= self.survival.xpToNext do
        self.survival.xp = self.survival.xp - self.survival.xpToNext
        self.survival.level = self.survival.level + 1
        self.survival.xpToNext = self.survival.xpToNext * 1.2
        self.survival.availableUpgrades = self.survival.availableUpgrades + 1
        self:showUpgradeOptions()
    end
end

function Level:showUpgradeOptions()
    if self.survival.availableUpgrades <= 0 then return end
    
    self.survival.showingUpgrades = true
    self.survival.upgradeChoices = {}
    
    -- Pick 3 random upgrades
    local available = {}
    for i, upgrade in ipairs(self.weaponUpgrades) do
        local currentLevel = self.survival.upgradeLevels[i] or 0
        if currentLevel < upgrade.maxLevel then
            table.insert(available, i)
        end
    end
    
    -- Shuffle and pick 3
    for i = 1, math.min(3, #available) do
        local idx = love.math.random(#available)
        table.insert(self.survival.upgradeChoices, available[idx])
        table.remove(available, idx)
    end
end

function Level:selectUpgrade(index)
    if not self.survival.showingUpgrades then return end
    
    local upgradeIndex = self.survival.upgradeChoices[index]
    if not upgradeIndex then return end
    
    local upgrade = self.weaponUpgrades[upgradeIndex]
    self.survival.upgradeLevels[upgradeIndex] = (self.survival.upgradeLevels[upgradeIndex] or 0) + 1
    
    -- Apply upgrade effect
    upgrade.effect(Game.weapon, self.survival.upgradeLevels[upgradeIndex])
    
    self.survival.availableUpgrades = self.survival.availableUpgrades - 1
    self.survival.showingUpgrades = false
end

return Level 