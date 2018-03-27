require("Game/Map/Operator/OperatorType")

-- 所有操作的基类
local BaseOperator = class("BaseOperator")

-- 构造函数
function BaseOperator:ctor(operatorType)
    self.operatorType = operatorType
    self.enterFunction = nil;
    self.leaveFunction = nil;
end

-- 设置回调
function BaseOperator:SetCallBack(enterFunction, leaveFunction)
    self.enterFunction = enterFunction;
    self.leaveFunction = leaveFunction;
end

-- 是否可以进入状态
function BaseOperator:CanEnterOperator(operatorType)
    return true;
end

-- 进入操作
function BaseOperator:EnterOperator(...)
    if self.enterFunction == nil then
        return;
    end

    self.enterFunction(...);
end

-- 离开操作
function BaseOperator:LeaveOperator(...)
    if self.leaveFunction == nil then
        return;
    end

    self.leaveFunction(...);
end

return BaseOperator;