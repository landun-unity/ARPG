
local BaseState = require("Game/State/BaseState")

local RequestOccupyWildCity = class("RequestOccupyWildCity", BaseState)

-- 构造函数
function RequestOccupyWildCity:ctor(...)
    RequestOccupyWildCity.super.ctor(self, ...);
end

-- 进入操作
function RequestOccupyWildCity:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Building/RequestOccupyWildCity").new()
    msg:SetMessageId(C2L_Building.RequestOccupyWildCity)
    NetService:Instance():SendMessage(msg)
end


function RequestOccupyWildCity:CanEnterState(stateType)
    if stateType == LoginStateType.RequestWordTendencyInfo then
        return true;
    end
    
    return false;
end

-- 离开操作
function RequestOccupyWildCity:OnLeaveState(...)
end

return RequestOccupyWildCity;
