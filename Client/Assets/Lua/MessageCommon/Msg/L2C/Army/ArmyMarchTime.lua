--
-- 逻辑服务器 --> 客户端
-- 部队行军时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyMarchTime = class("ArmyMarchTime", GameMessage);

--
-- 构造函数
--
function ArmyMarchTime:ctor()
    ArmyMarchTime.super.ctor(self);
    --
    -- 部队行军时间
    --
    self.marchTime = 0;
end

--@Override
function ArmyMarchTime:_OnSerial() 
    self:WriteInt64(self.marchTime);
end

--@Override
function ArmyMarchTime:_OnDeserialize() 
    self.marchTime = self:ReadInt64();
end

return ArmyMarchTime;
