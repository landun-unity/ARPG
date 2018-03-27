--
-- 逻辑服务器 --> 客户端
-- 一个要塞的信息
-- @author czx
--
local PlayerFortModel = class("PlayerFortModel");

function PlayerFortModel:ctor()
    --
    -- 建筑物Id
    --
    self.buildingId = 0;
    
    --
    -- 建筑物索引
    --
    self.index = 0;
    
    --
    -- 表Id
    --
    self.tableId = 0;
    
    --
    -- 玩家Id
    --
    self.ownerId = 0;
    
    --
    -- 建筑物Name
    --
    self.cityName = "";
    
    --
    -- 当前时间
    --
    self.currentTime = 0;
    
    --
    -- 结束时间
    --
    self.endTime = 0;
    
    --
    -- 升级要塞时间
    --
    self.updateFortTime = 0;
    
    --
    -- 放弃要塞时间
    --
    self.abandonFortTime = 0;
    
    --
    -- 要塞等级
    --
    self.level = 0;
    
    --
    -- 要塞编号
    --
    self.numName = 0;
end

return PlayerFortModel;
