--
-- 逻辑服务器 --> 客户端
-- 请求玩家所有的充值信息回复
-- @author czx
--
local List = require("common/List");

local RechargeInfoItem = require("MessageCommon/Msg/L2C/Recharge/RechargeInfoItem");

local GameMessage = require("common/Net/GameMessage");
local RechargeInfoResponse = class("RechargeInfoResponse", GameMessage);

--
-- 构造函数
--
function RechargeInfoResponse:ctor()
    RechargeInfoResponse.super.ctor(self);
    --
    -- 各档次充值信息
    --
    self.allRechargeInfoList = List.new();
end

--@Override
function RechargeInfoResponse:_OnSerial() 
    
    local allRechargeInfoListCount = self.allRechargeInfoList:Count();
    self:WriteInt32(allRechargeInfoListCount);
    for allRechargeInfoListIndex = 1, allRechargeInfoListCount, 1 do 
        local allRechargeInfoListValue = self.allRechargeInfoList:Get(allRechargeInfoListIndex);
        
        self:WriteInt32(allRechargeInfoListValue.rechargeId);
        self:WriteInt32(allRechargeInfoListValue.firstRecharge);
        self:WriteInt64(allRechargeInfoListValue.lastGetTime);
        self:WriteInt64(allRechargeInfoListValue.monthCardEndTime);
    end
end

--@Override
function RechargeInfoResponse:_OnDeserialize() 
    
    local allRechargeInfoListCount = self:ReadInt32();
    for i = 1, allRechargeInfoListCount, 1 do 
        local allRechargeInfoListValue = RechargeInfoItem.new();
        allRechargeInfoListValue.rechargeId = self:ReadInt32();
        allRechargeInfoListValue.firstRecharge = self:ReadInt32();
        allRechargeInfoListValue.lastGetTime = self:ReadInt64();
        allRechargeInfoListValue.monthCardEndTime = self:ReadInt64();
        self.allRechargeInfoList:Push(allRechargeInfoListValue);
    end
end

return RechargeInfoResponse;
