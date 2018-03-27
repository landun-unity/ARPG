--
-- 逻辑服务器 --> 客户端
-- 同步战法经验
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SynchronizeWarfare = class("SynchronizeWarfare", GameMessage);

--
-- 构造函数
--
function SynchronizeWarfare:ctor()
    SynchronizeWarfare.super.ctor(self);
    --
    -- 战法值
    --
    self.warfarevalue = 0;
end

--@Override
function SynchronizeWarfare:_OnSerial() 
    self:WriteInt32(self.warfarevalue);
end

--@Override
function SynchronizeWarfare:_OnDeserialize() 
    self.warfarevalue = self:ReadInt32();
end

return SynchronizeWarfare;
