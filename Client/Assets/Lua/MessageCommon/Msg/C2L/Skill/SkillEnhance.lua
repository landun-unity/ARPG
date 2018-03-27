--
-- 客户端 --> 逻辑服务器
-- 技能强化
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local SkillEnhance = class("SkillEnhance", GameMessage);

--
-- 构造函数
--
function SkillEnhance:ctor()
    SkillEnhance.super.ctor(self);
    --
    -- 卡牌Id
    --
    self.cardId = 0;
    
    --
    -- 技能索引
    --
    self.skillSlot = 0;
end

--@Override
function SkillEnhance:_OnSerial() 
    self:WriteInt64(self.cardId);
    self:WriteInt32(self.skillSlot);
end

--@Override
function SkillEnhance:_OnDeserialize() 
    self.cardId = self:ReadInt64();
    self.skillSlot = self:ReadInt32();
end

return SkillEnhance;
