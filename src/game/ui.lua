local UI = {}

local fontDefault = love.graphics.newFont(20)
local font30 = love.graphics.newFont(30)
local font50 = love.graphics.newFont(50)
local titleFont = love.graphics.newFont(Settings.fonts.quirkyRobot, 128, "normal", love.graphics.getDPIScale())
local textFont = love.graphics.newFont(Settings.fonts.semiCoder, 32, "normal", love.graphics.getDPIScale())
local textFontBig = love.graphics.newFont(Settings.fonts.semiCoder, 46, "normal", love.graphics.getDPIScale())

titleFont:setFilter("nearest", "nearest")
textFont:setFilter("nearest", "nearest")
fontDefault:setFilter("nearest", "nearest")
font30:setFilter("nearest", "nearest")
font50:setFilter("nearest", "nearest")

UI.draw = function()
    if Core.status == INGAME then
        UI.drawGame()
    elseif Core.status == INMENU then
        UI.drawMenu()
    elseif Core.status == INHELP then
        UI.drawHelp()
    end
    if Settings.DEBUG then
        UI.drawDebug()
    end
end

UI.drawGame = function()
    UI.padding = 1
    local gridRows = #Core.nodes
    local gridCols = #Core.nodes[1]
    local totalPaddingX = (gridCols + 1) * UI.padding
    local totalPaddingY = (gridRows + 1) * UI.padding
    UI.cellSizeX = (Core.screen.w - totalPaddingX) / gridCols
    UI.cellSizeY = (Core.screen.h - totalPaddingY) / gridRows
    local xOffset = -UI.cellSizeX
    local yOffset = 0
    for i, row in ipairs(Core.nodes) do
        for j, node in ipairs(row) do
            if node == Core.endNode then
                love.graphics.setColor(1, 0, 0)
            elseif node == Core.startNode then
                love.graphics.setColor(0, 1, 0)
            elseif node.isWall == true then
                love.graphics.setColor(0.8, 0.8, 0.8)
            elseif Core.path and table.contains(Core.path, node) then
                love.graphics.setColor(0, 0, 1)
            elseif Core.showAnim == true and AStar.liveNodes and table.contains(AStar.liveNodes, node) then
                love.graphics.setColor(0.4, 0.6, 0.8)
            elseif Core.showAnim == true and table.contains(AStar.finishedNodes, node) then
                love.graphics.setColor(0.6, 0.8, 1)
            else
                love.graphics.setColor(1, 1, 1)
            end
            local x = xOffset + node.x * UI.cellSizeX + node.x * UI.padding
            local y = yOffset + (node.y - 1) * UI.cellSizeY + node.y * UI.padding
            love.graphics.rectangle("fill", x, y, UI.cellSizeX, UI.cellSizeY)
        end
    end
end

UI.drawHelp = function()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(textFontBig)
    local currentY = 100

    local text = string.format("Gameplay: ")
    local width = textFont:getWidth(text)
    local height = textFont:getHeight()
    love.graphics.print(text, (Core.screen.w - width) / 2, currentY)
    currentY = currentY + height + 10

    love.graphics.setFont(textFont)
    local text = string.format(
        "No Help yet")
    local width = textFont:getWidth(text)
    local height = textFont:getHeight()
    love.graphics.print(text, (Core.screen.w - width) / 2, currentY)
    currentY = currentY + height

    text = "Press any key to return"
    width = textFont:getWidth(text)
    love.graphics.print(text, (Core.screen.w - width) / 2, (Core.screen.centerY - height) * 2)
end

UI.drawMenu = function()
    love.graphics.setColor(0.7, 0.95, 1)
    love.graphics.setFont(titleFont)
    local text = "A*"
    local width = titleFont:getWidth(text)
    if Core.isMobile then
        love.graphics.print(text, (Core.screen.w - width) / 2, Core.screen.centerY - 100)
    else
        love.graphics.print(text, (Core.screen.w - width) / 2, Core.screen.centerY - 200)
    end

    love.graphics.setFont(textFont)
    love.graphics.setColor(1, 1, 1)
    local ms, s, m
    local text = UI.secondsToFormat(Core.finalTime)
    width = textFont:getWidth(text)
    local height = textFont:getHeight()
    if Core.isMobile then
        love.graphics.print(text, (Core.screen.w - width) / 2, Core.screen.centerY - 0)
    else
        love.graphics.print(text, (Core.screen.w - width) / 2, Core.screen.centerY - 100)
    end


    text = "Press 'enter' to start - 'h' for help"
    if Core.isMobile then
        text = "Touch to start"
    end
    love.graphics.setFont(textFont)
    love.graphics.setColor(1, 1, 1)
    width = textFont:getWidth(text)
    local height = textFont:getHeight()
    love.graphics.print(text, (Core.screen.w - width) / 2, (Core.screen.centerY - height) * 2)
end

UI.drawDebug = function()
    if Settings.DEBUG == true then
        love.graphics.setFont(fontDefault)

        local y = fontDefault:getHeight() + 10

        love.graphics.setColor(1, 0.1, 0.1)
        love.graphics.print("Disable (F5) Debug Mode for more FPS")
        y = y + fontDefault:getHeight()

        love.graphics.setColor(0.1, 0.1, 1, 1)
        -- FPS
        local fps = love.timer.getFPS()
        local fpsText = string.format("FPS: %d", fps)
        love.graphics.print(fpsText, 10, y)
        y = y + fontDefault:getHeight()

        -- Performance
        local stats = love.graphics.getStats()
        local usedMem = collectgarbage("count")
        local perfText = string.format(
            "Memory: %.2f MB\n" ..
            "GC Pause: %d%%\n" ..
            "Draw Calls: %d\n" ..
            "Canvas Switches: %d\n" ..
            "Texture Memory: %.2f MB\n" ..
            "Images: %d\n" ..
            "Fonts: %d\n",
            usedMem / 1024,
            collectgarbage("count") > 0 and collectgarbage("count") / 7 or 0,
            stats.drawcalls,
            stats.canvasswitches,
            stats.texturememory / 1024 / 1024,
            stats.images,
            stats.fonts
        )
        love.graphics.print(perfText, 10, y)
        y = y + fontDefault:getHeight() * 8

        -- Game
        local dt = love.timer.getDelta()
        local avgDt = love.timer.getAverageDelta()

        local playerText = string.format(
            "Game state: %s\n" ..
            "Delta Time: %.4fs (%.1f ms)\n" ..
            "Avg Delta: %.4fs (%.1f ms)\n" ..
            "Time: %.2fs\n",
            tostring(Core.status),
            dt, dt * 1000,
            avgDt, avgDt * 1000,
            love.timer.getTime()
        )
        love.graphics.print(playerText, 10, y)
        y = y + fontDefault:getHeight() * 5

        -- System Info
        local renderer = love.graphics.getRendererInfo and love.graphics.getRendererInfo() or ""
        local systemText = string.format(
            "OS: %s\nGPU: %s",
            love.system.getOS(),
            select(4, love.graphics.getRendererInfo()) or 0
        )
        love.graphics.print(systemText, 10, y)
    end
end

function UI.secondsToFormat(seconds)
    local m = math.floor(seconds / 60)
    local s = math.floor(seconds % 60)
    local ms = math.floor((seconds - math.floor(seconds)) * 1000)
    return string.format("%02d:%02d:%03d", m, s, ms)
end

UI.windowResized = function()
    local screen = {
        w = 0,
        h = 0,
        centerX = 0,
        centerY = 0,
        minSize = 0,
        topLeft = { X = 0, Y = 0 },
        topRight = { X = 0, Y = 0 },
        bottomLeft = { X = 0, Y = 0 },
        bottomRight = { X = 0, Y = 0 }
    }
    screen.w, screen.h = love.graphics.getDimensions()
    screen.minSize = (screen.h < screen.w) and screen.h or screen.w
    screen.centerX = screen.w / 2
    screen.centerY = screen.h / 2

    local half = screen.minSize / 2
    screen.topLeft.X = screen.centerX - half
    screen.topLeft.Y = screen.centerY - half
    screen.topRight.X = screen.centerX + half
    screen.topRight.Y = screen.centerY - half
    screen.bottomRight.X = screen.centerX + half
    screen.bottomRight.Y = screen.centerY + half
    screen.bottomLeft.X = screen.centerX - half
    screen.bottomLeft.Y = screen.centerY + half

    return screen
end

return UI
