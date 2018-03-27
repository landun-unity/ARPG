-- 所有操作的基类
local BaseState = class("BaseState")

-- 构造函数
function BaseState:ctor(stateType)
    self.stateType = stateType
    self.enterFunction = nil;
    self.leaveFunction = nil;
end

-- 设置回调
function BaseState:SetCallBack(enterFunction, leaveFunction)
    self.enterFunction = enterFunction;
    self.leaveFunction = leaveFunction;
end

-- 是否可以进入状态
function BaseState:CanEnterState(stateType)
    return true;
end

-- 进入操作
function BaseState:EnterState(...)
    self:OnEnterState(...);
    if self.enterFunction == nil then
        return;
    end

    self.enterFunction(...);
end

-- 进入操作
function BaseState:OnEnterState(...)
end

-- 离开操作
function BaseState:LeaveState(...)
    self:OnLeaveState(...);
    if self.leaveFunction == nil then
        return;
    end

    self.leaveFunction(...);
end

-- 离开操作
function BaseState:OnLeaveState(...)
end

return BaseState;