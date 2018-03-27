--[[
	屯田消息回复
--]]

local GameMessage = require("common/Net/GameMessage");

local ArmyFarmmingReturnMsg = class("ArmyFarmmingReturnMsg", GameMessage);


function ArmyFarmmingReturnMsg:ctor()
    -- 玩家id
    self.playerId = 0;
    ArmyFarmmingReturnMsg.super.ctor(self);

end




-- @override
function ArmyFarmmingReturnMsg:_OnSerial()

    self:WriteInt64(self.playerId);
end


-- @override
function ArmyFarmmingReturnMsg:_OnDeserialize()

    self.playerId = self:ReadInt64();

end

return ArmyFarmmingReturnMsg;


