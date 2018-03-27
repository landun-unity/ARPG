--
-- 客户端 --> 逻辑服务器
-- 打开玩家信息框
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OpenPlayerInfoInLeague = class("OpenPlayerInfoInLeague", GameMessage);

--
-- 构造函数
--
function OpenPlayerInfoInLeague:ctor()
    OpenPlayerInfoInLeague.super.ctor(self);
    --
    -- 目标玩家
    --
    self.targetId = 0;
end

--@Override
function OpenPlayerInfoInLeague:_OnSerial() 
    self:WriteInt64(self.targetId);
end

--@Override
function OpenPlayerInfoInLeague:_OnDeserialize() 
    self.targetId = self:ReadInt64();
end

return OpenPlayerInfoInLeague;
