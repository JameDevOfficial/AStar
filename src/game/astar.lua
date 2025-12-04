local AStar = {}

function AStar.generateNodes(w,h)
    local w, h = w or Settings.AStar.size.w, h or Settings.AStar.size.h
    AStar.nodes = {}
    for i = 1, h, 1 do
        AStar.nodes[i] = {}
        for j = 1, w, 1 do
            AStar.nodes[i][j] = {
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
end

return AStar