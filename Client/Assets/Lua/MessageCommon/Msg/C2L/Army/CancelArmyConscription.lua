--
-- 客户端 --> 逻辑服务器
-- 取消部队征兵
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CancelArmyConscription = class("CancelArmyConscription", GameMessage);

--
-- 构造函数
--
function CancelArmyConscription:ctor()
    CancelArmyConscription.super.ctor(self);
    --
    -- 城市Id
    --
    self.buliding = 0;
    
    --
    -- 部队索引
    --
    self.armyIndex = 0;
    
    --
    -- 位置征兵
    --
    self.slotType = 0;
end

--@Override
function CancelArmyConscription:_OnSerial() 
    self:WriteInt64(self.buliding);
    self:WriteInt32(self.armyIndex);
    self:WriteInt32(self.slotType);
end

--@Override
function CancelArmyConscription:_OnDeserialize() 
    self.buliding = self:ReadInt64();
    self.armyIndex = self:ReadInt32();
    self.slotType = self:ReadInt32();
end

return CancelArmyConscription;
