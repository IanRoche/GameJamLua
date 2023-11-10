local Object = Object or require "lib.classic"
local Scene = Object:extend()

function Scene:new()
    self.buttons = {}
    self:createButtons()
end

function Scene:draw()
    self:drawButton(self.buttons.play)
    self:drawButton(self.buttons.quit)
end

function Scene:update(dt)
    self:updateButtonHoverState(self.buttons.play)
    self:updateButtonHoverState(self.buttons.quit)

    if self:checkButtonClick(self.buttons.play) then
        self:playButtonClicked()
    elseif self:checkButtonClick(self.buttons.quit) then
        self:quitButtonClicked()
    end
end

function Scene:createButtons()
    local buttonWidth = 200
    local buttonHeight = 60
    local buttonSpacing = 20

    local centerY = love.graphics.getHeight() / 2

    self.buttons.play = self:createButton(
        (love.graphics.getWidth() - buttonWidth) / 2,
        centerY - buttonHeight - buttonSpacing,
        buttonWidth,
        buttonHeight,
        "JUGAR"
    )

    self.buttons.quit = self:createButton(
        (love.graphics.getWidth() - buttonWidth) / 2,
        centerY + buttonSpacing,
        buttonWidth,
        buttonHeight,
        "SALIR"
    )
end

function Scene:createButton(x, y, width, height, text)
    return {
        x = x,
        y = y,
        width = width,
        height = height,
        text = text,
        isHovered = false
    }
end

function Scene:checkButtonClick(button)
    local mouseX, mouseY = love.mouse.getPosition()

    return love.mouse.isDown(1) and
           mouseX >= button.x and mouseX <= button.x + button.width and
           mouseY >= button.y and mouseY <= button.y + button.height
end

function Scene:updateButtonHoverState(button) --para saber si el mouse está encima del botón
    local mouseX, mouseY = love.mouse.getPosition()

    button.isHovered = mouseX >= button.x and mouseX <= button.x + button.width and
    mouseY >= button.y and mouseY <= button.y + button.height
end


function Scene:playButtonClicked()
    ChangeScene("Game")
end

function Scene:quitButtonClicked()
    love.event.quit()
end

function Scene:drawButton(button)
    local baseColor = {0.5, 0.5, 0.5} --fondo gris del botón
    local hoverColor = {0.3, 0.3, 0.3} --fondo gris oscuro del botón

    --determinar el color del fondo según si el ratón está encima o no
    local buttonColor = button.isHovered and hoverColor or baseColor 

    love.graphics.setColor(buttonColor)
    love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)

    -- Restaurar el color blanco para el texto
    love.graphics.setColor(1, 1, 1)

    -- Dibujar el borde del botón
    love.graphics.rectangle("line", button.x, button.y, button.width, button.height)

    -- Centrar el texto dentro del botón
    local textX = button.x + (button.width - love.graphics.getFont():getWidth(button.text)) / 2
    local textY = button.y + (button.height - love.graphics.getFont():getHeight()) / 2

    love.graphics.print(button.text, textX, textY)
end

return Scene
