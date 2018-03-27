--
-- 逻辑服务器 --> 客户端
-- 刷新资源信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncJade = class("SyncJade", GameMessage);

--
-- 构造函数
--
function SyncJade:ctor()
    SyncJade.super.ctor(self);
    --
    -- 玉符
    --
    self.jadey = 0;
end

--@Override
function SyncJade:_OnSerial() 
    self:WriteInt32(self.jadey);
end

--@Override
function SyncJade:_OnDeserialize() 
    self.jadey = self:ReadInt32();
end

return SyncJade;
