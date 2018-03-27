--
-- 逻辑服务器 --> 客户端
-- 同步建筑物建造队列数量到客户端
-- @author czx
--
local List = require("common/List");

local SyncSingleBuildQueue = require("MessageCommon/Msg/L2C/Building/SyncSingleBuildQueue");

local GameMessage = require("common/Net/GameMessage");
local SyncBuildQueueList = class("SyncBuildQueueList", GameMessage);

--
-- 构造函数
--
function SyncBuildQueueList:ctor()
    SyncBuildQueueList.super.ctor(self);
    --
    -- 建筑物建造队列列表
    --
    self.list = List.new();
end

--@Override
function SyncBuildQueueList:_OnSerial() 
    
    local listCount = self.list:Count();
    self:WriteInt32(listCount);
    for listIndex = 1, listCount, 1 do 
        local listValue = self.list:Get(listIndex);
        
        self:WriteInt64(listValue.buildingId);
        self:WriteInt32(listValue.baseQueueCount);
        self:WriteInt32(listValue.tempQueueCount);
    end
end

--@Override
function SyncBuildQueueList:_OnDeserialize() 
    
    local listCount = self:ReadInt32();
    for i = 1, listCount, 1 do 
        local listValue = SyncSingleBuildQueue.new();
        listValue.buildingId = self:ReadInt64();
        listValue.baseQueueCount = self:ReadInt32();
        listValue.tempQueueCount = self:ReadInt32();
        self.list:Push(listValue);
    end
end

return SyncBuildQueueList;
