--
-- 客户端 --> 逻辑服务器
-- 盟主/副盟主同意入盟
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local AgreeJoin = class("AgreeJoin", GameMessage);

--
-- 构造函数
--
function AgreeJoin:ctor()
    AgreeJoin.super.ctor(self);
    --
    -- 被处理人id
    --
    self.targetId = 0;
end

--@Override
function AgreeJoin:_OnSerial() 
    self:WriteInt64(self.targetId);
end

--@Override
function AgreeJoin:_OnDeserialize() 
    self.targetId = self:ReadInt64();
end

return AgreeJoin;
