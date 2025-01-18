function love.load()
    -- Initialize game state
    Game = {
        wielder = require('./wielder'),
        boomerang = require('./boomerang'),
        camera = require('./camera'),
        particles = require('./particles'),
        Enemy = require('./enemy'),
        level = require('./level'),
        menu = require('./menu')
    }
    
    -- Initialize game systems
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setMode(800, 600)
    
    -- Initialize objects
    Game.wielder = Game.wielder:new()
    Game.boomerang = Game.boomerang:new()
    Game.camera = Game.camera:new()
    Game.particles = Game.particles:new()
    Game.level = Game.level:new()
    Game.menu = Game.menu:new()
    
    -- Available wielder types
    Game.availableWielders = {"Panicked Rookie", "Overconfident Barbarian", "Physics Expert"}
    Game.currentWielderIndex = 1
    
    -- Set initial wielder
    Game.wielder = Game.wielder:create(Game.availableWielders[Game.currentWielderIndex])
    
    -- Input state
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        if Game.menu.state == "game" then
            Game.menu.state = "pause"
            Game.menu.selectedOption = 1
        elseif Game.menu.state == "controls" then
            Game.menu.state = "main"
            Game.menu.selectedOption = 1
        elseif Game.menu.state == "pause" then
            Game.menu.state = "game"
        end
    elseif Game.menu.state == "game" then
        if key == 'tab' and Game.boomerang.state == "held" then
            -- Switch wielder
            Game.currentWielderIndex = Game.currentWielderIndex % #Game.availableWielders + 1
            Game.wielder = Game.wielder:create(Game.availableWielders[Game.currentWielderIndex])
            Game.boomerang.x = Game.wielder.x
            Game.boomerang.y = Game.wielder.y
        end
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    if Game.menu.state == "game" then
        -- Update game objects
        Game.boomerang:update(dt)
        Game.wielder:update(dt)
        Game.particles:update(dt)
        Game.camera:update(dt)
        
        -- Check wall collisions for boomerang
        if Game.boomerang.state == "flying" or Game.boomerang.state == "returning" then
            local hit, hitX, hitY = Game.level:checkCollision(Game.boomerang.x, Game.boomerang.y, Game.boomerang.size)
            if hit then
                -- Bounce off walls
                local dx = Game.boomerang.x - hitX
                local dy = Game.boomerang.y - hitY
                local dist = math.sqrt(dx^2 + dy^2)
                if dist > 0 then
                    Game.boomerang.velocity.x = dx/dist * math.abs(Game.boomerang.velocity.x)
                    Game.boomerang.velocity.y = dy/dist * math.abs(Game.boomerang.velocity.y)
                end
                -- Add hit effect
                Game.particles:addHitEffect(hitX, hitY, math.sqrt(
                    Game.boomerang.velocity.x^2 + Game.boomerang.velocity.y^2))
            end
        end
        
        -- Update enemies
        for i = #Game.enemies, 1, -1 do
            local enemy = Game.enemies[i]
            enemy:update(dt)
            
            -- Remove dead enemies
            if enemy.health <= 0 then
                table.remove(Game.enemies, i)
                Game.particles:addDeathEffect(enemy.x, enemy.y, enemy.type)
                Game.level.enemiesDefeated = (Game.level.enemiesDefeated or 0) + 1
            end
        end
        
        -- Check level completion
        if Game.level:checkWin() then
            if Game.level.currentLevel < #Game.level.levels then
                Game.level:load(Game.level.currentLevel + 1)
            else
                Game.menu.state = "main"
                Game.menu.selectedOption = 1
            end
        end
        
        -- Spawn enemies if needed
        if #Game.enemies == 0 then
            Game.level:spawnEnemies()
        end
    else
        -- Update menu
        Game.menu:update(dt)
    end
    
    -- Reset input state
    love.keyboard.keysPressed = {}
end

function love.draw()
    if Game.menu.state == "game" or Game.menu.state == "pause" then
        -- Draw game world
        Game.camera:attach()
            Game.level:draw()
            
            -- Draw enemies first (under wielder and boomerang)
            for _, enemy in ipairs(Game.enemies) do
                enemy:draw()
            end
            
            Game.wielder:draw()
            Game.boomerang:draw()
            Game.particles:draw()
        Game.camera:detach()
        
        -- Draw HUD
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Current Wielder: " .. Game.wielder.type, 10, 10)
        love.graphics.print("Press TAB to switch wielder", 10, 30)
        if Game.wielder.type == "Overconfident Barbarian" then
            love.graphics.print("Hold SPACE to charge throw!", 10, 50)
        elseif Game.wielder.type == "Physics Expert" then
            love.graphics.print("Hold SPACE to calculate throw!", 10, 50)
        end
    end
    
    -- Draw menu if not in game
    if Game.menu.state ~= "game" then
        Game.menu:draw()
    end
end 