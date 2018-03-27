local GameService = require("FrameWork/Game/GameService")
local RechargeHandler = require("Game/Recharge/RechargeHandler")
local RechargeManage = require("Game/Recharge/RechargeManage");

RechargeService = class("RechargeService",GameService)

-- 构造函数
function RechargeService:ctor( )
    RechargeService._instance = self;
    RechargeService.super.ctor(self, RechargeManage.new(), RechargeHandler.new());
end

-- 单例
function RechargeService:Instance()
    return RechargeService._instance;
end

--清空数据
function RechargeService:Clear()
    self._logic:ctor()
end

function RechargeService:GetRechargeInfoItem(rechargeId)
   return self._logic:GetRechargeInfoItem(rechargeId);
end

function RechargeService:CheckInfoItemFirstRecharge(rechargeId)
   return self._logic:CheckInfoItemFirstRecharge(rechargeId);
end

function RechargeService:CheckMonthCardOpen()
   return self._logic:CheckMonthCardOpen();
end

function RechargeService:CheckCouldGetMonthCard()
   return self._logic:CheckCouldGetMonthCard();
end

function RechargeService:GetMonthCardRechargeInfo()
   return self._logic:GetMonthCardRechargeInfo();
end

function RechargeService:GetMonthCardleftTime(isDayTime)
   return self._logic:GetMonthCardleftTime(isDayTime);
end

return RechargeService
