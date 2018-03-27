-- 请求招募消息
local BaseState = require("Game/State/BaseState")

local RequestRecruitInfo = class("RequestRecruitInfo", BaseState)

-- 构造函数
function RequestRecruitInfo:ctor(...)
    RequestRecruitInfo.super.ctor(self, ...);
end

-- 进入操作
function RequestRecruitInfo:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Recruit/GetAllRecruitList").new()
    msg:SetMessageId(C2L_Recruit.GetAllRecruitList)
    NetService:Instance():SendMessage(msg)
end
function RequestRecruitInfo:CanEnterState(stateType)
    if stateType == LoginStateType.OpenDiplomacyLeagueRequest then
        return true;
    end

    return false;
end
-- 离开操作
function RequestRecruitInfo:OnLeaveState(...)
end

return RequestRecruitInfo;
