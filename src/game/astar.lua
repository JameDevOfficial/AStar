local AStar = {}

local neighbors = {
    { 1,  0 }, { 0, -1 }, { -1, 0 }, { 0, 1 },
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

function AStar.findPath(nodes, startNode, endNode)
    startNode.g = 0
    startNode.h = math.abs(startNode.x - endNode.x) + math.abs(startNode.y - endNode.y)
    startNode.f = startNode.g + startNode.h

    local liveNodes = { startNode }
    local finishedNodes = {}

    while #liveNodes > 0 do
        local current = liveNodes[1]
        local currentPos = 1
        for i, node in ipairs(liveNodes) do
            if node.f < current.f then
                current = node
                currentPos = i
            end
        end
        if current == endNode then return tracePath(startNode, endNode) end

        table.remove(liveNodes, currentPos)
        table.insert(finishedNodes, current)

        for _, direction in ipairs(neighbors) do
            local nx, ny = current.x + direction[1], current.y + direction[2]
            local neighbor = nodes[ny] and nodes[ny][nx]
            if neighbor then
                if not neighbor.isWall and
                    not table.contains(finishedNodes, neighbor) and
                    not table.contains(liveNodes, neighbor) then
                    neighbor.g = current.g + 1
                    neighbor.h = math.abs(neighbor.x - endNode.x) + math.abs(neighbor.y - endNode.y)
                    neighbor.f = neighbor.g + neighbor.h
                    neighbor.parent = current
                    table.insert(liveNodes, neighbor)
                end
            end
        end
    end
    return {}
end

return AStar
