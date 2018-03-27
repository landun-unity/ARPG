  --[[部队撤退]]
local GameMessage = require("common/Net/GameMessage");
local ArmyRetreatingMsg = class("ArmyRetreatingMsg",GameMessage);

function ArmyRetreatingMsg:ctor()

  -- 建筑物id
  self.buildingId = 0;
    -- 部队编号
  self.index = 0;

  ArmyRetreatingMsg.super.ctor(self);

end

  -- @override
function ArmyRetreatingMsg:_OnSerial()
    self:WriteInt64(self.buildingId);
    self:WriteInt32(self.index);

end

  -- @override
function ArmyRetreatingMsg:_OnDeserialize()
   self.buildingId = self:ReadInt64();
   self.index = self:ReadInt32();

end

return ArmyRetreatingMsg;
