-- 请求部队信息
local BaseState = require("Game/State/BaseState")

local RequestSyncCreateFortTime = class("RequestSyncCreateFortTime", BaseState)

-- 构造函数
function RequestSyncCreateFortTime:ctor(...)
    RequestSyncCreateFortTime.super.ctor(self, ...);
end

-- 进入操作
function RequestSyncCreateFortTime:OnEnterState()
    local msg = require("MessageCommon/Msg/C2L/Building/SyncCreateFortTime").new();
    msg:SetMessageId(C2L_Building.SyncCreateFortTime);
    NetService:Instance():SendMessage(msg);
end

function RequestSyncCreateFortTime:CanEnterState(stateType)
    if stateType == LoginStateType.RequestCardInfo then
        return true;
    end
    return false;
end

-- 离开操作
function RequestSyncCreateFortTime:OnLeaveState()
end


return RequestSyncCreateFortTime;
