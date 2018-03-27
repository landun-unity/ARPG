local BaseState = require("Game/State/BaseState")

local RequestLeagueInfo = class("RequestLeagueInfo", BaseState)

-- 构造函数
function RequestLeagueInfo:ctor(...)
    RequestLeagueInfo.super.ctor(self, ...);
end

-- 进入操作
function RequestLeagueInfo:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Player/RequestLeagueInfo").new()
    msg:SetMessageId(C2L_Player.RequestLeagueInfo)
    NetService:Instance():SendMessage(msg)
end


function RequestLeagueInfo:CanEnterState(stateType)
    if stateType == LoginStateType.RequestPlayerTiledInfo then
        return true;
    end
    return false;
end


-- 离开操作
function RequestLeagueInfo:OnLeaveState(...)
end

return RequestLeagueInfo;

