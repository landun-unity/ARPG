--
-- 逻辑服务器 --> 客户端
-- 一条线的信息
-- @author czx
--
local LineModel = class("LineModel");

function LineModel:ctor()
    --
    -- 唯一ID
    --
    self.oId = 0;
    
    --
    -- 玩家ID
    --
    self.playerId = 0;
    
    --
    -- 产生部队的建筑物
    --
    self.spawnBuilding = 0;
    
    --
    -- 产生部队的槽位
    --
    self.spawnSlotId = 0;
    
    --
    -- 出发点横坐标
    --
    self.startCroodinateX = 0;
    
    --
    -- 出发点纵坐标
    --
    self.startCroodinateY = 0;
    
    --
    -- 目标点横坐标
    --
    self.targetCroodinateX = 0;
    
    --
    -- 目标点纵坐标
    --
    self.targetCroodinateY = 0;
end

return LineModel;
