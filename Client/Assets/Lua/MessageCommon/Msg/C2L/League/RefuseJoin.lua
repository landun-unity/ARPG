--
-- 客户端 --> 逻辑服务器
-- 盟主/副盟主拒绝玩家加入
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RefuseJoin = class("RefuseJoin", GameMessage);

--
-- 构造函数
--
function RefuseJoin:ctor()
    RefuseJoin.super.ctor(self);
    --
    -- 玩家id
    --
    self.targetId = 0;
end

--@Override
function RefuseJoin:_OnSerial() 
    self:WriteInt64(self.targetId);
end

--@Override
function RefuseJoin:_OnDeserialize() 
    self.targetId = self:ReadInt64();
end

return RefuseJoin;
