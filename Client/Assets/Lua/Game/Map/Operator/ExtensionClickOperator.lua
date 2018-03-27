-- 扩建之后的点击操作
local BaseOperator = require("Game/Map/Operator/BaseOperator")

local ExtensionClickOperator = class("ExtensionClickOperator", BaseOperator)

-- 构造函数
function ExtensionClickOperator:ctor()
    ExtensionClickOperator.super.ctor(self, OperatorType.ZoomOut);
end

-- 是否可以进入状态
function ExtensionClickOperator:CanEnterOperator(operatorType)
	--print(operatorType)
    if operatorType == OperatorType.Extension or operatorType == OperatorType.ExtensionClick or operatorType == OperatorType.ZoomOut then
        return true;
    end

    return false;
end

return ExtensionClickOperator;
