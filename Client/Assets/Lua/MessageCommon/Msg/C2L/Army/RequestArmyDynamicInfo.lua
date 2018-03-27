--
-- 客户端 --> 逻辑服务器
-- 请求部队动态信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestArmyDynamicInfo = class("RequestArmyDynamicInfo", GameMessage);

--
-- 构造函数
--
function RequestArmyDynamicInfo:ctor()
    RequestArmyDynamicInfo.super.ctor(self);
    --
    -- 请求类型
    --
    self.requestType = 0;
end

--@Override
function RequestArmyDynamicInfo:_OnSerial() 
    self:WriteInt32(self.requestType);
end

--@Override
function RequestArmyDynamicInfo:_OnDeserialize() 
    self.requestType = self:ReadInt32();
end

return RequestArmyDynamicInfo;
