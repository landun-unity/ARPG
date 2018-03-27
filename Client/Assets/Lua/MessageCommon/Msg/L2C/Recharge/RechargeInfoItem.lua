--
-- 逻辑服务器 --> 客户端
-- 玩家条充值信息消息体
-- @author czx
--
local RechargeInfoItem = class("RechargeInfoItem");

function RechargeInfoItem:ctor()
    --
    -- 充值ID
    --
    self.rechargeId = 0;
    
    --
    -- 是否第一次充值该ID的档次
    --
    self.firstRecharge = 0;
    
    --
    -- 上次领奖的时间（月卡才有）
    --
    self.lastGetTime = 0;
    
    --
    -- 月卡结束时间（月卡才有）
    --
    self.monthCardEndTime = 0;
end

return RechargeInfoItem;
