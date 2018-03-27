--
-- 逻辑服务器 --> 客户端
-- 刷新资源信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncDecree = class("SyncDecree", GameMessage);

--
-- 构造函数
--
function SyncDecree:ctor()
    SyncDecree.super.ctor(self);
    --
    -- 政令
    --
    self.decree = 0;
    
    --
    -- 上一次更新时间
    --
    self.lastUpdateTime = 0;
end

--@Override
function SyncDecree:_OnSerial() 
    self:WriteInt32(self.decree);
    self:WriteInt64(self.lastUpdateTime);
end

--@Override
function SyncDecree:_OnDeserialize() 
    self.decree = self:ReadInt32();
    self.lastUpdateTime = self:ReadInt64();
end

return SyncDecree;
