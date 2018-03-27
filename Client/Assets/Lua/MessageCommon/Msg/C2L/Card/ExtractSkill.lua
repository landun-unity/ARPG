--
-- 客户端 --> 逻辑服务器
-- 卡牌拆解技能
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ExtractSkill = class("ExtractSkill", GameMessage);

--
-- 构造函数
--
function ExtractSkill:ctor()
    ExtractSkill.super.ctor(self);
    --
    -- 拆解的卡牌ID
    --
    self.extractCardID = 0;
    
    --
    -- 要拆解的技能ID
    --
    self.skillID = 0;
end

--@Override
function ExtractSkill:_OnSerial() 
    self:WriteInt64(self.extractCardID);
    self:WriteInt32(self.skillID);
end

--@Override
function ExtractSkill:_OnDeserialize() 
    self.extractCardID = self:ReadInt64();
    self.skillID = self:ReadInt32();
end

return ExtractSkill;
