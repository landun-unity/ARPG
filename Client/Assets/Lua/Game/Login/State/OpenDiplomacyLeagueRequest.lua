--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local BaseState = require("Game/State/BaseState")

local OpenDiplomacyLeagueRequest = class("OpenDiplomacyLeagueRequest", BaseState)

-- 构造函数
function OpenDiplomacyLeagueRequest:ctor(...)
    OpenDiplomacyLeagueRequest.super.ctor(self, ...);
end

-- 进入操作
function OpenDiplomacyLeagueRequest:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/League/OpenDiplomacyLeagueRequest").new()
    msg:SetMessageId(C2L_League.OpenDiplomacyLeagueRequest)
    NetService:Instance():SendMessage(msg)
end


function OpenDiplomacyLeagueRequest:CanEnterState(stateType)
    if stateType == LoginStateType.RequestLeagueInfo then
        return true;
    end
    
    return false;
end

-- 离开操作
function OpenDiplomacyLeagueRequest:OnLeaveState(...)
end

return OpenDiplomacyLeagueRequest;

--endregion
