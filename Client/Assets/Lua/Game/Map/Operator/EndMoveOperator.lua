-- 结束移动的操作
local BaseOperator = require("Game/Map/Operator/BaseOperator")

local EndMoveOperator = class("EndMoveOperator", BaseOperator)

-- 构造函数
function EndMoveOperator:ctor()
    EndMoveOperator.super.ctor(self, OperatorType.ZoomOut);
end

-- 是否可以进入状态
function EndMoveOperator:CanEnterOperator(operatorType)
    if operatorType == OperatorType.Empty or operatorType == OperatorType.CancleClick then
        return true;
    end

    return false;
end

return EndMoveOperator;
