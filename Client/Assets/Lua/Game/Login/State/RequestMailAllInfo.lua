-- 请求充值信息
local BaseState = require("Game/State/BaseState")

local RequestMailAllInfo = class("RequestMailAllInfo", BaseState)

-- 构造函数
function RequestMailAllInfo:ctor(...)
    RequestMailAllInfo.super.ctor(self, ...);
end

-- 进入操作
function RequestMailAllInfo:OnEnterState()
    --print("进入游戏发送请求邮箱信息消息"); 	 	 
    local msg = require("MessageCommon/Msg/C2L/Mail/RequestMailInfo").new();
    msg:SetMessageId(C2L_Mail.RequestMailInfo);
    NetService:Instance():SendMessage(msg);
end

function RequestMailAllInfo:CanEnterState(stateType)
    if stateType == LoginStateType.SyncMarkerInfos or stateType == LoginStateType.JoinChannel then
        return true;
    end
    
    return false;
end

-- 离开操作
function RequestMailAllInfo:OnLeaveState(...)
end

return RequestMailAllInfo;
