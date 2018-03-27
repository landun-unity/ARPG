local BaseState = require("Game/State/BaseState")
local RequestTiledIdInfo = class("RequestTiledIdInfo", BaseState)

-- 构造函数
function RequestTiledIdInfo:ctor(...)
    RequestTiledIdInfo.super.ctor(self, ...);
end

function RequestTiledIdInfo:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Player/RequestTiledIdInfo").new()
    msg:SetMessageId(C2L_Player.RequestTiledIdInfo)
    NetService:Instance():SendMessage(msg);
end

function RequestTiledIdInfo:CanEnterState(stateType)
    if stateType == LoginStateType.RequestRevenueIdInfo then
        return true;
    end
    
    return false;
end


function RequestTiledIdInfo:OnLeaveState(...)
end

return RequestTiledIdInfo;
