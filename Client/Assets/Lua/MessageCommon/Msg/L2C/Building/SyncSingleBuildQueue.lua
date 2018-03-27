--
-- 逻辑服务器 --> 客户端
-- 同步单个建筑物建造队列数量到客户端
-- @author czx
--
local SyncSingleBuildQueue = class("SyncSingleBuildQueue");

function SyncSingleBuildQueue:ctor()
    --
    -- 城池id
    --
    self.buildingId = 0;
    
    --
    -- 基础建造队列数量
    --
    self.baseQueueCount = 0;
    
    --
    -- 临时建造队列数量
    --
    self.tempQueueCount = 0;
end

return SyncSingleBuildQueue;
