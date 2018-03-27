--
-- 逻辑服务器 --> 客户端
-- 登录税收请求回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncReplyRevenue = class("SyncReplyRevenue", GameMessage);

--
-- 构造函数
--
function SyncReplyRevenue:ctor()
    SyncReplyRevenue.super.ctor(self);
    --
    -- 金币
    --
    self.gold = 0;
    
    --
    -- 次数
    --
    self.surplusReceiveCount = 0;
    
    --
    -- 时间
    --
    self.time = 0;
end

--@Override
function SyncReplyRevenue:_OnSerial() 
    self:WriteInt64(self.gold);
    self:WriteInt32(self.surplusReceiveCount);
    self:WriteInt64(self.time);
end

--@Override
function SyncReplyRevenue:_OnDeserialize() 
    self.gold = self:ReadInt64();
    self.surplusReceiveCount = self:ReadInt32();
    self.time = self:ReadInt64();
end

return SyncReplyRevenue;
