--
-- 逻辑服务器 --> 客户端
-- 删除技能
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local DeleteOneSkillRespond = class("DeleteOneSkillRespond", GameMessage);

--
-- 构造函数
--
function DeleteOneSkillRespond:ctor()
    DeleteOneSkillRespond.super.ctor(self);
    --
    -- 技能Id
    --
    self.id = 0;
end

--@Override
function DeleteOneSkillRespond:_OnSerial() 
    self:WriteInt64(self.id);
end

--@Override
function DeleteOneSkillRespond:_OnDeserialize() 
    self.id = self:ReadInt64();
end

return DeleteOneSkillRespond;
