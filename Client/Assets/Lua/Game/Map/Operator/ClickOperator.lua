-- 空的操作
local BaseOperator = require("Game/Map/Operator/BaseOperator")

local ClickOperator = class("ClickOperator", BaseOperator)

-- 构造函数
function ClickOperator:ctor()
    ClickOperator.super.ctor(self, OperatorType.Click);
end

-- 是否可以进入状态
function ClickOperator:CanEnterOperator(operatorType)
    if operatorType == OperatorType.Begin or operatorType == OperatorType.Empty then
        return true;
    end

    return false;
end

return ClickOperator;
