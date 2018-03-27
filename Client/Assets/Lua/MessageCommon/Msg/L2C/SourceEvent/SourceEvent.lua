--
-- 逻辑服务器 --> 客户端
-- 资源地消息
-- @author czx
--
local SourceEventModel = require("MessageCommon/Msg/L2C/SourceEvent/SourceEventModel");

local GameMessage = require("common/Net/GameMessage");
local SourceEvent = class("SourceEvent", GameMessage);

--
-- 构造函数
--
function SourceEvent:ctor()
    SourceEvent.super.ctor(self);
    --
    -- 单个资源地
    --
    self.info = SourceEventModel.new();
end

--@Override
function SourceEvent:_OnSerial() 
    self:WriteInt32(self.info.iD);
    self:WriteInt32(self.info.eventType);
    self:WriteInt32(self.info.eventTableID);
    self:WriteInt32(self.info.positionX);
    self:WriteInt32(self.info.positionY);
    self:WriteInt64(self.info.endTime);
    self:WriteInt64(self.info.timer);
end

--@Override
function SourceEvent:_OnDeserialize() 
    self.info.iD = self:ReadInt32();
    self.info.eventType = self:ReadInt32();
    self.info.eventTableID = self:ReadInt32();
    self.info.positionX = self:ReadInt32();
    self.info.positionY = self:ReadInt32();
    self.info.endTime = self:ReadInt64();
    self.info.timer = self:ReadInt64();
end

return SourceEvent;
