--
-- 客户端 --> 逻辑服务器
-- 要塞升级请求
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local UpgradeRequest = class("UpgradeRequest", GameMessage);

--
-- 构造函数
--
function UpgradeRequest:ctor()
    UpgradeRequest.super.ctor(self);
    --
    -- 建筑物ID
    --
    self.buildingId = 0;
end

--@Override
function UpgradeRequest:_OnSerial() 
    self:WriteInt64(self.buildingId);
end

--@Override
function UpgradeRequest:_OnDeserialize() 
    self.buildingId = self:ReadInt64();
end

return UpgradeRequest;
