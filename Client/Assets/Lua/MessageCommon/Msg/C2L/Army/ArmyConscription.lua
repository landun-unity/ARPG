--
-- 客户端 --> 逻辑服务器
-- 部队征兵
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local ArmyConscription = class("ArmyConscription", GameMessage);

--
-- 构造函数
--
function ArmyConscription:ctor()
    ArmyConscription.super.ctor(self);
    --
    -- 玩家Id
    --
    self.playerId = 0;
    
    --
    -- 城市Id
    --
    self.cityBuliding = 0;
    
    --
    -- 部队索引
    --
    self.armyIndex = 0;
    
    --
    -- 大营征兵
    --
    self.backNum = 0;
    
    --
    -- 中军征兵
    --
    self.middleNum = 0;
    
    --
    -- 前锋征兵
    --
    self.frontNum = 0;
end

--@Override
function ArmyConscription:_OnSerial() 
    self:WriteInt64(self.playerId);
    self:WriteInt64(self.cityBuliding);
    self:WriteInt32(self.armyIndex);
    self:WriteInt32(self.backNum);
    self:WriteInt32(self.middleNum);
    self:WriteInt32(self.frontNum);
end

--@Override
function ArmyConscription:_OnDeserialize() 
    self.playerId = self:ReadInt64();
    self.cityBuliding = self:ReadInt64();
    self.armyIndex = self:ReadInt32();
    self.backNum = self:ReadInt32();
    self.middleNum = self:ReadInt32();
    self.frontNum = self:ReadInt32();
end

return ArmyConscription;
