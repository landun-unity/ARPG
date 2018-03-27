-- 请求充值信息
local BaseState = require("Game/State/BaseState")

local RequestRechargeInformations = class("RequestRechargeInformations", BaseState)

-- 构造函数
function RequestRechargeInformations:ctor(...)
    RequestRechargeInformations.super.ctor(self, ...);
end

-- 进入操作
function RequestRechargeInformations:OnEnterState()
    --print("进入游戏发送请求充值信息消息"); 	 	 
    local msg = require("MessageCommon/Msg/C2L/Recharge/GetRechargeInfo").new();
    msg:SetMessageId(C2L_Recharge.GetRechargeInfo);
    NetService:Instance():SendMessage(msg);
end

function RequestRechargeInformations:CanEnterState(stateType)
    if stateType == LoginStateType.RequestMailInfo then
        return true;
    end
    
    return false;
end


-- 离开操作
function RequestRechargeInformations:OnLeaveState(...)
end

return RequestRechargeInformations;
