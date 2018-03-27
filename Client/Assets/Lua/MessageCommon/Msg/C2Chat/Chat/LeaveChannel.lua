--
-- 客户端 --> 聊天服务器
-- 离开频道
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local LeaveChannel = class("LeaveChannel", GameMessage);

--
-- 构造函数
--
function LeaveChannel:ctor()
    LeaveChannel.super.ctor(self);
    --
    -- 频道Id
    --
    self.channelId = 0;
end

--@Override
function LeaveChannel:_OnSerial() 
    self:WriteInt64(self.channelId);
end

--@Override
function LeaveChannel:_OnDeserialize() 
    self.channelId = self:ReadInt64();
end

return LeaveChannel;
