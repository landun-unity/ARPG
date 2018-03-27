
local GameMessage = require("common/Net/GameMessage")

local SkillMsgModel = require("MessageCommon/Msg/L2C/Model/SkillMsgModel")

local DeleteSkillInfoRespond = class("DeleteSkillInfoRespond", GameMessage)
   
function DeleteSkillInfoRespond:ctor()
    self._skillID = 0;
end

function DeleteSkillInfoRespond:_OnSerial()
	self:WriteInt64(self._skillID)
end

function DeleteSkillInfoRespond:_OnDeserialize()
    self._skillID = self:ReadInt64()
    print(self._skillID)
end

return DeleteSkillInfoRespond;