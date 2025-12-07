-- ⠀⠀⡀⠀⠀⠀⣀⣠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠘⢿⣝⠛⠋⠉⠉⠉⣉⠩⠍⠉⣿⠿⡭⠉⠛⠃⠲⣞⣉⡙⠿⣇⠀⠀⠀
-- ⠀⠀⠈⠻⣷⣄⡠⢶⡟⢁⣀⢠⣴⡏⣀⡀⠀⠀⣠⡾⠋⢉⣈⣸⣿⡀⠀⠀
-- ⠀⠀⠀⠀⠙⠋⣼⣿⡜⠃⠉⠀⡎⠉⠉⢺⢱⢢⣿⠃⠘⠈⠛⢹⣿⡇⠀⠀
-- ⠀⠀⠀⢀⡞⣠⡟⠁⠀⠀⣀⡰⣀⠀⠀⡸⠀⠑⢵⡄⠀⠀⠀⠀⠉⠀⣧⡀
-- ⠀⠀⠀⠌⣰⠃⠁⣠⣖⣡⣄⣀⣀⣈⣑⣔⠂⠀⠠⣿⡄⠀⠀⠀⠀⠠⣾⣷
-- ⠀⠀⢸⢠⡇⠀⣰⣿⣿⡿⣡⡾⠿⣿⣿⣜⣇⠀⠀⠘⣿⠀⠀⠀⠀⢸⡀⢸
-- ⠀⠀⡆⢸⡀⠀⣿⣿⡇⣾⡿⠁⠀⠀⣹⣿⢸⠀⠀⠀⣿⡆⠀⠀⠀⣸⣤⣼
-- ⠀⠀⢳⢸⡧⢦⢿⣿⡏⣿⣿⣦⣀⣴⣻⡿⣱⠀⠀⠀⣻⠁⠀⠀⠀⢹⠛⢻
-- ⠀⠀⠈⡄⢷⠘⠞⢿⠻⠶⠾⠿⣿⣿⣭⡾⠃⠀⠀⢀⡟⠀⠀⠀⠀⣹⠀⡆
-- ⠀⠀⠀⠰⣘⢧⣀⠀⠙⠢⢤⠠⠤⠄⠊⠀⠀⠀⣠⠟⠀⠀⠀⠀⠀⢧⣿⠃
-- ⠀⣀⣤⣿⣇⠻⣟⣄⡀⠀⠘⣤⣣⠀⠀⠀⣀⢼⠟⠀⠀⠀⠀⠀⠄⣿⠟⠀
-- ⠿⠏⠭⠟⣤⣴⣬⣨⠙⠲⢦⣧⡤⣔⠲⠝⠚⣷⠀⠀⠀⢀⣴⣷⡠⠃⠀⠀
-- ⠀⠀⠀⠀⠀⠉⠉⠉⠛⠻⢛⣿⣶⣶⡽⢤⡄⢛⢃⣒⢠⣿⣿⠟⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠁⠀⠁⠀⠀⠀⠀⠀
-- "Here she comes! Keep testing! Remember: you never saw me!"

local Core = {}
Core.gameStarted = 0
Core.finalTime = 0
Core.showAnim = true
Core.animStepTime = 0.1
Core.timeSinceLastStep = 0

EXITED = -1
PAUSED = 0
LOADING = 1
INHELP = 5
INMENU = 11
INGAME = 12

Core.reset = function()

end

Core.load = function()
    Core.status = LOADING
    math.randomseed(os.time())
    Core.screen = UI.windowResized()
    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
        Core.isMobile = true
    else
        Core.isMobile = false
    end

    print("Generating nodes")
    Core.nodes = AStar.generateNodes(50, 50)
    if Core.nodes == nil then return end
    print("Got " .. #Core.nodes * #Core.nodes[1] .. " nodes!")
    Core.startNode = Core.nodes[1][1]
    Core.endNode = Core.nodes[40][50]
    Core.updateAStar()
    Core.status = INMENU
end

Core.update = function(dt)
    if Core.status == INMENU then
    elseif Core.status == INGAME then
        Core.timeSinceLastStep = Core.timeSinceLastStep + dt
        if Core.showAnim and Core.timeSinceLastStep > Core.animStepTime then
            Core.updateAStar(false)
            Core.timeSinceLastStep = 0
        end
    end
end

Core.keypressed = function(key, scancode, isrepeat)
    if key == "f5" then
        Settings.DEBUG = not Settings.DEBUG
    end
    if Core.status == INHELP then
        Core.status = INMENU
        return
    end
    if Core.status == INMENU then
        if key == "return" then
            Core.reset()
            Core.status = INGAME
            Core.gameStarted = love.timer.getTime()
        end
        if key == "h" or key == "H" then
            Core.status = INHELP
        end
    end

    if Core.status == INGAME then
        if key == "space" then
            Core.updateAStar(true)
        elseif key == "t" then
            Core.showAnim = not Core.showAnim
            Core.updateAStar(false)
        elseif key == "q" then
            Core.animStepTime = Core.animStepTime + 0.01
            Core.validateStepTime()
            print("Decreased Animation speed to " .. Core.animStepTime)
        elseif key == "e" then
            Core.animStepTime = Core.animStepTime - 0.01
            Core.validateStepTime()
            print("Increased Animation speed to " .. Core.animStepTime)
        elseif key == "r" then
            Core.updateAStar(true)
        end
    end
end


Core.mousepressed = function(x, y, button, istouch, presses)
    if Core.status == INHELP and Core.isMobile then
        Core.status = INMENU
        return
    end

    if Core.status == INMENU and Core.isMobile then
        Core.reset()
        Core.status = INGAME
        Core.gameStarted = love.timer.getTime()
    end

    if Core.status == INGAME then
        local node = Core.getNodeFromPosition(x, y, Core.nodes)
        if node then
            if node == Core.startNode then
                Core.dragNode = { Core.startNode, "start" }
            elseif node == Core.endNode then
                Core.dragNode = { Core.endNode, "end" }
            else
                if Core.drawWalls == nil then Core.drawWalls = not node.isWall end
                node.isWall = Core.drawWalls
                Core.updateAStar(true)
            end
        end
    end
end

Core.mousemoved = function(x, y, dx, dy, istouch)
    if Core.status == INGAME then
        if love.mouse.isDown(1) then
            local node = Core.getNodeFromPosition(x, y, Core.nodes)
            if node then
                if Core.dragNode then
                    if Core.dragNode[1] ~= node then
                        if Core.dragNode[2] == "start" then
                            Core.startNode = node
                        elseif Core.dragNode[2] == "end" then
                            Core.endNode = node
                        end
                        Core.updateAStar(true)
                    end
                else
                    if Core.drawWalls == nil then Core.drawWalls = not node.isWall end
                    node.isWall = Core.drawWalls
                    Core.updateAStar(true)
                end
            end
        end
    end
end

function Core.mousereleased(x, y, button, istouch, presses)
    Core.drawWalls = nil
    Core.dragNode = nil
    Core.updateAStar(true)
end

function Core.getNodeFromPosition(x, y, table)
    local xOffset = (Core.screen.w - Core.screen.minSize) / 2
    local yOffset = (Core.screen.h - Core.screen.minSize) / 2
    for i, row in ipairs(table) do
        for j, cell in ipairs(row) do
            local cellPixelX = xOffset + cell.x * UI.cellSize + cell.x * UI.padding
            local cellPixelY = yOffset + (cell.y - 1) * UI.cellSize + cell.y * UI.padding
            if x > cellPixelX and x < cellPixelX + UI.cellSize and
                y > cellPixelY and y < cellPixelY + UI.cellSize then
                return cell
            end
        end
    end
end

function Core.updateAStar(restart)
    if Core.showAnim then
        local response = "continue"
        local path
        if restart then
            response, path = AStar.findPathStep(Core.nodes, Core.startNode, Core.endNode, true)
            Core.path = path
            collectgarbage("collect")
        end
        response, path = AStar.findPathStep(Core.nodes, Core.startNode, Core.endNode, false)
        if response == "found" then
            if path then Core.path = path end
        end
    else
        Core.path = AStar.findPath(Core.nodes, Core.startNode, Core.endNode)
    end
end

function Core.validateStepTime()
    if Core.animStepTime > 0.1 then
        Core.animStepTime = 0.1
    elseif Core.animStepTime < 0.01 then
        Core.animStepTime = 0.01
    end
end

return Core
