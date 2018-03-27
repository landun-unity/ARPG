--
-- 一条线的信息
--
local Line = class("Line");

function Line:ctor()
    --
    -- 唯一ID
    --
    self.oId = 0;
    
    --
    -- 玩家ID
    --
    self.ownerId = 0;
    
    --
    -- 产生部队的建筑物
    --
    self.spawnBuildingId = 0;
    
    --
    -- 产生部队的槽位
    --
    self.spawnSlotId = 0;
    
    --
    -- 出发点坐标
    --
    self.startCroodinate = {};
    
    --
    -- 目标点坐标
    --
    self.targetCroodinate = {};

    -- 设置出发点坐标
    function Line:SetStartCroodinate(x, y)
        self.startCroodinate.x = x + 0.5
        self.startCroodinate.y = y + 0.5
    end

    -- 设置目标点坐标
    function Line:SetStartCroodinate(x, y)
        self.targetCroodinate.x = x + 0.5
        self.targetCroodinate.y = y + 0.5
    end
    
end

return Line;
