--
-- 逻辑服务器 --> 客户端
-- 同步玩家聊天次数
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncChatTimes = class("SyncChatTimes", GameMessage);

--
-- 构造函数
--
function SyncChatTimes:ctor()
    SyncChatTimes.super.ctor(self);
    --
    -- 玩家免费聊天次数
    --
    self.chatTimes = 0;
end

--@Override
function SyncChatTimes:_OnSerial() 
    self:WriteInt32(self.chatTimes);
end

--@Override
function SyncChatTimes:_OnDeserialize() 
    self.chatTimes = self:ReadInt32();
end

return SyncChatTimes;
