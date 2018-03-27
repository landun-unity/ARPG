-- 登录消息处理
local BaseState = require("Game/State/BaseState")

local RequestPlayerInfo = class("RequestPlayerInfo", BaseState)

-- 构造函数
function RequestPlayerInfo:ctor(...)
    RequestPlayerInfo.super.ctor(self, ...);
end

-- 进入操作
function RequestPlayerInfo:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Player/RequestPlayerInfo").new()
    msg:SetMessageId(C2L_Player.RequestPlayerInfo)
    NetService:Instance():SendMessage(msg);
end

-- 请求后请求玩家建筑物信息
function RequestPlayerInfo:CanEnterState(stateType)
    if stateType == LoginStateType.RequestPlayerBuilding then
        return true;
    end
    
    return false;
end

-- 离开操作
function RequestPlayerInfo:OnLeaveState(...)
end

return RequestPlayerInfo;
