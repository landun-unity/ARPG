--
-- 客户端 --> 逻辑服务器
-- 卡牌加点
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local OneCardAddPoint = class("OneCardAddPoint", GameMessage);

--
-- 构造函数
--
function OneCardAddPoint:ctor()
    OneCardAddPoint.super.ctor(self);
    --
    -- 卡牌ID
    --
    self.cardID = 0;
    
    --
    -- 攻击加的点数
    --
    self.attackCount = 0;
    
    --
    -- 防御加的点数
    --
    self.defenCount = 0;
    
    --
    -- 策略加的点数
    --
    self.strageCount = 0;
    
    --
    -- 速度加的点数
    --
    self.speedCount = 0;
end

--@Override
function OneCardAddPoint:_OnSerial() 
    self:WriteInt64(self.cardID);
    self:WriteInt32(self.attackCount);
    self:WriteInt32(self.defenCount);
    self:WriteInt32(self.strageCount);
    self:WriteInt32(self.speedCount);
end

--@Override
function OneCardAddPoint:_OnDeserialize() 
    self.cardID = self:ReadInt64();
    self.attackCount = self:ReadInt32();
    self.defenCount = self:ReadInt32();
    self.strageCount = self:ReadInt32();
    self.speedCount = self:ReadInt32();
end

return OneCardAddPoint;
