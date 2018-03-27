--
-- 逻辑服务器 --> 客户端
-- 强化结果
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SkillEnhanceResult = class("SkillEnhanceResult", GameMessage);

--
-- 构造函数
--
function SkillEnhanceResult:ctor()
    SkillEnhanceResult.super.ctor(self);
    --
    -- 结果
    --
    self.result = false;
end

--@Override
function SkillEnhanceResult:_OnSerial() 
    self:WriteBoolean(self.result);
end

--@Override
function SkillEnhanceResult:_OnDeserialize() 
    self.result = self:ReadBoolean();
end

return SkillEnhanceResult;
