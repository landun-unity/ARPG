--[[
  部队屯田状态请求
--]]
local GameMessage = require("common/Net/GameMessage");
local ArmyStateRequest = class("ArmyStateRequest",GameMessage);

function ArmyStateRequest:ctor()

  -- 建筑物
  self.buildingId = 0;

  -- 部队编号
  self.index = 0;

  ArmyStateRequest.super.ctor(self);

end

-- @override
function ArmyStateRequest:_OnSerial()
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);
end

-- @override
function ArmyStateRequest:_OnDeserialize()
   self.buildingId = self:ReadInt64();
   self.index = self:ReadInt32();
end

return ArmyStateRequest;









