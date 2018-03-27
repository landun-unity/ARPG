local BaseState = require("Game/State/BaseState")
local RequestPlayerTiledInfo = class("RequestPlayerTiledInfo", BaseState)

-- 构造函数
function RequestPlayerTiledInfo:ctor(...)
    RequestPlayerTiledInfo.super.ctor(self, ...);
end

function RequestPlayerTiledInfo:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Player/RequestPlayerAllTiledInfo").new()
    msg:SetMessageId(C2L_Player.RequestPlayerAllTiledInfo)
    NetService:Instance():SendMessage(msg);
end

function RequestPlayerTiledInfo:CanEnterState(stateType)
    if stateType == LoginStateType.RequestPlayerInfluence then
        return true;
    end
    
    return false;
end


function RequestPlayerTiledInfo:OnLeaveState(...)
end

return RequestPlayerTiledInfo;