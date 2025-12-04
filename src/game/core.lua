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
    print("Got " .. #Core.nodes .. " nodes!")
    Core.startNode = Core.nodes[1][1]
    Core.endNode = Core.nodes[40][50]
    Core.path = AStar.findPath(Core.nodes, Core.startNode, Core.endNode)
    print("Got path of length " .. #Core.path)
    for i, node in ipairs(Core.path) do
        print("Step " .. i .. ": (" .. node.x .. "/" .. node.y .. ")")
    end

    Core.status = INMENU
end

Core.update = function(dt)
    if Core.status == INMENU then
    elseif Core.status == INGAME then
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

    if Core.status ~= INGAME then
        return
    end
end

Core.mousemoved = function(x, y, dx, dy, istouch)
    if Core.status == INGAME then
    end
end

return Core
