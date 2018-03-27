--
-- 逻辑服务器 --> 客户端
-- 请求充值回复
-- @author czx
--
local RechargeInfoItem = require("MessageCommon/Msg/L2C/Recharge/RechargeInfoItem");

local GameMessage = require("common/Net/GameMessage");
local RechargeOnceResponse = class("RechargeOnceResponse", GameMessage);

--
-- 构造函数
--
function RechargeOnceResponse:ctor()
    RechargeOnceResponse.super.ctor(self);
    --
    -- 充值增加的玉数量
    --
    self.addCount = 0;
    
    --
    -- 单条充值信息
    --
    self.infoItemData = RechargeInfoItem.new();
end

--@Override
function RechargeOnceResponse:_OnSerial() 
    self:WriteInt32(self.addCount);
    self:WriteInt32(self.infoItemData.rechargeId);
    self:WriteInt32(self.infoItemData.firstRecharge);
    self:WriteInt64(self.infoItemData.lastGetTime);
    self:WriteInt64(self.infoItemData.monthCardEndTime);
end

--@Override
function RechargeOnceResponse:_OnDeserialize() 
    self.addCount = self:ReadInt32();
    self.infoItemData.rechargeId = self:ReadInt32();
    self.infoItemData.firstRecharge = self:ReadInt32();
    self.infoItemData.lastGetTime = self:ReadInt64();
    self.infoItemData.monthCardEndTime = self:ReadInt64();
end

return RechargeOnceResponse;
