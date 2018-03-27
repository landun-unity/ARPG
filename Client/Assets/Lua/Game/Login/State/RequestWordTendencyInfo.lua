---- 请求天下大试消息
local BaseState = require("Game/State/BaseState")

local RequestWordTendencyInfo = class("RequestWordTendencyInfo", BaseState)

-- 构造函数
function RequestWordTendencyInfo:ctor(...)
    RequestWordTendencyInfo.super.ctor(self, ...);
end

-- 进入操作
function RequestWordTendencyInfo:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/WorldTendency/RequestWordTendencyInfo").new()
    msg:SetMessageId(C2L_WorldTendency.RequestWordTendencyInfo)
    NetService:Instance():SendMessage(msg)
end


function RequestWordTendencyInfo:CanEnterState(stateType)
print("LoginStateType.CreateMap")
    if stateType == LoginStateType.CreateMap then
        return true;
    end
    return false;
end


-- 离开操作
function RequestWordTendencyInfo:OnLeaveState(...)
end

return RequestWordTendencyInfo;
