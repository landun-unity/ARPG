--
-- 客户端 --> 聊天服务器
-- 加入频道
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local JoinChannel = class("JoinChannel", GameMessage);

--
-- 构造函数
--
function JoinChannel:ctor()
    JoinChannel.super.ctor(self);
    --
    -- 频道Id
    --
    self.channelId = 0;
end

--@Override
function JoinChannel:_OnSerial() 
    self:WriteInt64(self.channelId);
end

--@Override
function JoinChannel:_OnDeserialize() 
    self.channelId = self:ReadInt64();
end

return JoinChannel;
