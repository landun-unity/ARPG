-- 登录消息处理
local BaseState = require("Game/State/BaseState")

local RequestCurrencyInfo = class("RequestCurrencyInfo", BaseState)

-- 构造函数
function RequestCurrencyInfo:ctor(...)
    RequestCurrencyInfo.super.ctor(self, ...);
end

-- 进入操作
function RequestCurrencyInfo:OnEnterState(...)
    CurrencyService:Instance():RequestCurrencyInfo();
end

-- 离开操作
function RequestCurrencyInfo:OnLeaveState(...)
end

-- 请求金钱之后请求建筑物信息
function RequestCurrencyInfo:CanEnterState(stateType)
    if stateType == LoginStateType.RequestBuildingInfo then
        return true;
    end
    return false;
end

return RequestCurrencyInfo;
