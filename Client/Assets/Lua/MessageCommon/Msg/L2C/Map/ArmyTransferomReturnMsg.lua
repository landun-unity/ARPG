--[[
	调动消息回复
--]]

local GameMessage = require("common/Net/GameMessage");

local ArmyTransferomReturnMsg = class("ArmyTransferomReturnMsg", GameMessage);


function ArmyTransferomReturnMsg:ctor()
    -- 玩家id
    self.playerId = 0;
    ArmyTransferomReturnMsg.super.ctor(self);

end




-- @override
function ArmyTransferomReturnMsg:_OnSerial()

    self:WriteInt64(self.playerId);
end


-- @override
function ArmyTransferomReturnMsg:_OnDeserialize()

    self.playerId = self:ReadInt64();

end

return ArmyTransferomReturnMsg;


