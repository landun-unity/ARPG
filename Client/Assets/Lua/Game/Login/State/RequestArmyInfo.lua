-- 请求部队信息
local BaseState = require("Game/State/BaseState")

local RequestArmyInfo = class("RequestArmyInfo", BaseState)

-- 构造函数
function RequestArmyInfo:ctor(...)
    RequestArmyInfo.super.ctor(self, ...);
end

-- 进入操作
function RequestArmyInfo:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Army/RequestArmyInfo").new()
    msg:SetMessageId(C2L_Army.RequestArmyInfo)
    NetService:Instance():SendMessage(msg);
end
function RequestArmyInfo:CanEnterState(stateType)
    if stateType == LoginStateType.OpenCityFacility then
        return true;
    end
    return false;
end
-- 离开操作
function RequestArmyInfo:OnLeaveState(...)
end

return RequestArmyInfo;
