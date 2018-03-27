--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GameMessage = require("common/Net/GameMessage");

local ExtractSkillSucess = class("ExtractSkillSucess", GameMessage);
   
function ExtractSkillSucess:ctor()


    ExtractSkillSucess.super.ctor(self);

end




-- @override
function ExtractSkillSucess:_OnSerial()
  
end


-- @override
function ExtractSkillSucess:_OnDeserialize()
   
end

return ExtractSkillSucess;

--endregion
