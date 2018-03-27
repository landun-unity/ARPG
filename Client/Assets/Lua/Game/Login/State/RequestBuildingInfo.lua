-- 请求技能信息
local BaseState = require("Game/State/BaseState")

local RequestBuildingInfo = class("RequestBuildingInfo", BaseState)

-- 构造函数
function RequestBuildingInfo:ctor(...)
    RequestBuildingInfo.super.ctor(self, ...);
end

-- 进入操作
function RequestBuildingInfo:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Building/RequestBuildingInfo").new()
    msg:SetMessageId(C2L_Building.RequestBuildingInfo)
    --print("RequestBuildingInfo")
    NetService:Instance():SendMessage(msg);
end

function RequestBuildingInfo:CanEnterState(stateType)
    if stateType == LoginStateType.RequestSyncCreateFortTime then
        return true;
    end
    return false;
end


-- 离开操作
function RequestBuildingInfo:OnLeaveState(...)
end

return RequestBuildingInfo;
