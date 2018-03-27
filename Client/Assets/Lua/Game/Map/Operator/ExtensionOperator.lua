-- 扩建状态
local BaseOperator = require("Game/Map/Operator/BaseOperator")

local ExtensionOperator = class("ExtensionOperator", BaseOperator)

-- 构造函数
function ExtensionOperator:ctor()
    ExtensionOperator.super.ctor(self, OperatorType.ZoomOut);
end

-- 是否可以进入状态
function ExtensionOperator:CanEnterOperator(operatorType)
    -- 扩建状态可以做点击和返回原来的状态
    if operatorType == OperatorType.ZoomOut or operatorType == OperatorType.ExtensionClick then
        return true;
    end

    return false;
end

return ExtensionOperator;
