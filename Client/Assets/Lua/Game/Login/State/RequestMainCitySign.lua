-- 请求标记信息
local BaseState = require("Game/State/BaseState")

local RequestMainCitySign = class("RequestMainCitySign", BaseState)

-- 构造函数
function RequestMainCitySign:ctor(...)
    RequestMainCitySign.super.ctor(self, ...);
end

-- 进入操作
function RequestMainCitySign:OnEnterState()
    -- print("发送请求标记-------------------")
    local msg = require("MessageCommon/Msg/C2L/Player/SyncMainCitySign").new();
    msg:SetMessageId(C2L_Player.SyncMainCitySign);
    NetService:Instance():SendMessage(msg);
end

-- 离开操作
function RequestMainCitySign:OnLeaveState(...)
end

return RequestMainCitySign;

