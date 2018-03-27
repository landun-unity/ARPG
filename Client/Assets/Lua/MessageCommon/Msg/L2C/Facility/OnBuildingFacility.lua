--
-- 逻辑服务器 --> 客户端
-- 建造队列消息
-- @author czx
--
local List = require("common/List");

local GameMessage = require("common/Net/GameMessage");
local OnBuildingFacility = class("OnBuildingFacility", GameMessage);

--
-- 构造函数
--
function OnBuildingFacility:ctor()
    OnBuildingFacility.super.ctor(self);
    --
    -- 城市id
    --
    self.buildingId = 0;
    
    --
    -- 基础建造队列设施ID列表
    --
    self.baseQueueList = List.new();
    
    --
    -- 临时建造队列设施ID列表
    --
    self.tempQueueList = List.new();
end

--@Override
function OnBuildingFacility:_OnSerial() 
    self:WriteInt64(self.buildingId);
    
    local baseQueueListCount = self.baseQueueList:Count();
    self:WriteInt32(baseQueueListCount);
    for baseQueueListIndex = 1, baseQueueListCount, 1 do 
        self:WriteInt32(self.baseQueueList:Get(baseQueueListIndex));
    end
    
    local tempQueueListCount = self.tempQueueList:Count();
    self:WriteInt32(tempQueueListCount);
    for tempQueueListIndex = 1, tempQueueListCount, 1 do 
        self:WriteInt32(self.tempQueueList:Get(tempQueueListIndex));
    end
end

--@Override
function OnBuildingFacility:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    
    local baseQueueListCount = self:ReadInt32();
    for i = 1, baseQueueListCount, 1 do 
        self.baseQueueList:Push(self:ReadInt32());
    end
    
    local tempQueueListCount = self:ReadInt32();
    for i = 1, tempQueueListCount, 1 do 
        self.tempQueueList:Push(self:ReadInt32());
    end
end

return OnBuildingFacility;
