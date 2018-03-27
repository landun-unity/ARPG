
local IOHandler = require("FrameWork/Game/IOHandler")
local RechargeHandler = class("RechargeHandler", IOHandler)
local DataRecharge = require("Game/Table/model/DataRecharge");

function RechargeHandler:ctor()

    RechargeHandler.super.ctor(self)

end

-- 注册
function RechargeHandler:RegisterAllMessage()
    self:RegisterMessage(L2C_Recharge.RechargeOnceResponse, self.GetRechargeOneResponse, require("MessageCommon/Msg/L2C/Recharge/RechargeOnceResponse"));
    self:RegisterMessage(L2C_Recharge.RechargeInfoResponse, self.GetRechargeAllInfoResponse, require("MessageCommon/Msg/L2C/Recharge/RechargeInfoResponse"));
    self:RegisterMessage(L2C_Recharge.GetMonthCardResponse, self.GetMonthCardResponse, require("MessageCommon/Msg/L2C/Recharge/GetMonthCardResponse"));
end

-- 领取月卡返回
function RechargeHandler:GetMonthCardResponse(msg)
    -- print("领取月卡返回  msg.addCount:  "..msg.addCount.."     msg.lastGetTime:"..msg.lastGetTime);
    self._logicManage:SaveGetMonthCardInfo(msg.lastGetTime);
    UIService:Instance():HideUI(UIType.RechargeGetMonthCardUI);
end

-- 所有充值信息返回
function RechargeHandler:GetRechargeAllInfoResponse(msg)
    LoginService:Instance():EnterState(LoginStateType.RequestMailInfo);
    LoginService:Instance():EnterState(LoginStateType.JoinChannel);
    local allInfoTable = { };
    for i = 1, msg.allRechargeInfoList:Count() do
        allInfoTable[i] = msg.allRechargeInfoList:Get(i);
    end
    self._logicManage:SaveAllRechargeInfo(allInfoTable);
    local baseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
    if baseClass ~= nil then
        baseClass:SetMonthCardInfo();
    end
end

-- 单次充值返回
function RechargeHandler:GetRechargeOneResponse(msg)
    -- 充值界面关闭
    local itemInfo = msg.infoItemData;
    self._logicManage:SaveRechargeInfo(itemInfo);
    local dataRecharge = DataRecharge[itemInfo.rechargeId];
    -- print(dataRecharge.Type.."   dataRecharge.ID"..dataRecharge.ID)
    if dataRecharge.Type == 1 then
        local baseClass = UIService:Instance():GetUIClass(UIType.UIGameMainView);
        if baseClass ~= nil then
            baseClass:SetMonthCardInfo();
        end
    end
    local baseClass = UIService:Instance():GetUIClass(UIType.RechargeUI);
    if baseClass ~= nil then
        baseClass:ShowRechargeItem();
    end
    UIService:Instance():HideUI(UIType.RechargeUI);
    if UIService.Instance():GetOpenedUI(UIType.UIMainCity) == false then
        UIService:Instance():ShowUI(UIType.UIGameMainView);
    end
    -- print("充值"..dataRecharge.Price.."成功！！！！！！！！！！ 获得玉符："..msg.addCount.."  现在的 玉符数量:"..PlayerService.Instance():GetCurrencyVarCalcByKey(CurrencyEnum.Jade):GetValue())
    GA.Pay(dataRecharge.Price, 1, msg.addCount);
end

return RechargeHandler
