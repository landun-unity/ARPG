local BaseState = require("Game/State/BaseState")
local SyncRevenueInfo = class("SyncRevenueInfo", BaseState)

-- 构造函数
function SyncRevenueInfo:ctor(...)
    SyncRevenueInfo.super.ctor(self, ...);
end

function SyncRevenueInfo:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Player/InternalInfo").new()
    msg:SetMessageId(C2L_Player.InternalInfo)
    NetService:Instance():SendMessage(msg);
end


function SyncRevenueInfo:CanEnterState(stateType)
    if stateType == LoginStateType.RequestOccupyWildCity then
        return true;
    end
    
    return false;
end


function SyncRevenueInfo:OnLeaveState(...)
end

return SyncRevenueInfo;
