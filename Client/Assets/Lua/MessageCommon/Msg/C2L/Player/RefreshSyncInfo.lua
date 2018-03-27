--
-- 客户端 --> 逻辑服务器
-- 刷新同步信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RefreshSyncInfo = class("RefreshSyncInfo", GameMessage);

--
-- 构造函数
--
function RefreshSyncInfo:ctor()
    RefreshSyncInfo.super.ctor(self);
    --
    -- 同步类型
    --
    self.syncType = 0;
    
    --
    -- 索引
    --
    self.index = 0;
end

--@Override
function RefreshSyncInfo:_OnSerial() 
    self:WriteInt32(self.syncType);
    self:WriteInt64(self.index);
end

--@Override
function RefreshSyncInfo:_OnDeserialize() 
    self.syncType = self:ReadInt32();
    self.index = self:ReadInt64();
end

return RefreshSyncInfo;
