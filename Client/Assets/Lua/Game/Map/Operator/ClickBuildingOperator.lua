-- 点击建筑物
local BaseOperator = require("Game/Map/Operator/BaseOperator")

local ClickBuildingOperator = class("ClickBuildingOperator", BaseOperator)

-- 构造函数
function ClickBuildingOperator:ctor()
    ClickBuildingOperator.super.ctor(self, OperatorType.ZoomOut);
end

-- 是否可以进入状态
function ClickBuildingOperator:CanEnterOperator(operatorType)
    if operatorType == OperatorType.ZoomOut or operatorType == OperatorType.Extension then
        return true;
    end

    return false;
end

return ClickBuildingOperator;
