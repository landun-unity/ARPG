-- 请求部队信息
local BaseState = require("Game/State/BaseState")

local SynMarkerInfo = class("SynMarkerInfo", BaseState)

-- 构造函数
function SynMarkerInfo:ctor(...)
    SynMarkerInfo.super.ctor(self, ...);
end

-- 进入操作
function SynMarkerInfo:OnEnterState() 	 	 
    local msg = require("MessageCommon/Msg/C2L/Player/SyncMarkerInfo").new();
    msg:SetMessageId(C2L_Player.SyncMarkerInfo);
    NetService:Instance():SendMessage(msg);
end

-- 离开操作
function SynMarkerInfo:OnLeaveState(...)
end

return SynMarkerInfo;
