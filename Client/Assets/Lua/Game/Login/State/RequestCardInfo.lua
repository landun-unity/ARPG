-- 请求技能信息
local BaseState = require("Game/State/BaseState")

local RequestCardInfo = class("RequestCardInfo", BaseState)

-- 构造函数
function RequestCardInfo:ctor(...)
    RequestCardInfo.super.ctor(self, ...);
end

-- 进入操作
function RequestCardInfo:OnEnterState(...)
    print("进入操作    请求卡牌信息");
    HeroService:Instance():RequestHeroCard(1);
end

function RequestCardInfo:CanEnterState(stateType)
    if stateType == LoginStateType.RequestSkillInfo then
        return true;
    end
    return false;
end

-- 离开操作
function RequestCardInfo:OnLeaveState(...)
end

return RequestCardInfo;
