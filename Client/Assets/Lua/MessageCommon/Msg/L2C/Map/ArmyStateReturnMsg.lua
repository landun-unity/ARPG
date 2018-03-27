--[[
	部队状态请求回复消息
--]]

local GameMessage = require("common/Net/GameMessage");

local ArmyStateReturnMsg = class("ArmyStateReturnMsg", GameMessage);
   
function ArmyStateReturnMsg:ctor()
    -- 部队状态
    self.armyState = 0;
    ArmyStateReturnMsg.super.ctor(self);

end

-- @override
function ArmyStateReturnMsg:_OnSerial()

    self:WriteInt32(self.armyState);
end


-- @override
function ArmyStateReturnMsg:_OnDeserialize()

    self.armyState = self:ReadInt32();

end

return ArmyStateReturnMsg;

