--[[
	出征消息回复
--]]

local GameMessage = require("common/Net/GameMessage");

local ArmyBattleReturnMsg = class("ArmyBattleReturnMsg", GameMessage);
   
function ArmyBattleReturnMsg:ctor()
    -- 玩家id
    self.playerId = 0;
    ArmyBattleReturnMsg.super.ctor(self);

end




-- @override
function ArmyBattleReturnMsg:_OnSerial()

    self:WriteInt64(self.playerId);
end


-- @override
function ArmyBattleReturnMsg:_OnDeserialize()

    self.playerId = self:ReadInt64();

end

return ArmyBattleReturnMsg;

