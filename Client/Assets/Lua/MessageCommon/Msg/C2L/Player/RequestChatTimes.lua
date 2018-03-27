--
-- 客户端 --> 逻辑服务器
-- 请求聊天次数
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestChatTimes = class("RequestChatTimes", GameMessage);

--
-- 构造函数
--
function RequestChatTimes:ctor()
    RequestChatTimes.super.ctor(self);
    --
    -- 玩家免费聊天次数
    --
    self.chatTimes = 0;
end

--@Override
function RequestChatTimes:_OnSerial() 
    self:WriteInt32(self.chatTimes);
end

--@Override
function RequestChatTimes:_OnDeserialize() 
    self.chatTimes = self:ReadInt32();
end

return RequestChatTimes;
