--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local BaseState = require("Game/State/BaseState")

local RequestPlayerInfluence = class("RequestPlayerInfluence", BaseState)

-- 构造函数
function RequestPlayerInfluence:ctor(...)
    RequestPlayerInfluence.super.ctor(self, ...);
end

-- 进入操作
function RequestPlayerInfluence:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Player/RequestPlayerInfluence").new()
    msg:SetMessageId(C2L_Player.RequestPlayerInfluence)
    NetService:Instance():SendMessage(msg)
end


function RequestPlayerInfluence:CanEnterState(stateType)
    if stateType == LoginStateType.EnterGame then
        return true;
    end
    
    return false;
end

-- 离开操作
function RequestPlayerInfluence:OnLeaveState(...)
end

return RequestPlayerInfluence;

--endregion
