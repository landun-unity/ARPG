--[[
	练兵消息回复
--]]

local GameMessage = require("common/Net/GameMessage");

local ArmyTrainingReturnMsg = class("ArmyTrainingReturnMsg", GameMessage);


function ArmyTrainingReturnMsg:ctor()
    -- 玩家id
    self.playerId = 0;
    ArmyTrainingReturnMsg.super.ctor(self);

end




-- @override
function ArmyTrainingReturnMsg:_OnSerial()

    self:WriteInt64(self.playerId);
end


-- @override
function ArmyTrainingReturnMsg:_OnDeserialize()

    self.playerId = self:ReadInt64();

end

return ArmyTrainingReturnMsg;


