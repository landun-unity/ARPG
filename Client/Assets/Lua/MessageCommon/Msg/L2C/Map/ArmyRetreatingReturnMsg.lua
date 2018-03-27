--[[
	撤退消息回复
--]]

local GameMessage = require("common/Net/GameMessage");

local ArmyRetreatingReturnMsg = class("ArmyRetreatingReturnMsg", GameMessage);
   
function ArmyRetreatingReturnMsg:ctor()
    -- 玩家id
    self.playerId = 0;
    ArmyRetreatingReturnMsg.super.ctor(self);

end




-- @override
function ArmyRetreatingReturnMsg:_OnSerial()

    self:WriteInt64(self.playerId);
end


-- @override
function ArmyRetreatingReturnMsg:_OnDeserialize()

    self.playerId = self:ReadInt64();

end

return ArmyRetreatingReturnMsg;

