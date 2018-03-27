--[[
	扫荡消息回复
--]]

local GameMessage = require("common/Net/GameMessage");

local ArmySweepReturnMsg = class("ArmySweepReturnMsg", GameMessage);


function ArmySweepReturnMsg:ctor()
    -- 玩家id
    self.playerId = 0;
    ArmySweepReturnMsg.super.ctor(self);

end




-- @override
function ArmySweepReturnMsg:_OnSerial()

    self:WriteInt64(self.playerId);
end


-- @override
function ArmySweepReturnMsg:_OnDeserialize()

    self.playerId = self:ReadInt64();

end

return ArmySweepReturnMsg;



