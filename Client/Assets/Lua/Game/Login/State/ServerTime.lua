-- 请求技能信息
local BaseState = require("Game/State/BaseState")

local ServerTime = class("ServerTime", BaseState)

-- 构造函数
function ServerTime:ctor(...)
    ServerTime.super.ctor(self, ...);
end

-- 进入操作
function ServerTime:OnEnterState()
    local msg = require("MessageCommon/Msg/C2L/Player/SyncServerTimeRequest").new();
    msg:SetMessageId(C2L_Player.SyncServerTimeRequest);
    NetService:Instance():SendMessage(msg,false);

  
end

function ServerTime:CanEnterState(stateType)

end

-- 离开操作
function ServerTime:OnLeaveState(...)
end

return ServerTime;
