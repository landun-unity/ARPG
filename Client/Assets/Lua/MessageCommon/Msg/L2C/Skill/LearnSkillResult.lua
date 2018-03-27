--
-- 逻辑服务器 --> 客户端
-- 技能学习结果
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local LearnSkillResult = class("LearnSkillResult", GameMessage);

--
-- 构造函数
--
function LearnSkillResult:ctor()
    LearnSkillResult.super.ctor(self);
    --
    -- 结果
    --
    self.result = false;
end

--@Override
function LearnSkillResult:_OnSerial() 
    self:WriteBoolean(self.result);
end

--@Override
function LearnSkillResult:_OnDeserialize() 
    self.result = self:ReadBoolean();
end

return LearnSkillResult;
