-- region *.lua

local GameMessage = require("common/Net/GameMessage");

local OnePlayerAddOneCardRespond = class("OnePlayerAddOneCardRespond", GameMessage);
   
function OnePlayerAddOneCardRespond:ctor()
    -- 玩家id
    self.iD = nil
    self._tableID = nil
    self._exp = nil
    self._level = nil
    self.advancedTime = nil
    self.power = nil
    self.troop = nil
    self.point = nil
    self.attacktPoint = nil
    self.defensePoint = nil
    self.strategyPoint = nil
    self.speedPoint = nil
    self.isProtect = nil
    self.isAwaken = nil
    self.skillIDOne = nil
    self.SkillOneLevel = nil
    self.SkillTwoID = nil
    self.SkillTwoLevel = nil
    self.SkillThreeID = nil
    self.SkillThreeLevel = nil
end

-- @override
function OnePlayerAddOneCardRespond:_OnSerial()
    self:WriteInt64(self.iD);
    self:WriteInt32(self._tableID);
    self:WriteInt64(self._exp);
    self:WriteInt32(self._level);
    self:WriteInt32(self.advancedTime);
    self:WriteInt32(self.power);
    self:WriteInt32(self.troop);
    self:WriteInt32(self.point);
    self:WriteInt32(self.attacktPoint);
    self:WriteInt32(self.defensePoint);
    self:WriteInt32(self.strategyPoint);
    self:WriteInt32(self.speedPoint);
    self:WriteBoolean(self.isProtect);
    self:WriteBoolean(self.isAwaken);
    self:WriteInt32(self.skillIDOne);
    self:WriteInt32(self.SkillOneLevel);
    self:WriteInt32(self.SkillTwoID);
    self:WriteInt32(self.SkillTwoLevel);
    self:WriteInt32(self.SkillThreeID);
    self:WriteInt32(self.SkillThreeLevel);

end


-- @override
function OnePlayerAddOneCardRespond:_OnDeserialize()

    self.iD = self:ReadInt64();
    self._tableID = self:ReadInt32();
    self._exp = self:ReadInt64();
    self._level = self:ReadInt32();
    self.advancedTime = self:ReadInt32();
    self.power = self:ReadInt32();
    self.troop = self:ReadInt32();
    self.point = self:ReadInt32();
    self.attacktPoint = self:ReadInt32();
    self.defensePoint = self:ReadInt32();
    self.strategyPoint = self:ReadInt32();
    self.speedPoint = self:ReadInt32();
    self.isProtect = self:ReadBoolean();
    self.isAwaken = self:ReadBoolean();
    self.skillIDOne = self:ReadInt32();
    self.SkillOneLevel = self:ReadInt32();
    self.SkillTwoID = self:ReadInt32();
    self.SkillTwoLevel = self:ReadInt32();
    self.SkillThreeID = self:ReadInt32();
    self.SkillThreeLevel = self:ReadInt32();

end

return OnePlayerAddOneCardRespond;

-- endregion




