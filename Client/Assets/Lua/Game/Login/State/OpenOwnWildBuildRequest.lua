
local BaseState = require("Game/State/BaseState")

local OpenOwnWildBuildRequest = class("OpenOwnWildBuildRequest", BaseState)

-- 构造函数
function OpenOwnWildBuildRequest:ctor(...)
    OpenOwnWildBuildRequest.super.ctor(self, ...);
end

-- 进入操作
function OpenOwnWildBuildRequest:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/League/OpenOwnWildBuildRequest").new()
    msg:SetMessageId(C2L_League.RequestTiledIdInfo)
    NetService:Instance():SendMessage(msg)
end

-- 离开操作
function OpenOwnWildBuildRequest:OnLeaveState(...)
end

return OpenOwnWildBuildRequest;
