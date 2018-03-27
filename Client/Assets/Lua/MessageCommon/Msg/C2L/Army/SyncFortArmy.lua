--
-- 客户端 --> 逻辑服务器
-- 同步部队
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SyncFortArmy = class("SyncFortArmy", GameMessage);

--
-- 构造函数
--
function SyncFortArmy:ctor()
    SyncFortArmy.super.ctor(self);

    self.tiledIndex = 0;
end

--@Override
function SyncFortArmy:_OnSerial() 
	self:WriteInt32(self.tiledIndex);
end

--@Override
function SyncFortArmy:_OnDeserialize() 
	self.tiledIndex = self:ReadInt32();
end

return SyncFortArmy;

