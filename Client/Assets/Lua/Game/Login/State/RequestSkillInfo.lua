-- 请求技能信息
local BaseState = require("Game/State/BaseState")

local RequestSkillInfo = class("RequestSkillInfo", BaseState)

-- 构造函数
function RequestSkillInfo:ctor(...)
    RequestSkillInfo.super.ctor(self, ...);
end

-- 进入操作
function RequestSkillInfo:OnEnterState(...)
    local msg = require("MessageCommon/Msg/C2L/Skill/GetOnePlayerSkillList").new()
    msg:SetMessageId(C2L_Skill.GetOnePlayerSkillList)
    NetService:Instance():SendMessage(msg)
end


function RequestSkillInfo:CanEnterState(stateType)
    if stateType == LoginStateType.RequestSourceEvent then
        return true;
    end
    return false;
end

-- 离开操作
function RequestSkillInfo:OnLeaveState(...)
end

return RequestSkillInfo;
