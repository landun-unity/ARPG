--
-- 客户端 --> 逻辑服务器
-- 取消放弃分城
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local CancelRemoveSubCityRequest = class("CancelRemoveSubCityRequest", GameMessage);

--
-- 构造函数
--
function CancelRemoveSubCityRequest:ctor()
    CancelRemoveSubCityRequest.super.ctor(self);
    --
    -- 建筑物id
    --
    self.buildingID = 0;
end

--@Override
function CancelRemoveSubCityRequest:_OnSerial() 
    self:WriteInt64(self.buildingID);
end

--@Override
function CancelRemoveSubCityRequest:_OnDeserialize() 
    self.buildingID = self:ReadInt64();
end

return CancelRemoveSubCityRequest;
