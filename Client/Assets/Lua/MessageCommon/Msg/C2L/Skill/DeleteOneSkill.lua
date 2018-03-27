--
-- 客户端 --> 逻辑服务器
-- 删除技能
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local DeleteOneSkill = class("DeleteOneSkill", GameMessage);

--
-- 构造函数
--
function DeleteOneSkill:ctor()
    DeleteOneSkill.super.ctor(self);
    --
    -- 技能Id
    --
    self.skillID = 0;
end

--@Override
function DeleteOneSkill:_OnSerial() 
    self:WriteInt64(self.skillID);
end

--@Override
function DeleteOneSkill:_OnDeserialize() 
    self.skillID = self:ReadInt64();
end

return DeleteOneSkill;
