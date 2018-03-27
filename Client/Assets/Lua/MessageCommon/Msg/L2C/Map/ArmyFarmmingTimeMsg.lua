--[[
	部队屯田时间
--]]

local GameMessage = require("common/Net/GameMessage");

local ArmyFarmmingTimeMsg = class("ArmyFarmmingTimeMsg", GameMessage);
   
function ArmyFarmmingTimeMsg:ctor()
    -- 玩家id
    self.marchTime = 0;
    ArmyFarmmingTimeMsg.super.ctor(self);

end

-- @override
function ArmyFarmmingTimeMsg:_OnSerial()

    self:WriteInt64(self.marchTime);
end


-- @override
function ArmyFarmmingTimeMsg:_OnDeserialize()

    self.marchTime = self:ReadInt64();

end

return ArmyFarmmingTimeMsg;

