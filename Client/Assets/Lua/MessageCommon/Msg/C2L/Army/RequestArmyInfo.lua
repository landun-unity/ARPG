--
-- 客户端 --> 逻辑服务器
-- 请求部队信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RequestArmyInfo = class("RequestArmyInfo", GameMessage);

--
-- 构造函数
--
function RequestArmyInfo:ctor()
    RequestArmyInfo.super.ctor(self);
end

--@Override
function RequestArmyInfo:_OnSerial() 
end

--@Override
function RequestArmyInfo:_OnDeserialize() 
end

return RequestArmyInfo;
