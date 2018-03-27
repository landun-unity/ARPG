--
-- 逻辑服务器 --> 客户端
-- 资源地消息列表
-- @author czx
--
local List = require("common/List");

local SourceEventModel = require("MessageCommon/Msg/L2C/SourceEvent/SourceEventModel");

local GameMessage = require("common/Net/GameMessage");
local SourceEventList = class("SourceEventList", GameMessage);

--
-- 构造函数
--
function SourceEventList:ctor()
    SourceEventList.super.ctor(self);
    --
    -- 所有的技能列表
    --
    self.allSourceEventList = List.new();
end

--@Override
function SourceEventList:_OnSerial() 
    
    local allSourceEventListCount = self.allSourceEventList:Count();
    self:WriteInt32(allSourceEventListCount);
    for allSourceEventListIndex = 1, allSourceEventListCount, 1 do 
        local allSourceEventListValue = self.allSourceEventList:Get(allSourceEventListIndex);
        
        self:WriteInt32(allSourceEventListValue.iD);
        self:WriteInt32(allSourceEventListValue.eventType);
        self:WriteInt32(allSourceEventListValue.eventTableID);
        self:WriteInt32(allSourceEventListValue.positionX);
        self:WriteInt32(allSourceEventListValue.positionY);
        self:WriteInt64(allSourceEventListValue.endTime);
        self:WriteInt64(allSourceEventListValue.timer);
    end
end

--@Override
function SourceEventList:_OnDeserialize() 
    
    local allSourceEventListCount = self:ReadInt32();
    for i = 1, allSourceEventListCount, 1 do 
        local allSourceEventListValue = SourceEventModel.new();
        allSourceEventListValue.iD = self:ReadInt32();
        allSourceEventListValue.eventType = self:ReadInt32();
        allSourceEventListValue.eventTableID = self:ReadInt32();
        allSourceEventListValue.positionX = self:ReadInt32();
        allSourceEventListValue.positionY = self:ReadInt32();
        allSourceEventListValue.endTime = self:ReadInt64();
        allSourceEventListValue.timer = self:ReadInt64();
        self.allSourceEventList:Push(allSourceEventListValue);
    end
end

return SourceEventList;
