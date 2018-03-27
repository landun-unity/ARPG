-- 状态管理
StateManage = class("StateManage")

-- 状态管理
function StateManage:ctor()
    -- 所有的状态Map
    self.allStateMap = { };
    -- 当前的状态
    StateManage._instance = self;
    self.curState = nil;
end

function StateManage:Instance()
    return StateManage._instance;
end


-- 进入状态
function StateManage:EnterState(stateType, ...)
    if self.curState ~= nil and self.curState:CanEnterState(stateType) == false then
        return;
    end
    -- print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX----------" .. stateType)
    local stateObject = self:FindState(stateType);
    if stateObject == nil then
        return;
    end
    if self.curState ~= nil then
        self.curState:LeaveState(...);
    end
    self.curState = stateObject;
    self.curState:EnterState(...);
end


-- 获取当前Self.Curstate
function StateManage:GetCurState()
    return self.curState
end

function StateManage:SetCurState(obj)
    self.curState = obj
end


-- 注册状态
function StateManage:RegisterState(stateType, stateClass)
    if stateType == nil or type(stateType) ~= "number" then
        return;
    end

    self.allStateMap[stateType] = require(stateClass).new(stateType);
end

-- 注册状态的回调
function StateManage:RegisterCallBack(stateType, enterFunction, leaveFunction)
    local StateObject = self.allStateMap[stateType];
    if StateObject == nil then
        return;
    end

    StateObject:SetCallBack(enterFunction, leaveFunction);
end

-- 查找状态类
function StateManage:FindState(stateType)
    if stateType == nil or type(stateType) ~= "number" then
        return nil;
    end
    return self.allStateMap[stateType];
end

-- 检查登录状态 
function StateManage:IsState(state)
    if state == nil or self.curState == nil then
        return false;
    end
    return state == self.curState.stateType;
end

return StateManage;

