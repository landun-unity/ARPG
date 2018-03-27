-- 请求标记信息
local BaseState = require("Game/State/BaseState")

local SyncMarkerInfos = class("SyncMarkerInfos", BaseState)

-- 构造函数
function SyncMarkerInfos:ctor(...)
    SyncMarkerInfos.super.ctor(self, ...);
end

-- 进入操作
function SyncMarkerInfos:OnEnterState()
	-- print("发送请求标记")
    local msg = require("MessageCommon/Msg/C2L/Player/SyncMarkerInfo").new();
    msg:SetMessageId(C2L_Player.SyncMarkerInfo);
    NetService:Instance():SendMessage(msg);
end

function SyncMarkerInfos:CanEnterState(stateType)
    if stateType == LoginStateType.RequestRecruitInfo then
        return true;
    end
    
    return false;
end

-- 离开操作
function SyncMarkerInfos:OnLeaveState(...)
end

return SyncMarkerInfos;
