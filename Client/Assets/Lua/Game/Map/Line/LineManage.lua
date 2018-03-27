-- 路径线管理
LineManage = class("LineManage")
local Line = require("Game/Map/Line/Line")

-- 构造函数
function LineManage:ctor( )
    -- 所有线穿过的格子的坐标
    self.allLineTiledList = {}
end

-- 获取线段穿过的格子的坐标
function LineManage:GetLineCroodinatePairs(startCroodinate, targetCroodinate)
    local startX = startCroodinate.x
    local startY = startCroodinate.y
    local targetX = targetCroodinate.x
    local targetY = targetCroodinate.y
    if startX == targetX then
        for i = startY-0.5, targetY-0.5 do
            local tempCroodinatePairs = {startX-0.5, i}
            table.insert(self.allLineTiledList, tempCroodinatePairs)
        end
    else
        for i = startX+0.5, targetX+0.5 do
            local tempY = self:GetOrdinate(startCroodinate, targetCroodinate, i)
        end
    end
end

-- 返回对应x所求得的y
function LineManage:GetOrdinate(startCroodinate, targetCroodinate, x)
    local y = 0;
    y = (targetCroodinate.y-startCroodinate.y)*(x-startCroodinate.x)/(targetCroodinate.x-startCroodinate.x)+startCroodinate.y;
    return y;
end



return LineManage
