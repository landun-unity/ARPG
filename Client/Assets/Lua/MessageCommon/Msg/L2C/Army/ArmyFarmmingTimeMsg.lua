--
-- 逻辑服务器 --> 客户端
-- 部队屯田时间
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyFarmmingTimeMsg = class("ArmyFarmmingTimeMsg", GameMessage);

--
-- 构造函数
--
function ArmyFarmmingTimeMsg:ctor()
    ArmyFarmmingTimeMsg.super.ctor(self);
    --
    -- 部队屯田时间
    --
    self.farmmingTime = 0;
end

--@Override
function ArmyFarmmingTimeMsg:_OnSerial() 
    self:WriteInt64(self.farmmingTime);
end

--@Override
function ArmyFarmmingTimeMsg:_OnDeserialize() 
    self.farmmingTime = self:ReadInt64();
end

return ArmyFarmmingTimeMsg;
