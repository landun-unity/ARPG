--
-- 逻辑服务器 --> 客户端
-- 升级设施回复
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local UpgradeFacilityRespond = class("UpgradeFacilityRespond", GameMessage);

--
-- 构造函数
--
function UpgradeFacilityRespond:ctor()
    UpgradeFacilityRespond.super.ctor(self);
    --
    -- 建筑物id
    --
    self.buildingId = 0;
    
    --
    -- 设施id
    --
    self.id = 0;
    
    --
    -- 设施等级
    --
    self.level = 0;
    
    --
    -- 下次升级时间
    --
    self.upgradeTime = 0;
end

--@Override
function UpgradeFacilityRespond:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt64(self.id);
    self:WriteInt32(self.level);
    self:WriteInt64(self.upgradeTime);
end

--@Override
function UpgradeFacilityRespond:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.id = self:ReadInt64();
    self.level = self:ReadInt32();
    self.upgradeTime = self:ReadInt64();
end

return UpgradeFacilityRespond;
