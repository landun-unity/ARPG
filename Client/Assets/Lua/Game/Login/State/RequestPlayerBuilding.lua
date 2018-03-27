
local BaseState = require("Game/State/BaseState")

local RequestPlayerBuilding = class("RequestPlayerBuilding", BaseState)

-- 构造函数
function RequestPlayerBuilding:ctor(...)
    RequestPlayerBuilding.super.ctor(self, ...);
end

-- 进入操作
function RequestPlayerBuilding:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Player/RequestPlayerBuilding").new()
    msg:SetMessageId(C2L_Player.RequestPlayerBuilding)
    NetService:Instance():SendMessage(msg)
end

function RequestPlayerBuilding:CanEnterState(stateType)
    if stateType == LoginStateType.OpenOwnWildBuildRequest then
        return true;
    end
    
    return false;
end



-- 离开操作
function RequestPlayerBuilding:OnLeaveState(...)
end

return RequestPlayerBuilding;
