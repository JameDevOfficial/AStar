local AStar = {}

local neighbors = {
    { 0,  -1 }, { -1, 0 }, { 0, 1 }, { 1, 0 },
    { -1, -1 }, { -1, 1 }, { 1, 1 }, { 1, -1 }
}

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- https://stackoverflow.com/a/72784448/30694228
function table.reverse(tab)
    for i = 1, math.floor(#tab / 2), 1 do
        tab[i], tab[#tab - i + 1] = tab[#tab - i + 1], tab[i]
    end
    return tab
end

function AStar.generateNodes(w, h)
    local w, h = w or Settings.AStar.size.w, h or Settings.AStar.size.h
    local nodes = {}
    for i = 1, h, 1 do
        nodes[i] = {}
        for j = 1, w, 1 do
            nodes[i][j] = {
                x = j,
                y = i,
                isWall = false,
                g = nil,
                h = nil,
                f = nil,
                parent = nil
            }
        end
    end
    return nodes
end

local function tracePath(startNode, endNode)
    local path = {}
    local node = endNode

    while node ~= startNode do
        table.insert(path, node)
        node = node.parent
        if not node then break end
    end

    path = table.reverse(path)
    return path
end

local function manhattan(x1, y1, x2, y2)
    return math.abs(x1 - x2) + math.abs(y1 - y2)
end

local function isDiagonal(x, y)
    if (math.abs(x) == 1 and math.abs(y) == 1) then
        return true
    end
    return false
end

local function diagonalThroughWalls(x, y, nodes, cx, cy)
    if x == 1 and y == -1 then -- top right
        if nodes[cy][cx + 1].isWall and nodes[cy - 1][cx].isWall then
            return true
        end
    elseif x == -1 and y == -1 then -- top left
        if nodes[cy][cx - 1].isWall and nodes[cy - 1][cx].isWall then
            return true
        end
    elseif x == 1 and y == 1 then -- bottom right
        if nodes[cy][cx + 1].isWall and nodes[cy + 1][cx].isWall then
            return true
        end
    elseif x == -1 and y == 1 then -- bottom left
        if nodes[cy][cx - 1].isWall and nodes[cy + 1][cx].isWall then
            return true
        end
    end
    return false
end

function AStar.findPath(nodes, startNode, endNode)
    startNode.g = 0
    startNode.h = manhattan(startNode.x, startNode.y, endNode.x, endNode.y)
    startNode.f = startNode.g + startNode.h

    AStar.liveNodes = { startNode }
    AStar.finishedNodes = {}

    while #AStar.liveNodes > 0 do
        local current = AStar.liveNodes[1]
        local currentPos = 1
        for i, node in ipairs(AStar.liveNodes) do
            if node.f < current.f then
                current = node
                currentPos = i
            end
        end
        if current == endNode then return tracePath(startNode, endNode) end

        table.remove(AStar.liveNodes, currentPos)
        table.insert(AStar.finishedNodes, current)

        for _, direction in ipairs(neighbors) do
            local nx, ny = current.x + direction[1], current.y + direction[2]
            local neighbor = nodes[ny] and nodes[ny][nx]
            if neighbor then
                if not neighbor.isWall and
                    not table.contains(AStar.finishedNodes, neighbor) and
                    not table.contains(AStar.liveNodes, neighbor) and
                    not (isDiagonal(direction[1], direction[2]) and diagonalThroughWalls(direction[1], direction[2], nodes, current.x, current.y)) then
                    local moveCost = (direction[1] ~= 0 and direction[2] ~= 0) and 2 or 1
                    neighbor.g = current.g + moveCost
                    neighbor.h = manhattan(neighbor.x, neighbor.y, endNode.x, endNode.y)
                    neighbor.f = neighbor.g + neighbor.h
                    neighbor.parent = current
                    table.insert(AStar.liveNodes, neighbor)
                end
            end
        end
    end
    return {}
end

return AStar
