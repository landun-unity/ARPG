--[[
	驻守消息回复
--]]

local GameMessage = require("common/Net/GameMessage");

local ArmyGarrisonReturnMsg = class("ArmyGarrisonReturnMsg", GameMessage);


function ArmyGarrisonReturnMsg:ctor()
    -- 玩家id
    self.playerId = 0;
    ArmyGarrisonReturnMsg.super.ctor(self);

end




-- @override
function ArmyGarrisonReturnMsg:_OnSerial()

    self:WriteInt64(self.playerId);
end


-- @override
function ArmyGarrisonReturnMsg:_OnDeserialize()

    self.playerId = self:ReadInt64();

end

return ArmyGarrisonReturnMsg;



