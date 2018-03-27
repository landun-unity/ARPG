--
-- 逻辑服务器 --> 客户端
-- 同步线信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local HeroCardConscriptRespond = class("HeroCardConscriptRespond", GameMessage);

--
-- 构造函数
--
function HeroCardConscriptRespond:ctor()
    HeroCardConscriptRespond.super.ctor(self);
    --
    -- 建筑物id
    --
    self.bulidintId = 0;
    
    --
    -- 部队index
    --
    self.index = 0;
    
    --
    -- 部队位置
    --
    self.slotType = 0;
    
    --
    -- 兵力
    --
    self.num = 0;
    
    --
    -- 征兵结束时间
    --
    self.overTime = 0;
end

--@Override
function HeroCardConscriptRespond:_OnSerial() 
    self:WriteInt64(self.bulidintId);
    self:WriteInt32(self.index);
    self:WriteInt32(self.slotType);
    self:WriteInt32(self.num);
    self:WriteInt64(self.overTime);
end

--@Override
function HeroCardConscriptRespond:_OnDeserialize() 
    self.bulidintId = self:ReadInt64();
    self.index = self:ReadInt32();
    self.slotType = self:ReadInt32();
    self.num = self:ReadInt32();
    self.overTime = self:ReadInt64();
end

return HeroCardConscriptRespond;
