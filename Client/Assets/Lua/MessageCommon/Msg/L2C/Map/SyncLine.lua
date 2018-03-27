--
-- 逻辑服务器 --> 客户端
-- 同步线信息
-- @author czx
--
local List = require("common/List");

local LineModel = require("MessageCommon/Msg/L2C/Map/LineModel");

local GameMessage = require("common/Net/GameMessage");
local SyncLine = class("SyncLine", GameMessage);

--
-- 构造函数
--
function SyncLine:ctor()
    SyncLine.super.ctor(self);
    --
    -- 所有线信息
    --
    self.allLineList = List.new();
end

--@Override
function SyncLine:_OnSerial() 
    
    local allLineListCount = self.allLineList:Count();
    self:WriteInt32(allLineListCount);
    for i = 1, allLineListCount, 1 do 
        local allLineListValue = self.allLineList:Get(i);
        
        self:WriteInt64(allLineListValue.oId);
        self:WriteInt64(allLineListValue.playerId);
        self:WriteInt64(allLineListValue.spawnBuilding);
        self:WriteInt32(allLineListValue.spawnSlotId);
        self:WriteInt32(allLineListValue.startCroodinateX);
        self:WriteInt32(allLineListValue.startCroodinateY);
        self:WriteInt32(allLineListValue.targetCroodinateX);
        self:WriteInt32(allLineListValue.targetCroodinateY);
    end
end

--@Override
function SyncLine:_OnDeserialize() 
    
    local allLineListCount = self:ReadInt32();
    for i = 1, allLineListCount, 1 do 
        local allLineListValue = LineModel.new();
        allLineListValue.oId = self:ReadInt64();
        allLineListValue.playerId = self:ReadInt64();
        allLineListValue.spawnBuilding = self:ReadInt64();
        allLineListValue.spawnSlotId = self:ReadInt32();
        allLineListValue.startCroodinateX = self:ReadInt32();
        allLineListValue.startCroodinateY = self:ReadInt32();
        allLineListValue.targetCroodinateX = self:ReadInt32();
        allLineListValue.targetCroodinateY = self:ReadInt32();
        self.allLineList:Push(allLineListValue);
    end
end

return SyncLine;
