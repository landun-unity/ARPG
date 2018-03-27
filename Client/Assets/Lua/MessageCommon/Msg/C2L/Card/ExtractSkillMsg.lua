--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


local GameMessage = require("common/Net/GameMessage");
local ExtractSkillMsg=class("ExtractSkillMsg",GameMessage);


function ExtractSkillMsg:ctor()
    
    self.skillID = 0;
    self.ExtractCardID = 0;
    ExtractSkillMsg.super.ctor(self);
end


-- @override
function ExtractSkillMsg:_OnSerial()
    self:WriteInt32(self.skillID);
    self:WriteInt64(self.ExtractCardID);
end


-- @override
function ExtractSkillMsg:_OnDeserialize()
   self.ExtractCardID =self:ReadInt64();
   self.skillID = self:ReadInt32();
end

return ExtractSkillMsg;


--endregion
