--
-- 逻辑服务器 --> 客户端
-- 操作类型回复消息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local LeagueOperationTipsMsg = class("LeagueOperationTipsMsg", GameMessage);

--
-- 构造函数
--
function LeagueOperationTipsMsg:ctor()
    LeagueOperationTipsMsg.super.ctor(self);
    --
    -- 类型枚举
    --
    self.mtype = 0;
end

--@Override
function LeagueOperationTipsMsg:_OnSerial() 
    self:WriteInt32(self.mtype);
end

--@Override
function LeagueOperationTipsMsg:_OnDeserialize() 
    self.mtype = self:ReadInt32();
end

return LeagueOperationTipsMsg;
