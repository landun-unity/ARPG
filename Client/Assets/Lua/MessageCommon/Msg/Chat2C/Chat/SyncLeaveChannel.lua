--
-- 聊天服务器 --> 客户端
-- 同步离开频道
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncLeaveChannel = class("SyncLeaveChannel", GameMessage);

--
-- 构造函数
--
function SyncLeaveChannel:ctor()
    SyncLeaveChannel.super.ctor(self);
    --
    -- 频道Id
    --
    self.channelId = 0;
end

--@Override
function SyncLeaveChannel:_OnSerial() 
    self:WriteInt64(self.channelId);
end

--@Override
function SyncLeaveChannel:_OnDeserialize() 
    self.channelId = self:ReadInt64();
end

return SyncLeaveChannel;
