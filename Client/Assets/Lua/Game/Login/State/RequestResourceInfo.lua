-- 登录消息处理
local BaseState = require("Game/State/BaseState")

local RequestResourceInfo = class("RequestResourceInfo", BaseState)

-- 构造函数
function RequestResourceInfo:ctor(...)
    RequestResourceInfo.super.ctor(self, ...);
end

-- 进入操作
function RequestResourceInfo:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Player/RequestResourceInfo").new()
    msg:SetMessageId(C2L_Player.RequestResourceInfo)
    NetService:Instance():SendMessage(msg)
end

-- 离开操作
function RequestResourceInfo:OnLeaveState(...)
end

-- 请求资源之后必须进请求金钱
function RequestResourceInfo:CanEnterState(stateType)
    if stateType == LoginStateType.RequestCurrencyInfo then
        return true;
    end
    
    return false;
end

return RequestResourceInfo;
