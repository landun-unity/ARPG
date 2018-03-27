-- 空的操作
local BaseOperator = require("Game/Map/Operator/BaseOperator")

local BeginOperator = class("BeginOperator", BaseOperator)

-- 构造函数
function BeginOperator:ctor()
    BeginOperator.super.ctor(self, OperatorType.Click);
end

-- 是否可以进入状态
function BeginOperator:CanEnterOperator(operatorType)
    if  operatorType == OperatorType.Click and GuideServcice:Instance():GetIsFinishGuide() == true then
        return true;
    end

    if operatorType == OperatorType.Move and GuideServcice:Instance():GetIsFinishGuide() == true then
        return true;
    end

    return false;
end

return BeginOperator;
