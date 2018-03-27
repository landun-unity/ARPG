-- 空的操作
local BaseOperator = require("Game/Map/Operator/BaseOperator")

local CancleClickOperator = class("CancleClickOperator", BaseOperator)

-- 构造函数
function CancleClickOperator:ctor()
    CancleClickOperator.super.ctor(self, OperatorType.Click);
end

-- 是否可以进入状态
function CancleClickOperator:CanEnterOperator(operatorType)
    if operatorType == OperatorType.Empty then
        return true;
    end

    return false;
end

return CancleClickOperator;
