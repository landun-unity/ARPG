--
-- 客户端 --> 逻辑服务器
-- 请求充值
-- @author czx
--
local GameMessage = require("common/Net/GameMessage");
local RechargeOnce = class("RechargeOnce", GameMessage);

--
-- 构造函数
--
function RechargeOnce:ctor()
    RechargeOnce.super.ctor(self);
    --
    -- 充值ID
    --
    self.rechargeId = 0;
end

--@Override
function RechargeOnce:_OnSerial() 
    self:WriteInt32(self.rechargeId);
end

--@Override
function RechargeOnce:_OnDeserialize() 
    self.rechargeId = self:ReadInt32();
end

return RechargeOnce;
