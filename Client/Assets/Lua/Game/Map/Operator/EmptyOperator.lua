-- 空的操作
local BaseOperator = require("Game/Map/Operator/BaseOperator")
local EmptyOperator = class("EmptyOperator", BaseOperator)

-- 构造函数
function EmptyOperator:ctor()
    EmptyOperator.super.ctor(self, OperatorType.Empty);
end

-- 是否可以进入状态
function EmptyOperator:CanEnterOperator(operatorType)
    if operatorType == OperatorType.ExtensionClick or operatorType == OperatorType.Extension or operatorType == OperatorType.ClickBuilding then
        return false;
    end

    return true;
end

return EmptyOperator;
