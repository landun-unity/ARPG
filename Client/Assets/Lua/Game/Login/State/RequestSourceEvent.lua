-- 请求招募消息
local BaseState = require("Game/State/BaseState")

local RequestSourceEvent = class("RequestSourceEvent", BaseState)

-- 构造函数
function RequestSourceEvent:ctor(...)
    RequestSourceEvent.super.ctor(self, ...);
end

-- 进入操作
function RequestSourceEvent:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/SourceEvent/GetSourceEvent").new()
    msg:SetMessageId(C2L_SourceEvent.GetSourceEvent)
    NetService:Instance():SendMessage(msg)
end


function RequestSourceEvent:CanEnterState(stateType)
    if stateType == LoginStateType.RequestArmyInfo then
        return true;
    end
    return false;
end

-- 离开操作
function RequestSourceEvent:OnLeaveState(...)
end

return RequestSourceEvent;
