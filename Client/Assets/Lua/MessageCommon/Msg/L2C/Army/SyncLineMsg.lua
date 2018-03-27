--
-- 逻辑服务器 --> 客户端
-- 同步线信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncLineMsg = class("SyncLineMsg", GameMessage);

--
-- 构造函数
--
function SyncLineMsg:ctor()
    SyncLineMsg.super.ctor(self);
    --
    -- 开始格子
    --
    self.startTiledIndex = 0;
    
    --
    -- 目标格子
    --
    self.targetTiledIndex = 0;
    
    --
    -- 行走时间
    --
    self.marchTime = 0;
end

--@Override
function SyncLineMsg:_OnSerial() 
    self:WriteInt32(self.startTiledIndex);
    self:WriteInt32(self.targetTiledIndex);
    self:WriteInt64(self.marchTime);
end

--@Override
function SyncLineMsg:_OnDeserialize() 
    self.startTiledIndex = self:ReadInt32();
    self.targetTiledIndex = self:ReadInt32();
    self.marchTime = self:ReadInt64();
end

return SyncLineMsg;
