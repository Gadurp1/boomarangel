local Menu = {
    state = "main", -- main/level_select/game/pause
    selectedOption = 1,
    options = {
        main = {
            {text = "Play", action = function(menu) menu.state = "level_select" end},
            {text = "Survival Mode", action = function(menu) 
                Game.level:loadSurvival()
                menu.state = "game"
            end},
            {text = "Controls", action = function(menu) menu.state = "controls" end},
            {text = "Quit", action = function() love.event.quit() end}
        },
        level_select = {
            {text = "The Dojo", action = function(menu) 
                Game.level:load(1)
                menu.state = "game"
            end},
            {text = "The Physics Lab", action = function(menu)
                Game.level:load(2)
                menu.state = "game"
            end},
            {text = "The Time Trial", action = function(menu)
                Game.level:load(3)
                menu.state = "game"
            end},
            {text = "The Anti-Gravity Chamber", action = function(menu)
                Game.level:load(4)
                menu.state = "game"
            end},
            {text = "The Boss Room", action = function(menu)
                Game.level:load(5)
                menu.state = "game"
            end},
            {text = "Back", action = function(menu) menu.state = "main" end}
        },
        controls = {
            {text = "WASD: Move", action = nil},
            {text = "Space: Throw", action = nil},
            {text = "Arrow Keys: Control Boomerang", action = nil},
            {text = "R: Force Return", action = nil},
            {text = "Esc: Pause", action = nil},
            {text = "Survival Mode Controls:", action = nil},
            {text = "Mouse: Aim Weapon", action = nil},
            {text = "Click: Attack", action = nil},
            {text = "Back", action = function(menu) menu.state = "main" end}
        },
        pause = {
            {text = "Resume", action = function(menu) menu.state = "game" end},
            {text = "Restart Level", action = function(menu) 
                Game.level:load(Game.level.currentLevel)
                menu.state = "game"
            end},
            {text = "Level Select", action = function(menu) menu.state = "level_select" end},
            {text = "Main Menu", action = function(menu) menu.state = "main" end}
        }
    }
}

function Menu:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Menu:update(dt)
    if love.keyboard.wasPressed('up') then
        self.selectedOption = self.selectedOption - 1
        if self.selectedOption < 1 then
            self.selectedOption = #self.options[self.state]
        end
    end
    if love.keyboard.wasPressed('down') then
        self.selectedOption = self.selectedOption + 1
        if self.selectedOption > #self.options[self.state] then
            self.selectedOption = 1
        end
    end
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
        local selectedAction = self.options[self.state][self.selectedOption].action
        if selectedAction then
            selectedAction(self)
        end
    end
end

function Menu:draw()
    love.graphics.setColor(1, 1, 1)
    
    -- Draw title
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.printf("BOOMERANGELIC", 0, 100, love.graphics.getWidth(), "center")
    
    -- Draw menu options
    love.graphics.setFont(love.graphics.newFont(20))
    local startY = 300
    local spacing = 40
    
    for i, option in ipairs(self.options[self.state]) do
        if i == self.selectedOption then
            love.graphics.setColor(1, 1, 0)
            love.graphics.printf("> " .. option.text .. " <", 0, startY + (i-1) * spacing, 
                love.graphics.getWidth(), "center")
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(option.text, 0, startY + (i-1) * spacing, 
                love.graphics.getWidth(), "center")
        end
    end
    
    -- Draw state-specific info
    if self.state == "level_select" then
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.setFont(love.graphics.newFont(16))
        local level = Game.level.levels[self.selectedOption]
        if level and level.description then
            love.graphics.printf(level.description, 100, 200, 
                love.graphics.getWidth() - 200, "center")
        end
    end
end

return Menu 