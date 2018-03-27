--
-- 客户端 --> 逻辑服务器
-- 遗忘技能
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ForGetSkill = class("ForGetSkill", GameMessage);

--
-- 构造函数
--
function ForGetSkill:ctor()
    ForGetSkill.super.ctor(self);
    --
    -- 卡牌Id
    --
    self.cardId = 0;
    
    --
    -- 技能槽位
    --
    self.skillSlot = 0;
    
    --
    -- 技能Id
    --
    self.skillID = 0;
end

--@Override
function ForGetSkill:_OnSerial() 
    self:WriteInt64(self.cardId);
    self:WriteInt32(self.skillSlot);
    self:WriteInt64(self.skillID);
end

--@Override
function ForGetSkill:_OnDeserialize() 
    self.cardId = self:ReadInt64();
    self.skillSlot = self:ReadInt32();
    self.skillID = self:ReadInt64();
end

return ForGetSkill;
