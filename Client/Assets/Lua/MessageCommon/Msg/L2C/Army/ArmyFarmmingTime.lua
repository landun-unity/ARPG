--
-- 逻辑服务器 --> 客户端
-- 屯田时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyFarmmingTime = class("ArmyFarmmingTime", GameMessage);

--
-- 构造函数
--
function ArmyFarmmingTime:ctor()
    ArmyFarmmingTime.super.ctor(self);
    --
    -- 屯田时间
    --
    self.farmmingTime = 0;
end

--@Override
function ArmyFarmmingTime:_OnSerial() 
    self:WriteInt64(self.farmmingTime);
end

--@Override
function ArmyFarmmingTime:_OnDeserialize() 
    self.farmmingTime = self:ReadInt64();
end

return ArmyFarmmingTime;
