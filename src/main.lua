Core = require("game.core")
Settings = require("game.settings")
UI = require("game.ui")
AStar = require("game.astar")

function love.load()
    Core.load()
end

function love.update(dt)
    Core.update(dt)
end

function love.draw()
    UI.draw()
end

function love.resize()
    Core.screen = UI.windowResized()
end

function love.keypressed(key, scancode, isrepeat)
    Core.keypressed(key, scancode, isrepeat)
end

function love.mousepressed(x, y, button, istouch, presses)
    Core.mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    Core.mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
    Core.mousemoved(x, y, dx, dy, istouch)
end
