-- 空的操作
local BaseOperator = require("Game/Map/Operator/BaseOperator")

local MoveOperator = class("MoveOperator", BaseOperator)

-- 构造函数
function MoveOperator:ctor()
    MoveOperator.super.ctor(self, OperatorType.ZoomOut);
end

-- 是否可以进入状态
function MoveOperator:CanEnterOperator(operatorType)
    if operatorType == OperatorType.Move or operatorType == OperatorType.EndMove then
        return true;
    end

    return false;
end

return MoveOperator;
