--
-- 逻辑服务器 --> 客户端
-- 同步格子信息
-- @author czx
--
local TiledInfoForPower = class("TiledInfoForPower");

function TiledInfoForPower:ctor()
    --
    -- 土地Id
    --
    self.tiledId = 0;
    
    --
    -- 土地表Id
    --
    self.tiledTableId = 0;
    
    --
    -- 当前地块耐久
    --
    self.curDurableVal = 0;
    
    --
    -- 地块耐久最大值
    --
    self.maxDurableVal = 0;
    
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 建筑物表Id
    --
    self.buildingTableId = 0;
    
    --
    -- 是否有城区
    --
    self.isHaveTown = 0;
    
    --
    -- 城区建筑Id
    --
    self.buildingIdForTown = 0;
    
    --
    -- 城区建筑表Id
    --
    self.buildingTableIdForTown = 0;
end

return TiledInfoForPower;
