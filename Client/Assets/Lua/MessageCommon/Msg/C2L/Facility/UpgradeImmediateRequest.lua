--
-- 客户端 --> 逻辑服务器
-- 立即升级设施
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local UpgradeImmediateRequest = class("UpgradeImmediateRequest", GameMessage);

--
-- 构造函数
--
function UpgradeImmediateRequest:ctor()
    UpgradeImmediateRequest.super.ctor(self);
    --
    -- 建筑物id
    --
    self.buildingId = 0;
    
    --
    -- 设施id
    --
    self.facilityId = 0;
end

--@Override
function UpgradeImmediateRequest:_OnSerial() 
    self:WriteInt64(self.buildingId);
    self:WriteInt64(self.facilityId);
end

--@Override
function UpgradeImmediateRequest:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
    self.facilityId = self:ReadInt64();
end

return UpgradeImmediateRequest;
