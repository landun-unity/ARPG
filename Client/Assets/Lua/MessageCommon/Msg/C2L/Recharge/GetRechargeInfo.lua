--
-- 客户端 --> 逻辑服务器
-- 请求玩家的充值信息
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local GetRechargeInfo = class("GetRechargeInfo", GameMessage);

--
-- 构造函数
--
function GetRechargeInfo:ctor()
    GetRechargeInfo.super.ctor(self);
end

--@Override
function GetRechargeInfo:_OnSerial() 
end

--@Override
function GetRechargeInfo:_OnDeserialize() 
end

return GetRechargeInfo;
